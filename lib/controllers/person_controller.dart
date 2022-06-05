import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class PersonController extends GetxController{

  var imagesList = Rx<List<String>>([]);
  var worksList = Rx<List<MovieModel>>([]);



  Future<void> getPersonWorks(int id,String name)async{
    worksList.value = await TmdbApi().getPersonWorks(dotenv.env['MOVIE_API_KEY']!, id,name);
  }
  Future<void> getImages(int id)async{
    imagesList.value = await TmdbApi().getPersonImagesByID(dotenv.env['MOVIE_API_KEY']!, id);
  }

}