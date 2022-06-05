import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:cinema_db/models/movie_image_model.dart';
import 'package:cinema_db/models/tvShow_episode_model.dart';
import 'package:cinema_db/models/tvShow_season_details_model.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EpisodeInfoController extends GetxController{

  var mimagesList=Rx<List<String>>([]);
  var guestStars = Rx<List<GuestStars>>([]);


  void getGuestStars(Episodes episode){
    guestStars.value =  episode.guestStars!;
    print(('stars: ${guestStars.value[0].name}'));
  }

  Future<void> getEpisodeImages(int id,String name,int seasonNumber,int episodeNumber)async{

    List<String> imagesListAsStrings=[];
    List<Posters> imagesList = await TmdbApi().getEpisodeImages(id, name, dotenv.env['MOVIE_API_KEY']!, seasonNumber, episodeNumber);
    imagesList.forEach((element) {
      imagesListAsStrings.add(element.filePath!);
    });

    mimagesList.value = imagesListAsStrings;
    
  }

}