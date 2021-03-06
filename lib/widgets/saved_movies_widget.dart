
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedMoviesWidget extends StatelessWidget {
  final List<MovieModel> moviesList;
   SavedMoviesWidget({Key? key,required this.moviesList}) : super(key: key);

  ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
        return Center(
          child: SizedBox(
            height: 350, 
            child: CupertinoScrollbar(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: moviesList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Container(
                        child:(Stack(
                          children: [
                            Image.network(imageTmdbApiLink+ moviesList[index].posterPath!,fit: BoxFit.cover,filterQuality: FilterQuality.high,),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child:Container(
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

        ),),

                          ],
                        )),
                      ),
                    ),
                  )
              ),
            ),
          ));

  }
}
