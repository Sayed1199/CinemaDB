import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:cinema_db/services/database.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SaveMoviesController extends GetxController{

  var movieSaved = Rx<bool>(false);
  var savedMoviesList = Rx<List<MovieModel>?>(null);

  Future<void> checkMovieExists(int id)async{

    await getSavedMovies();
    if(savedMoviesList.value != null && savedMoviesList.value!.isNotEmpty) {
      for (int i = 0; i < savedMoviesList.value!.length; i++) {
          if(savedMoviesList.value![i].id == id){
            movieSaved.value=true;
            break;
          }
      }
    }else{
      movieSaved.value=false;
    }
  }

  Future<void> getSavedMovies()async{
    List<MovieModel> moviesList=[];
    MyDatabase db = MyDatabase();
    await db.init();
    List<Map<String,dynamic>> mList = await db.query(MyDatabase().savedMoviesTable);
    if(mList.isNotEmpty) {
      for (int i = 0; i < mList.length; i++) {
        MovieModel movie = await TmdbApi().getMovieDetails(
            dotenv.env['MOVIE_API_KEY']!, mList[i]['movieID']);
        moviesList.add(movie);
      }
    }
    print('length: ${moviesList.length}');
    savedMoviesList.value = moviesList;
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }


}