import 'dart:convert';
import 'package:cinema_db/apis/omdb_api.dart';
import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:cinema_db/models/actor_model.dart';
import 'package:cinema_db/models/crew_model.dart';
import 'package:cinema_db/models/genres_model.dart';
import 'package:cinema_db/models/movie_details_model.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:cinema_db/models/person_model.dart';
import 'package:cinema_db/models/release_date_model.dart';
import 'package:cinema_db/models/video_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MovieInfoController extends GetxController{

  var movieDetailsModel = Rx<MovieDetailsModel?>(null);
  var releaseDates = Rx<List<ReleaseDatesModel>>([]);
  var genresListAsStrings=Rx<List<String>>([]);
  var imagesList = Rx<List<String>>([]);
  var movieVideosList = Rx<List<MovieVideosModel>>([]);
  var releaseDatesList = Rx<List<Map<String,dynamic>>>([]);
  var fullCastList=Rx<List<ActorModel>>([]);
  var fullCrewList=Rx<List<CrewModel>>([]);




  Future<void> getReleaseDates(int id)async{
    List<Map<String,dynamic>> finalList=[];
    String data = await rootBundle.loadString('assets/jsons/release_date_data.json');
    List<dynamic> jsonData = jsonDecode(data);
    List<ReleaseDatesModel> releaseDates = await TmdbApi().getMovieReleaseDates(dotenv.env['MOVIE_API_KEY']!, id);
    releaseDates.forEach((element) {
      String innerDate = DateFormat('dd-MM-yyyy/HH:mm a').format(DateTime.parse(element.releaseDates![0].releaseDate!.
      replaceFirst(RegExp(r'-\d\d:\d\d'), ''))).toString();
      for(int i=0;i<jsonData.length;i++){
        if(jsonData[i]['Code']==element.iso31661){
          if(jsonData[i]['Name'].toString().contains(',')){
            finalList.add({'country':jsonData[i]['Name'].toString().substring(0,jsonData[i]['Name'].toString().indexOf(',')),'releaseDate':innerDate});
            break;
          }else{
            finalList.add({'country':jsonData[i]['Name'].toString(),'releaseDate':innerDate});
            break;
          }

        }
      }
    });
    releaseDatesList.value=finalList;
  }

  Future<void> getMovieVideos(int id)async{
    movieVideosList.value = await TmdbApi().getMovieVideos(dotenv.env['MOVIE_API_KEY']!, id);
  }

  Future<void> getImages(int movieID)async{
    imagesList.value = await TmdbApi().getMovieImages(dotenv.env['MOVIE_API_KEY']!, movieID);
  }

  Future<void> getMovieGenresAsStrings(List<int> genreIds)async{
    List<String> outputList=[];
    List<Genres> genresList = await TmdbApi().getGenres(dotenv.env['MOVIE_API_KEY']!);
    genreIds.forEach((id) {
      for(Genres genre in genresList){
        if(genre.id==id) {
          outputList.add(genre.name!);
        }
      }
    });
    genresListAsStrings.value=outputList;
  }


  Future<void> getFullCastDetails(int movieID)async{
    fullCastList.value = await TmdbApi().getFullCastMovies(movieID, dotenv.env['MOVIE_API_KEY']!);
  }
  Future<void> getFullCrewDetails(int movieID)async{
    fullCrewList.value = await TmdbApi().getFullCrewMovies(movieID, dotenv.env['MOVIE_API_KEY']!);
  }

  Future<PersonModel> getActorAsPersonModel(int personID)async{
    return await TmdbApi().getPersonDetailsByID(dotenv.env['MOVIE_API_KEY']!, personID);
  }




  Future<void> initializeController(int id)async{
    MovieModel movieDetails = await TmdbApi().getMovieDetails(dotenv.env['MOVIE_API_KEY']!,id);
    if(movieDetails.imdbId != null)
    movieDetailsModel.value = await OmdbApi().getMovieDetails(dotenv.env['MOVIE_DETAILS_API_KEY']!, movieDetails.imdbId!);
   if(movieDetailsModel.value!=null){
     await getFullCastDetails(id);
   }
    if(movieDetailsModel.value!=null) {
      if(movieDetailsModel.value != null){
        await getFullCrewDetails(id);
      }

    }

  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

  }



}