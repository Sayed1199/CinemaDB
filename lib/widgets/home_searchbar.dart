import 'package:cinema_db/controllers/home_search_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/screens/search_movie_results.dart';
import 'package:cinema_db/screens/search_series_results.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
class HomeSearchbar extends StatelessWidget {
   TextEditingController textEditingController;
   final bool ismovie;
   HomeSearchbar({Key? key,required this.textEditingController,required this.ismovie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.put(ThemeController());
    HomeSearchController searchController = Get.put(HomeSearchController());
    return TextField(
      controller: textEditingController,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        print('Submitted: ${value}');
        if (value.isEmpty) {
          Fluttertoast.showToast(msg: 'Sorry, The field is empty',gravity: ToastGravity.BOTTOM,backgroundColor: Colors.blue,
          toastLength: Toast.LENGTH_SHORT,
            fontSize: 16,
          );
        } else if (value.length < 3) {

          Fluttertoast.showToast(msg: 'Sorry the search must at least contain 3 letters',gravity: ToastGravity.BOTTOM,backgroundColor: Colors.blue,
            toastLength: Toast.LENGTH_SHORT,
            fontSize: 16,
          );

        } else {
          if(ismovie==true) {
            Get.to(() => SearchMovieResults(searchQuery: value));
          }else{
            Get.to(() => SearchSeriesResults(searchQuery: value));
          }
        }
      },
      autofocus: true,
      decoration: InputDecoration(
        hintText: ismovie? "Search Movie...":'Search Series...',
        border: InputBorder.none,
        hintStyle: TextStyle(
            color: themeController.isDarkModeEnabled.value==false
                ? Colors.black
                : Colors.white),
      ),
      style: TextStyle(
        color: themeController.isDarkModeEnabled.value==false
            ? Colors.black
            : Colors.white,
        fontSize: 18.0,
      ),
      maxLines: 1,
      onChanged: (query)=> searchController.searchQuery.value=query,
    );
  }
}
