import 'dart:math';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:cinema_db/screens/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';


class SearchMoviesWidget extends StatelessWidget {
  final List<MovieModel> moviesList;
  SearchMoviesWidget({Key? key,required this.moviesList}) : super(key: key);

  ThemeController themeController = Get.put(ThemeController());
  List<double> heightList=[250,275,300,325];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left:10, bottom: 10,right: 10,top: 20),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (BuildContext context, int index) {
          double height = heightList[Random().nextInt(heightList.length)];
          return
            SizedBox(
              height: height,
              child: Center(
                child:  GestureDetector(
                  onTap: (){
                      Get.to(()=>MovieDetails(),arguments: moviesList[index]);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Stack(
                      children: [
                        Container(
                          height: height,
                          //margin: EdgeInsets.only(bottom: 45),
                          child: moviesList[index].posterPath != null?Image.network(
                              imageTmdbApiLink+ moviesList[index].posterPath!,fit: BoxFit.fill,filterQuality: FilterQuality.high,):
                          Image.asset('assets/images/error.jpg',fit: BoxFit.cover),

                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: themeController.isDarkModeEnabled.value==false?
                                    Colors.white.withOpacity(0.4):
                                    Colors.black.withOpacity(0.4),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(35)
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(moviesList[index].title!,textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,),
                                    ),
                                    Text.rich(
                                          TextSpan(
                                              children:[
                                                TextSpan(text: '${(double.parse((moviesList[index].voteAverage)!)/2).toStringAsFixed(1)}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.pinkAccent)),
                                                TextSpan(text: ' / ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800)),
                                                TextSpan(text: '5',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600)),
                                              ]
                                          ),
                                          textAlign: TextAlign.center,

                                    ),
                                  ],
                                ),

                              ),


                        ),
                      ],
                    ),
                  ),
                ),
              ),
          );

        },

      ),

    );
  }
}
