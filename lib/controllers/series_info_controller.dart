import 'package:cinema_db/apis/omdb_api.dart';
import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:cinema_db/models/actor_model.dart';
import 'package:cinema_db/models/crew_model.dart';
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
  var seasonsList= Rx<List<TvSeasonDetailsModel>>([]);
  var fullCastList=Rx<List<ActorModel>>([]);
  var fullCrewList=Rx<List<CrewModel>>([]);

  Future<void> getTvShowSeasons(int id,int maxSeasons)async{

    List<TvSeasonDetailsModel> mseasonsList=[];

    for(int i=1;i<=maxSeasons;i++){
      TvSeasonDetailsModel season = await TmdbApi().getTvShowSeasonDetails(dotenv.env['MOVIE_API_KEY']!, id ,i);
      mseasonsList.add(season);
    }
    seasonsList.value=mseasonsList;
  }


  Future<void> getSeriesVideos(int id)async{
    seriesVideosList.value = await TmdbApi().getTvShowVideos(dotenv.env['MOVIE_API_KEY']!, id);
    if(seriesVideosList.value.isNotEmpty)
    print('video: ${seriesVideosList.value[0].key}');
  }

  Future<void> initializeInfoController(int id)async{
    seriesdetails.value = await TmdbApi().getTvShowDetailsByID(dotenv.env['MOVIE_API_KEY']!, id);
    seriesOmdbDetails.value = await OmdbApi().getMovieDetailsByTitle(dotenv.env['MOVIE_DETAILS_API_KEY']!, seriesdetails.value!.name!);
    tvShowPhotosList.value = await TmdbApi().getTvShowImages(dotenv.env['MOVIE_API_KEY']!, id);
    await getTvShowSeasons(id,seriesdetails.value!.numberOfSeasons!);
    await getSeriesVideos(id);
    if(seriesOmdbDetails.value != null) await getFullCast(id);
    if(seriesOmdbDetails.value != null) {
      await getFullCrewDetails(id);
    }
    print('list: ${tvShowPhotosList.value.length}');
  }

  Future<void>getFullCast(int id)async {
    fullCastList.value = await TmdbApi().getFullCastSeries(id, dotenv.env['MOVIE_API_KEY']!);
  }
  Future<void> getFullCrewDetails(int id)async{
    fullCrewList.value = await TmdbApi().getFullCrewSeries(id, dotenv.env['MOVIE_API_KEY']!);
  }

  Future<PersonModel> getActorAsPersonModel(int personID)async{
    return await TmdbApi().getPersonDetailsByID(dotenv.env['MOVIE_API_KEY']!, personID);
  }

}

