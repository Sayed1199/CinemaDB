import 'dart:math';

import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
class CategoryNGenreController extends GetxController{

  var selectedCategory = Rx<int>(0);
  var selectedGenre = Rx<int>(0);
  var allMoviesList = Rx<List<MovieModel>>([]);
  var currentIndex= Rx<int>(0);
  var trendingMoviesList = Rx<List<MovieModel>>([]);
  var trendingCurrentIndex= Rx<int>(0);
  var recommendedMoviesList = Rx<List<MovieModel>>([]);
  var recommendedCurrentIndex= Rx<int>(0);
  var isDaily = Rx<bool>(true);
  var recommendationID = Rx<int>(0);



  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    await mapTrendingMovies(isDaily.value);
    await mapPreLoadingCategory(selectedCategory.value);
      print('length movies: ${allMoviesList.value.length}');
    print('trending: ${trendingMoviesList.value.length}');
    //await mapCategory(selectedCategory.value);
     // print('length all: ${allMoviesList.value.length}');

    ever(selectedCategory,_changeCategory);
    ever(isDaily,_checkForIsDaily);
    ever(currentIndex, _changeRecommendations);
    //ever(selectedGenre,_changeGenre);
  }

  _changeCategory(int index)async{
    currentIndex.value=0;
    await mapPreLoadingCategory(index);
    /*
    await mapPreLoadingCategory(index).then((value) async{
      await mapCategory(index);
    });
    */
    print('index is: $index');
  }


  Future<void> mapPreLoadingCategory(int index)async{
    switch(index){

      case 0:
        allMoviesList.value = await TmdbApi().getUpcomingMoviesByPage(dotenv.env['MOVIE_API_KEY']!,1);
        await getRecommendations(allMoviesList.value[0].id!);
        allMoviesList.value = await TmdbApi().getAllUpComingMovies(dotenv.env['MOVIE_API_KEY']!);
        break;

      case 1:
        allMoviesList.value = await TmdbApi().getNowPlayingMoviesByPage(dotenv.env['MOVIE_API_KEY']!,1);
        await getRecommendations(allMoviesList.value[0].id!);
        allMoviesList.value = await TmdbApi().getAllNowPlayingMovies(dotenv.env['MOVIE_API_KEY']!);
        break;

      case 2:
        allMoviesList.value = await TmdbApi().getTopRatedMoviesByPage(dotenv.env['MOVIE_API_KEY']!,1);
        await getRecommendations(allMoviesList.value[0].id!);
        await TmdbApi().getAllTopRatedMovies(dotenv.env['MOVIE_API_KEY']!);
        break;

      case 3:
        allMoviesList.value = await TmdbApi().getPopularMoviesByPage(dotenv.env['MOVIE_API_KEY']!,1);
        await getRecommendations(allMoviesList.value[0].id!);
        await TmdbApi().getAllPopularMovies(dotenv.env['MOVIE_API_KEY']!);
        break;

    }
  }

  /*
  Future<void> mapCategory(int index)async{
    switch(index){

      case 0:
        allMoviesList.value = await TmdbApi().getAllUpComingMovies(dotenv.env['MOVIE_API_KEY']!);
        //moviesList.value = await mapGenres(0);
        break;

      case 1:
        currentIndex.value=0;
        allMoviesList.value = await TmdbApi().getAllNowPlayingMovies(dotenv.env['MOVIE_API_KEY']!);
        break;

      case 2:
        currentIndex.value=0;
        allMoviesList.value = await TmdbApi().getAllTopRatedMovies(dotenv.env['MOVIE_API_KEY']!);
        break;

      case 3:
        currentIndex.value=0;
        allMoviesList.value = await TmdbApi().getAllPopularMovies(dotenv.env['MOVIE_API_KEY']!);
        break;

    }
  }
  */

  Future<void> getRecommendations(int id)async{
    recommendedMoviesList.value = await TmdbApi().getMovieRecommendations(dotenv.env['MOVIE_API_KEY']!,id);
    if(recommendedMoviesList.value.isEmpty)
      recommendedMoviesList.value = await TmdbApi().getMovieRecommendations(dotenv.env['MOVIE_API_KEY']!,[238,278,27205,424,129,496243][Random().nextInt(6)]);

  }


  Future<void> mapTrendingMovies(bool dayOnly)async{

    if (dayOnly) {
      trendingMoviesList.value =
      await TmdbApi().getTrendingDailyMovies(dotenv.env['MOVIE_API_KEY']!);
    } else {
      trendingMoviesList.value =
      await TmdbApi().getTrendingWeeklyMovies(dotenv.env['MOVIE_API_KEY']!);

    }
  }

  _changeRecommendations(int movieID){
    getRecommendations(allMoviesList.value[movieID].id!);
  }

  _checkForIsDaily(bool data)async{
    if(data==false){
      await mapTrendingMovies(false);
    }else{
      await mapTrendingMovies(true);
    }
  }


  /*

  _changeGenre(int index)async{
    currentIndex.value=0;
    moviesList.value = await mapGenres(index);
  }


  Future<List<MovieModel>> mapGenres(int index)async{
    switch(index){
      case 0:
        return myMoviesList.value;
      case 1:
        List<MovieModel> moviesPerGenre=[];
        allMoviesList.value.forEach((element) {
          element.genres!.forEach((genre) {
            if(genresMap[genre]=='Action'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      case 2:
        List<MovieModel> moviesPerGenre=[];
        allMoviesList.value.forEach((element) {
          element.genres!.forEach((genre) {
            if(genresMap[genre]=='Animation'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      case 3:
        List<MovieModel> moviesPerGenre=[];
        allMoviesList.value.forEach((element) {
          element.genres!.forEach((genre) {
            if(genresMap[genre]=='Comedy'){
              moviesPerGenre.add(element);
            }
          });
        });
        print('Comedyy: ${moviesPerGenre.length}');
        return moviesPerGenre;

      case 4:
        List<MovieModel> moviesPerGenre=[];
        allMoviesList.value.forEach((element) {
          element.genres!.forEach((genre) {
            if(genresMap[genre]=='Romance'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      case 5:
        List<MovieModel> moviesPerGenre=[];
        allMoviesList.value.forEach((element) {
          element.genres!.forEach((genre) {
            if(genresMap[genre]=='Science Fiction'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      case 6:
        List<MovieModel> moviesPerGenre=[];
        allMoviesList.value.forEach((element) {
          element.genres!.forEach((genre) {
            if(genresMap[genre]=='War'){
              moviesPerGenre.add(element);
            }
          });
        });
        print('War: ${moviesPerGenre.length}');
        return moviesPerGenre;

      case 7:
        List<MovieModel> moviesPerGenre=[];
        allMoviesList.value.forEach((element) {
          element.genres!.forEach((genre) {
            if(genresMap[genre]=='Horror'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      default:
        return myMoviesList.value;
    }
  }

   */

}