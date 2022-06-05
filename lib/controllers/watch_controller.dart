import 'package:cinema_db/apis/tmdb_api.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class WatchController extends GetxController{

  var link = Rx<String>('');

  Future<void> getWatchLink(int id)async{

  link.value = await TmdbApi().getArabicWatchLink(dotenv.env['MOVIE_API_KEY']!, id);

  }

}