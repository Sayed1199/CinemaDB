import 'dart:convert';
import 'package:cinema_db/models/collection_model.dart';
import 'package:cinema_db/models/company_model.dart';
import 'package:cinema_db/models/genres_model.dart';
import 'package:cinema_db/models/movide_ids_model.dart';
import 'package:cinema_db/models/movie_image_model.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:cinema_db/models/person_ids_mdoel.dart';
import 'package:cinema_db/models/person_model.dart';
import 'package:cinema_db/models/popular_person_model.dart';
import 'package:cinema_db/models/release_date_model.dart';
import 'package:cinema_db/models/similar_movies_model.dart';
import 'package:cinema_db/models/tvShow_details_model.dart';
import 'package:cinema_db/models/tvShow_model.dart';
import 'package:cinema_db/models/tvShow_season_details_model.dart';
import 'package:cinema_db/models/video_model.dart';
import 'package:http/http.dart' as http;

class TmdbApi{

  String baseUrl = 'https://api.themoviedb.org/3/';

  Future<List<Genres>> getGenres(String mapiKey)async{
    String url = baseUrl+'genre/movie/list?api_key=${mapiKey}&language=en-US';
    http.Response response =await http.get(Uri.parse(url),headers: null);
    List<Genres> genres = [];
    List<dynamic> li = jsonDecode(response.body)['genres'];
    li.forEach((element) {
      genres.add(Genres.fromJson(element));
    });

    return genres;
  }




  Future<MovieModel> getMovieDetails(String mApiKey,int id)async{

    String url = baseUrl+'movie/$id?api_key=$mApiKey&language=en-US';
    http.Response response =await http.get(Uri.parse(url),headers: null);
    return MovieModel.fromJson(jsonDecode(response.body));

  }

  Future<CollectionsModel> getCollectionDetails(String mapiKey,int collectionID)async{
    String url = baseUrl+'collection/$collectionID?api_key=$mapiKey&language=en-US';
    http.Response response =await http.get(Uri.parse(url),headers: null);
    return CollectionsModel.fromJson(jsonDecode(response.body));
  }

  Future<CompanyModel> getCompanyDetails(String mapiKey,int companyID)async{

    String url = baseUrl + 'company/$companyID?api_key=$mapiKey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return CompanyModel.fromJson(jsonDecode(response.body));

  }

  Future<List<MovieModel>> searchMoviesByIMDBID(String mapiKey,String movieID)async{
    List<MovieModel> finList=[];
    String url = baseUrl+'find/$movieID?api_key=$mapiKey&language=en-US&external_source=imdb_id';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> moviesMap = jsonDecode(response.body)['movie_results'];
    moviesMap.forEach((element) {
      finList.add(MovieModel.fromJson(element));
    });
    return finList;
  }


  Future<MovieIDSModel> getMovieIDs(String mapiKey,int movieID)async{

    String url = baseUrl+'movie/$movieID/external_ids?api_key=$mapiKey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return MovieIDSModel.fromJson(jsonDecode(response.body));

  }

  Future<List<String>> getMovieImages(String mapiKey,int movieID)async{
    List<String> output=[];
    String url = baseUrl+'movie/$movieID/images?api_key=$mapiKey&include_image_language=null,en';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> posters= jsonDecode(response.body)['posters'];
    List<dynamic> backdrops= jsonDecode(response.body)['backdrops'];
    posters.forEach((element) {
      output.add(element['file_path']);
    });
    backdrops.forEach((element) {
      output.add(element['file_path']);
    });
    return output;
  }

