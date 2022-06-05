import 'package:cinema_db/apis/omdb_api.dart';
import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:cinema_db/models/movie_details_model.dart';
import 'package:cinema_db/models/person_model.dart';
import 'package:cinema_db/models/tvShow_details_model.dart';
import 'package:cinema_db/models/tvShow_season_details_model.dart';
import 'package:cinema_db/models/video_model.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SeriesInfoController extends GetxController{

  var seriesdetails = Rx<TvShowDetailsModel?>(null);
  var seriesOmdbDetails = Rx<MovieDetailsModel?>(null);
  var tvShowPhotosList=Rx<List<String>>([]);
  var seriesVideosList = Rx<List<MovieVideosModel>>([]);
  var castList= Rx<List<PersonModel>>([]);
  var direcList=Rx<List<PersonModel>>([]);
  var seasonsList= Rx<List<TvSeasonDetailsModel>>([]);

  Future<void> getTvShowSeasons(int id,int maxSeasons)async{

    List<TvSeasonDetailsModel> mseasonsList=[];

    for(int i=1;i<=maxSeasons;i++){
      TvSeasonDetailsModel season = await TmdbApi().getTvShowSeasonDetails(dotenv.env['MOVIE_API_KEY']!, id ,i);
      mseasonsList.add(season);
    }
    seasonsList.value=mseasonsList;
  }

  Future<void> getCastDetails(List<String> namesList)async{
    List<PersonModel> personsList=[];
    for(String s in namesList){
      int personID = await TmdbApi().getPersonIDFromName(dotenv.env['MOVIE_API_KEY']!, s);
      PersonModel personModel = await TmdbApi().getPersonDetailsByID(dotenv.env['MOVIE_API_KEY']!, personID);
      personsList.add(personModel);
    }
    castList.value = personsList;
  }

  Future<void> getDirectorsDetails(List<String> directorsList)async{
    List<PersonModel> personsList=[];
    String finalString ='';
    for(String s in directorsList){
      if(s.contains('(')){
        finalString = s.substring(1,s.indexOf('('));
      }else{
        finalString = s;
      }

      int personID = await TmdbApi().getPersonIDFromName(dotenv.env['MOVIE_API_KEY']!, finalString);
      PersonModel personModel = await TmdbApi().getPersonDetailsByID(dotenv.env['MOVIE_API_KEY']!, personID);
      personsList.add(personModel);
    }
    direcList.value=personsList;
  }

  Future<void> getSeriesVideos(int id)async{
    seriesVideosList.value = await TmdbApi().getTvShowVideos(dotenv.env['MOVIE_API_KEY']!, id);
    print('video: ${seriesVideosList.value[0].key}');
  }

  Future<void> initializeInfoController(int id)async{
    seriesdetails.value = await TmdbApi().getTvShowDetailsByID(dotenv.env['MOVIE_API_KEY']!, id);
    seriesOmdbDetails.value = await OmdbApi().getMovieDetailsByTitle(dotenv.env['MOVIE_DETAILS_API_KEY']!, seriesdetails.value!.name!);
    tvShowPhotosList.value = await TmdbApi().getTvShowImages(dotenv.env['MOVIE_API_KEY']!, id);
    await getTvShowSeasons(id,seriesdetails.value!.numberOfSeasons!);
    await getSeriesVideos(id);
    await getCastDetails(seriesOmdbDetails.value!.actors!.split(','));
    await getDirectorsDetails(
        seriesOmdbDetails.value!.director!.contains(',')?
        seriesOmdbDetails.value!.director!.split(','):
        [seriesOmdbDetails.value!.director!]
    );
    print('list: ${tvShowPhotosList.value.length}');
  }


}

