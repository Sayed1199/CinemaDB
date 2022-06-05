import 'dart:async';

import 'package:cinema_db/controllers/category_genres_controller.dart';
import 'package:cinema_db/screens/home_movies_screen.dart';
import 'package:get/get.dart';

class IntroController extends GetxController{

  CategoryNGenreController controller = Get.put(CategoryNGenreController());

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    Timer(Duration(seconds: 1), ()=>Get.offAll(()=>HomeMoviesScreen()));
  }

}