import 'dart:convert';

import 'package:cinema_db/models/movie_details_model.dart';
import 'package:http/http.dart' as http;

class OmdbApi{

  Future<MovieDetailsModel> getMovieDetails(String mApiKey,String imdbID)async{
    String url = 'http://www.omdbapi.com/?apikey=$mApiKey&i=$imdbID';
    http.Response response = await http.get(Uri.parse(url),headers: null);
      MovieDetailsModel movieDetailsModel =MovieDetailsModel.fromJson(jsonDecode(response.body));
      return movieDetailsModel;
  }

  Future<MovieDetailsModel?> getMovieDetailsByTitle(String mApiKey,String title)async{
    String url = 'http://www.omdbapi.com/?apikey=$mApiKey&t=$title';
    http.Response response = await http.get(Uri.parse(url),headers: null);
    if(response.body != null) {
      MovieDetailsModel movieDetailsModel = MovieDetailsModel.fromJson(
          jsonDecode(response.body));
      return movieDetailsModel;
    }else{
      return null;
    }
  }

}