  Future<List<MovieModel>> getMovieRecommendations(String mapikey,int movieID)async{
    List<MovieModel> moviesList=[];
    String preUrl = baseUrl + 'movie/$movieID/recommendations?api_key=$mapikey&language=en-US&page=1';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = await jsonDecode(response.body)['total_pages'];
    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'movie/$movieID/recommendations?api_key=$mapikey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> moviesMap = jsonDecode(response.body)['results'];
      moviesMap.forEach((element) {
        moviesList.add(MovieModel.fromJson(element));
      });
    }
    return moviesList;

  }

  Future<List<ReleaseDatesModel>> getMovieReleaseDates(String mapikey,int movieID)async{
    List<ReleaseDatesModel> releaseDatesList=[];
    String url = baseUrl + 'movie/$movieID/release_dates?api_key=$mapikey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['results'];
    mList.forEach((element) {
      releaseDatesList.add(ReleaseDatesModel.fromJson(element));
    });
  return releaseDatesList;
  }

  Future<SimilarMoviesModel> getSimilarMovieModelByPage(String mapikey,int movieID,int page)async{

    String url = baseUrl + 'movie/$movieID/similar?api_key=$mapikey&language=en-US&page=$page';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return SimilarMoviesModel.fromJson(jsonDecode(response.body));

  }


  Future<List<MovieModel>> getAllSimilarMovieModels(String mapikey,int movieID)async{
    String firstUrl = baseUrl + 'movie/$movieID/similar?api_key=$mapikey&language=en-US&page=1';
    int totalPages = await getMaxPageNum(firstUrl);
    List<MovieModel> output=[];

    for(int i=1;i<=totalPages;i++){
      String url =baseUrl + 'movie/$movieID/similar?api_key=$mapikey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> moviesList = jsonDecode(response.body)['results'];
      moviesList.forEach((element) {
        output.add(MovieModel.fromJson(element));
      });
    }

      return output;

  }



  Future<List<MovieVideosModel>> getMovieVideos(String mapikey,int movieID)async{
    List<MovieVideosModel> videos=[];
    String url = baseUrl + 'movie/$movieID/videos?api_key=$mapikey&language=en-US';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['results'];

    mList.forEach((element) {
      videos.add(MovieVideosModel.fromJson(element));
    });

    return videos;

  }

  Future<MovieModel> getLatestSingleMovie(String mapikey)async{
    String url = baseUrl + 'movie/latest?api_key=$mapikey&language=en-US';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return MovieModel.fromJson(jsonDecode(response.body));
  }

  Future<int> getMaxPageNum(String url)async{
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return jsonDecode(response.body)['total_pages'];
  }

  Future<List<MovieModel>> getNowPlayingMoviesByPage(String mapikey,int page)async{
    List<MovieModel> output=[];
    String url = baseUrl + 'movie/now_playing?api_key=$mapikey&language=en-US&page=$page';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> moviesList = jsonDecode(response.body)['results'];
    moviesList.forEach((element) {
      output.add(MovieModel.fromJson(element));
    });
    return output;
  }



  Future<List<MovieModel>> getAllNowPlayingMovies(String mapikey)async{

    List<MovieModel> output=[];
    String urlFirst = baseUrl + 'movie/now_playing?api_key=$mapikey&language=en-US&page=1';
    int totalPages = await getMaxPageNum(urlFirst);

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'movie/now_playing?api_key=$mapikey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> moviesList = jsonDecode(response.body)['results'];
      moviesList.forEach((element) {
        output.add(MovieModel.fromJson(element));
      });
    }

    return output;

  }


  Future<List<MovieModel>> getPopularMoviesByPage(String mapikey,int page)async{
    List<MovieModel> output=[];
    String url = baseUrl + 'movie/popular?api_key=$mapikey&language=en-US&page=$page';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> moviesList = jsonDecode(response.body)['results'];
    moviesList.forEach((element) {
      output.add(MovieModel.fromJson(element));
    });
    return output;
  }


  Future<List<MovieModel>> getAllPopularMovies(String mapikey)async{

    List<MovieModel> output=[];
    String urlFirst = baseUrl + 'movie/popular?api_key=$mapikey&language=en-US&page=1';
    int totalPages = await getMaxPageNum(urlFirst);

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'movie/popular?api_key=$mapikey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> moviesList = jsonDecode(response.body)['results'];
      moviesList.forEach((element) {
        output.add(MovieModel.fromJson(element));
      });
    }

    return output;

  }

  Future<List<MovieModel>> getTopRatedMoviesByPage(String mapikey,int page)async{
    List<MovieModel> output=[];
    String url = baseUrl + 'movie/top_rated?api_key=$mapikey&language=en-US&page=$page';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> moviesList = jsonDecode(response.body)['results'];
    moviesList.forEach((element) {
      output.add(MovieModel.fromJson(element));
    });
    return output;
  }


  Future<List<MovieModel>> getAllTopRatedMovies(String mapikey)async{

    List<MovieModel> output=[];
    String urlFirst = baseUrl + 'movie/top_rated?api_key=$mapikey&language=en-US&page=1';
    int totalPages = await getMaxPageNum(urlFirst);

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'movie/top_rated?api_key=$mapikey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> moviesList = jsonDecode(response.body)['results'];
      moviesList.forEach((element) {
        output.add(MovieModel.fromJson(element));
      });
    }

    return output;

  }

  Future<List<MovieModel>> getUpcomingMoviesByPage(String mapikey,int page)async{
    List<MovieModel> output=[];
    String url = baseUrl + 'movie/upcoming?api_key=$mapikey&language=en-US&page=$page';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> moviesList = jsonDecode(response.body)['results'];
    moviesList.forEach((element) {
      output.add(MovieModel.fromJson(element));
    });
    return output;
  }


  Future<List<MovieModel>> getAllUpComingMovies(String mapikey)async{

    List<MovieModel> output=[];
    String urlFirst = baseUrl + 'movie/upcoming?api_key=$mapikey&language=en-US&page=1';
    int totalPages = await getMaxPageNum(urlFirst);

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'movie/upcoming?api_key=$mapikey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> moviesList = jsonDecode(response.body)['results'];
      moviesList.forEach((element) {
        output.add(MovieModel.fromJson(element));
      });
    }

    return output;

  }


  Future<List<MovieModel>> getTrendingDailyMovies(String mapikey)async{
    List<MovieModel> output=[];
    String url = baseUrl + 'trending/movie/day?api_key=$mapikey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> moviesList = jsonDecode(response.body)['results'];
    moviesList.forEach((element) {
      output.add(MovieModel.fromJson(element));
    });
    return output;
  }


  Future<List<MovieModel>> getTrendingWeeklyMovies(String mapikey)async{
    List<MovieModel> output=[];
    String url = baseUrl + 'trending/movie/week?api_key=$mapikey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> moviesList = jsonDecode(response.body)['results'];
    moviesList.forEach((element) {
      output.add(MovieModel.fromJson(element));
    });
    return output;
  }

  Future<List<TvShowModel>> getTrendingDailyTvShows(String mapikey)async{
    List<TvShowModel> output=[];
    String url = baseUrl + 'trending/tv/day?api_key=$mapikey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> moviesList = jsonDecode(response.body)['results'];
    moviesList.forEach((element) {
      output.add(TvShowModel.fromJson(element));
    });
    return output;
  }


  Future<List<TvShowModel>> getTrendingWeeklyTvShows(String mapikey)async{
    List<TvShowModel> output=[];
    String url = baseUrl + 'trending/tv/week?api_key=$mapikey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> moviesList = jsonDecode(response.body)['results'];
    moviesList.forEach((element) {
      output.add(TvShowModel.fromJson(element));
    });
    return output;
  }

  Future<int> getPersonIDFromName(String maApiKey,String name)async{
    String url = baseUrl + 'search/person?api_key=$maApiKey&language=en-US&page=1&include_adult=true&query=$name';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return jsonDecode(response.body)['results'][0]['id'];
  }

  Future<PersonModel> getPersonDetailsByID(String mapiKey,int id)async{

    String url = baseUrl + 'person/$id?api_key=$mapiKey&language=en-US';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return PersonModel.fromJson(jsonDecode(response.body));

  }

  Future<List<String>> getPersonImagesByID(String mapiKey,int id)async{
    List<String> outList=[];
    String url = baseUrl + 'person/$id/images?api_key=$mapiKey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> myList = jsonDecode(response.body)['profiles'];
    myList.forEach((element) {
      outList.add(element['file_path']);
    });
    return outList;
  }

  Future<PersonIDsModel> getPersonExternalIDS(String mapiKey,int id)async{

    String url = baseUrl + 'person/$id/external_ids?api_key=$mapiKey&language=en-US';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return PersonIDsModel.fromJson(jsonDecode(response.body));

  }

  Future<List<PopularPeopleModel>> getAllPopularPeopleWithWorks(String mapiKey)async{

    List<PopularPeopleModel> peoplesList=[];
    String preUrl = baseUrl + 'person/popular?api_key=$mapiKey&language=en-US&page=1';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for(int i=1;i<=totalPages;i++){
      String url =  baseUrl + 'person/popular?api_key=$mapiKey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic>mList = jsonDecode(response.body)['results'];
      mList.forEach((element) {
        peoplesList.add(PopularPeopleModel.fromJson(element));
      });
    }
    return peoplesList;
  }

  Future<List<MovieModel>> searchMovies(String mapiKey,String query,bool includeAdult)async{
    List<MovieModel> moviesList=[];
    String preUrl = baseUrl + 'search/movie?api_key=$mapiKey&language=en-US&page=1&include_adult=$includeAdult&query=$query';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'search/movie?api_key=$mapiKey&language=en-US&page=$i&include_adult=$includeAdult&query=$query';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> mList = jsonDecode(response.body)['results'];
      mList.forEach((element) {
        moviesList.add(MovieModel.fromJson(element));
      });
    }
    print('MoviesList: ${moviesList.length}');
    return moviesList;
  }

  Future<List<PopularPeopleModel>> searchPeople(String mapiKey,String query,bool includeAdult)async{
    List<PopularPeopleModel> peopleList=[];
    String preUrl = baseUrl + 'search/person?api_key=$mapiKey&language=en-US&page=1&include_adult=$includeAdult&query=$query';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'search/person?api_key=$mapiKey&language=en-US&page=$i&include_adult=$includeAdult&query=$query';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> mList = jsonDecode(response.body)['results'];
      mList.forEach((element) {
        peopleList.add(element);
      });
    }
    return peopleList;
  }

  Future<List<TvShowModel>> searchTvShows(String mapiKey,String query,bool includeAdult)async {
    List<TvShowModel> tvShowsList = [];
    String preUrl = baseUrl +
        'search/tv?api_key=$mapiKey&language=en-US&page=1&include_adult=$includeAdult&query=$query';
    http.Response response = await http.get(Uri.parse(preUrl), headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for (int i = 1; i <= totalPages; i++) {
      String url = baseUrl +
          'search/tv?api_key=$mapiKey&language=en-US&page=$i&include_adult=$includeAdult&query=$query';
      http.Response response = await http.get(Uri.parse(url), headers: null);
      print('res: ${response.body}');
      List<dynamic> mList = jsonDecode(response.body)['results'];
      if (mList.isNotEmpty) {
        mList.forEach((element) {
          if(element['vote_count']!=0)
          tvShowsList.add(TvShowModel.fromJson(element));
        });
      }
    }
    print('tvshow: ${tvShowsList.length}');
        return tvShowsList;

  }

  Future<TvShowDetailsModel> getTvShowDetailsByID(String mapiKey,int id)async{

    String url = baseUrl + 'tv/$id?api_key=$mapiKey&language=en-US';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return TvShowDetailsModel.fromJson(jsonDecode(response.body));

  }

  Future<List<String>> getTvShowImages(String mapiKey,int id)async{
    List<String> photosList=[];
    String url = baseUrl + 'tv/$id/images?api_key=$mapiKey&include_image_language=null,en';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> backdrops = jsonDecode(response.body)['backdrops'];
    List<dynamic> posters = jsonDecode(response.body)['posters'];
    backdrops.forEach((element) {
      photosList.add(element['file_path']);
    });
    posters.forEach((element) {
      photosList.add(element['file_path']);
    });

    return photosList;

  }

  Future<List<TvShowModel>> getTvShowsRecommendationsByPage(String mapiKey,int id,int page)async{
    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/$id/recommendations?api_key=$mapiKey&language=en-US&page=$page';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['results'];
    mList.forEach((element) {
      tvshows.add(TvShowModel.fromJson(element));
    });
    return tvshows;
  }

  Future<List<TvShowModel>> getTvShowsRecommendations(String mapiKey,int id)async{

    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/$id/recommendations?api_key=$mapiKey&language=en-US&page=1';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'tv/$id/recommendations?api_key=$mapiKey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> mList = jsonDecode(response.body)['results'];
      mList.forEach((element) {
        tvshows.add(TvShowModel.fromJson(element));
      });
    }
    return tvshows;
  }


  Future<List<TvShowModel>> getSimilarTvShows(String mapiKey,int id)async{

    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/$id/similar?api_key=$mapiKey&language=en-US&page=1';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'tv/$id/similar?api_key=$mapiKey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> mList = jsonDecode(response.body)['results'];
      mList.forEach((element) {
        tvshows.add(TvShowModel.fromJson(element));
      });
    }
    return tvshows;
  }


  Future<List<MovieVideosModel>> getTvShowVideos(String mapiKey,int id)async{
    List<MovieVideosModel> videos=[];
    String url = baseUrl + 'tv/$id/videos?api_key=$mapiKey&language=en-US';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['results'];

    mList.forEach((element) {
      videos.add(MovieVideosModel.fromJson(element));
    });
    return videos;
  }

  Future<TvShowModel> getLatestTvShow(String mapiKey)async{

    String url = baseUrl + 'tv/latest?api_key=$mapiKey&language=en-US';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return TvShowModel.fromJson(jsonDecode(response.body));

  }

  Future<List<TvShowModel>> getAiringTodayTvShowsByPage(String mapiKey,int page)async{

    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/airing_today?api_key=$mapiKey&language=en-US&page=$page';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['results'];
    mList.forEach((element) {
      tvshows.add(TvShowModel.fromJson(element));
    });
    return tvshows;
  }


  Future<List<TvShowModel>> getAiringTodayTvShows(String mapiKey)async{

    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/airing_today?api_key=$mapiKey&language=en-US&page=1';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'tv/airing_today?api_key=$mapiKey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> mList = jsonDecode(response.body)['results'];
      mList.forEach((element) {
        tvshows.add(TvShowModel.fromJson(element));
      });
    }
    return tvshows;
  }

  Future<List<TvShowModel>> getOnAirNowTvShowsByPage(String mapiKey,int page)async{

    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/on_the_air?api_key=$mapiKey&language=en-US&page=$page';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['results'];
    mList.forEach((element) {
      tvshows.add(TvShowModel.fromJson(element));
    });
    return tvshows;
  }

  Future<List<TvShowModel>> getOnAirNowTvShows(String mapiKey)async{

    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/on_the_air?api_key=$mapiKey&language=en-US&page=1';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'tv/on_the_air?api_key=$mapiKey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> mList = jsonDecode(response.body)['results'];
      mList.forEach((element) {
        tvshows.add(TvShowModel.fromJson(element));
      });
    }
    return tvshows;
  }

  Future<List<TvShowModel>> getCurrentPopularTvShowsByPage(String mapiKey,int page)async{

    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/popular?api_key=$mapiKey&language=en-US&page=$page';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['results'];
    mList.forEach((element) {
      tvshows.add(TvShowModel.fromJson(element));
    });
    return tvshows;
  }


  Future<List<TvShowModel>> getCurrentPopularTvShows(String mapiKey)async{

    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/popular?api_key=$mapiKey&language=en-US&page=1';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'tv/popular?api_key=$mapiKey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> mList = jsonDecode(response.body)['results'];
      mList.forEach((element) {
        tvshows.add(TvShowModel.fromJson(element));
      });
    }
    return tvshows;
  }

  Future<List<TvShowModel>> getTopRatedTvShowsByPage(String mapiKey,int page)async{

    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/top_rated?api_key=$mapiKey&language=en-US&page=$page';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['results'];
    mList.forEach((element) {
      tvshows.add(TvShowModel.fromJson(element));
    });
    return tvshows;
  }

  Future<List<TvShowModel>> getTopRatedTvShows(String mapiKey)async{

    List<TvShowModel> tvshows=[];
    String preUrl = baseUrl + 'tv/top_rated?api_key=$mapiKey&language=en-US&page=1';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'tv/top_rated?api_key=$mapiKey&language=en-US&page=$i';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> mList = jsonDecode(response.body)['results'];
      mList.forEach((element) {
        tvshows.add(TvShowModel.fromJson(element));
      });
    }
    return tvshows;
  }

  Future<TvSeasonDetailsModel> getTvShowSeasonDetails(String mapiKey,int id, int seasonNumber)async{

    String url = baseUrl + 'tv/$id/season/$seasonNumber}?api_key=$mapiKey&language=en-US';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    return TvSeasonDetailsModel.fromJson(jsonDecode(response.body));

  }

  Future<List<MovieImageModel>> getTvShowSeasonImages(String mapiKey,int id, int seasonNumber)async{
    List<MovieImageModel> output = [];
    String url = baseUrl + 'tv/$id/season/$seasonNumber/images?api_key=$mapiKey&language=en-US';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['posters'];
    mList.forEach((element) {
      output.add(MovieImageModel.fromJson(element));
    });
    return output;
  }

  Future<List<MovieVideosModel>> getTvShowSeasonVideos(String mapiKey,int id, int seasonNumber)async{
    List<MovieVideosModel> output = [];
    String url = baseUrl + 'tv/$id/season/$seasonNumber/videos?api_key=$mapiKey&language=en-US';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['results'];
    mList.forEach((element) {
      output.add(MovieVideosModel.fromJson(element));
    });
    return output;
  }

  Future<List<MovieImageModel>> getTvShowSeasonEpisodeImages(String mapiKey,int id, int seasonNumber,int episodeNumber)async{
    List<MovieImageModel> output = [];
    String url = baseUrl + 'tv/$id/season/$seasonNumber/episode/$episodeNumber/images?api_key=$mapiKey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> mList = jsonDecode(response.body)['stills'];
    mList.forEach((element) {
      output.add(MovieImageModel.fromJson(element));
    });
    return output;
  }

  Future<String> getArabicWatchLink(String maApiKey,int id)async{

    String url = baseUrl + 'movie/$id/watch/providers?api_key=$maApiKey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    Map<String,dynamic> data = jsonDecode(response.body)['results'];
    if(data.isNotEmpty){
      return jsonDecode(response.body)['results']['AR']['link'];
    }else{
      return '';
    }
  }


  Future<List<MovieModel>> getPersonWorks(String mApikey,int id,String name)async{
    List<MovieModel> moviesList=[];
    String preUrl = baseUrl + 'search/person?api_key=$mApikey&language=en-US&page=1&include_adult=true&query=$name';
    http.Response response = await http.get(Uri.parse(preUrl),headers: null);
    int totalPages = jsonDecode(response.body)['total_pages'];

    for(int i=1;i<=totalPages;i++){
      String url = baseUrl + 'search/person?api_key=$mApikey&language=en-US&page=$i&include_adult=true&query=$name';
      http.Response response = await http.get(Uri.parse(url),headers: null);
      List<dynamic> sList = jsonDecode(response.body)['results'];
      for(int j=0;j<sList.length;j++){
        if(jsonDecode(response.body)['results'][j]['id']==id){
          List<dynamic> myList = jsonDecode(response.body)['results'][j]['known_for'];
          myList.forEach((element) {
            moviesList.add(MovieModel.fromJson(element));
          });
        }
      }

    }
    return moviesList;
  }


  Future<List<Posters>> getEpisodeImages(int seriesID,String seriesName,String mApikey,int seasonNumber,int episodeNumber)async{
    List<Posters> imagesList=[];
    String url = baseUrl + 'tv/$seriesID-${seriesName.toLowerCase().replaceAll(' ', '-')}/season/$seasonNumber/episode/$episodeNumber/images?api_key=$mApikey';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    List<dynamic> picsList=jsonDecode(response.body)['stills'];
    picsList.forEach((element) {
      imagesList.add(Posters.fromJson(element));
    });
    return imagesList;
  }















}