import 'dart:math';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/tvShow_model.dart';
import 'package:cinema_db/screens/series_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchSeriesWidget extends StatelessWidget {
  final List<TvShowModel> seriesList;

  SearchSeriesWidget({Key? key, required this.seriesList}) : super(key: key);

  ThemeController themeController = Get.put(ThemeController());
  List<double> heightList = [280, 250, 310, 350];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, bottom: 5, right: 5, top: 10),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        itemCount: seriesList.length,
        itemBuilder: (BuildContext context, int index) {
          double height = heightList[Random().nextInt(heightList.length)];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (seriesList[index].posterPath != null)
                    Get.to(() => SeriesDetailsScreen(),
                        arguments: seriesList[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                      height: height - 50,
                      //width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(30),
                          image: seriesList[index].posterPath != null
                              ? DecorationImage(
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(imageTmdbApiLink +
                                      seriesList[index].posterPath!))
                              : DecorationImage(
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('assets/images/empty1.jpg')),


                ),
                ),
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Obx(
                    () => Text(
                      seriesList[index].name == null
                          ? ''
                          : seriesList[index].name!,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                          fontSize: 18,
                          color: themeController.isDarkModeEnabled.value
                              ? Colors.grey[100]
                              : Colors.grey[900]),
                    ),
                  ),
                ),
              ),
            ],
          );

        },
      ),
    );
  }
}
