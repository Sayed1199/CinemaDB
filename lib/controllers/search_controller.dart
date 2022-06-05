import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:cinema_db/models/tvShow_model.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class SearchResultsController extends GetxController{

  var moviesList = Rx<List<MovieModel>>([]);
  var seriesList = Rx<List<TvShowModel>>([]);

  Future<void> getMoviesList(String query)async{

    moviesList.value = await TmdbApi().searchMovies(dotenv.env['MOVIE_API_KEY']!, query, true);

  }

  Future<void> getSeriesList(String query)async{

    seriesList.value = await TmdbApi().searchTvShows(dotenv.env['MOVIE_API_KEY']!, query, true);

  }

}