
import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:cinema_db/models/tvShow_details_model.dart';
import 'package:cinema_db/services/database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class SaveSeriesController extends GetxController{

  var savedSeriesList = Rx<List<TvShowDetailsModel>?>(null);
  var seriesSaved = Rx<bool>(false);

  Future<void> checkSeriesExists(int id)async{

    await getSavedSeries();
    if(savedSeriesList.value != null && savedSeriesList.value!.isNotEmpty) {
      for (int i = 0; i < savedSeriesList.value!.length; i++) {
        if(savedSeriesList.value![i].id == id){
          seriesSaved.value=true;
          break;
        }
      }
    }else{
      seriesSaved.value=false;
    }
  }

  Future<void> getSavedSeries()async{
    List<TvShowDetailsModel> tvShowsList=[];
    MyDatabase db = MyDatabase();
    await db.init();
    List<Map<String,dynamic>> mList = await db.query(MyDatabase().savedSeriesTable);
    if(mList.isNotEmpty) {
      for (int i = 0; i < mList.length; i++) {
        TvShowDetailsModel series = await TmdbApi().getTvShowDetailsByID(
            dotenv.env['MOVIE_API_KEY']!, mList[i]['seriesID']);
        tvShowsList.add(series);
      }
    }
    print('length: ${tvShowsList.length}');
    savedSeriesList.value = tvShowsList;
  }


}