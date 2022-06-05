import 'dart:async';
import 'dart:math';
import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:cinema_db/models/tvShow_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
class TvShowController extends GetxController{

  var selectedCategory = Rx<int>(0);
  var selectedGenre = Rx<int>(0);
  var allTvShowsList = Rx<List<TvShowModel>>([]);
  var currentIndex= Rx<int>(0);
  var trendingTvShowsList = Rx<List<TvShowModel>>([]);
  var trendingCurrentIndex= Rx<int>(0);
  var recommendedTvShowsList = Rx<List<TvShowModel>>([]);
  var recommendedCurrentIndex= Rx<int>(0);
  var isDaily = Rx<bool>(true);
  var recommendationID = Rx<int>(0);



  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    await mapTrendingMovies(isDaily.value);
    await mapPreLoadingCategory(selectedCategory.value);
    print('length: pre series: ${allTvShowsList.value.length}');
    //await mapCategory(selectedCategory.value);
    print('length: all series: ${allTvShowsList.value.length}');
    ever(selectedCategory,_changeCategory);
    ever(isDaily,_checkForIsDaily);
    ever(currentIndex, _changeRecommendations);
    //ever(selectedGenre,_changeGenre);
  }

  _changeRecommendations(int movieID){
    getRecommendations(allTvShowsList.value[movieID].id!);
  }

  _checkForIsDaily(bool data)async{
    if(data==false){
      await mapTrendingMovies(false);
    }else{
      await mapTrendingMovies(true);
    }
  }


  getRecommendations(int id)async{
    recommendedTvShowsList.value = await TmdbApi().getTvShowsRecommendations(dotenv.env['MOVIE_API_KEY']!,id);
    if(recommendedTvShowsList.value.isEmpty) {
      recommendedTvShowsList.value = await TmdbApi().getTvShowsRecommendations(
          dotenv.env['MOVIE_API_KEY']!, [1399,94605,19885,1400,66732,37854,92749][Random().nextInt(7)]);
    }
  }

  Future<void> mapTrendingMovies(bool dayOnly)async{

    if (dayOnly) {
      trendingTvShowsList.value =
      await TmdbApi().getTrendingDailyTvShows(dotenv.env['MOVIE_API_KEY']!);
    } else {
      trendingTvShowsList.value =
      await TmdbApi().getTrendingWeeklyTvShows(dotenv.env['MOVIE_API_KEY']!);

    }
  }


  /*
  _changeGenre(int index)async{
    currentIndex.value=0;
    allTvShowsList.value = await mapGenres(index);
  }

   */

  _changeCategory(int index)async{
    currentIndex.value=0;
    await mapPreLoadingCategory(index);
    //await mapCategory(index);
  }


  /*
  Future<List<TvShowModel>> mapGenres(int index)async{
    switch(index){
      case 0:
        return myTvShowsList.value;
      case 1:
        List<TvShowModel> moviesPerGenre=[];
        allTvShowsList.value.forEach((element) {
          element.genreIds!.forEach((genre) {
            if(genresMap[genre]=='Action'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      case 2:
        List<TvShowModel> moviesPerGenre=[];
        allTvShowsList.value.forEach((element) {
          element.genreIds!.forEach((genre) {
            if(genresMap[genre]=='Animation'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      case 3:
        List<TvShowModel> moviesPerGenre=[];
        allTvShowsList.value.forEach((element) {
          element.genreIds!.forEach((genre) {
            if(genresMap[genre]=='Comedy'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      case 4:
        List<TvShowModel> moviesPerGenre=[];
        allTvShowsList.value.forEach((element) {
          element.genreIds!.forEach((genre) {
            if(genresMap[genre]=='Romance'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      case 5:
        List<TvShowModel> moviesPerGenre=[];
        allTvShowsList.value.forEach((element) {
          element.genreIds!.forEach((genre) {
            if(genresMap[genre]=='Science Fiction'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      case 6:
        List<TvShowModel> moviesPerGenre=[];
        allTvShowsList.value.forEach((element) {
          element.genreIds!.forEach((genre) {
            if(genresMap[genre]=='War'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      case 7:
        List<TvShowModel> moviesPerGenre=[];
        allTvShowsList.value.forEach((element) {
          element.genreIds!.forEach((genre) {
            if(genresMap[genre]=='Horror'){
              moviesPerGenre.add(element);
            }
          });
        });
        return moviesPerGenre;

      default:
        return myTvShowsList.value;
    }
  }

  */

  Future<void> mapPreLoadingCategory(int index)async{
    switch(index){

      case 0:
        allTvShowsList.value = await TmdbApi().getOnAirNowTvShowsByPage(dotenv.env['MOVIE_API_KEY']!,1);
        await getRecommendations(allTvShowsList.value[0].id!);
        allTvShowsList.value =  await TmdbApi().getOnAirNowTvShows(dotenv.env['MOVIE_API_KEY']!);
        break;

      case 1:
        allTvShowsList.value = await TmdbApi().getAiringTodayTvShowsByPage(dotenv.env['MOVIE_API_KEY']!,1);
        await getRecommendations(allTvShowsList.value[0].id!);
        allTvShowsList.value = await TmdbApi().getAiringTodayTvShows(dotenv.env['MOVIE_API_KEY']!);
        break;

      case 2:
        allTvShowsList.value = await TmdbApi().getCurrentPopularTvShowsByPage(dotenv.env['MOVIE_API_KEY']!,1);
        await getRecommendations(allTvShowsList.value[0].id!);
        allTvShowsList.value = await TmdbApi().getCurrentPopularTvShows(dotenv.env['MOVIE_API_KEY']!);
        break;

      case 3:
        allTvShowsList.value = await TmdbApi().getTopRatedTvShowsByPage(dotenv.env['MOVIE_API_KEY']!,1);
        print('toprated series: length pre${allTvShowsList.value.length}');
        await getRecommendations(allTvShowsList.value[0].id!);
        allTvShowsList.value = await TmdbApi().getTopRatedTvShows(dotenv.env['MOVIE_API_KEY']!);
        print('top rated series: length full${allTvShowsList.value.length}');
        break;

    }
  }

}