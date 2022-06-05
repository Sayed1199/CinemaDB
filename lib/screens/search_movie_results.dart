import 'dart:async';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/search_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:cinema_db/screens/movie_details.dart';
import 'package:cinema_db/widgets/search_movies_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class SearchMovieResults extends StatefulWidget {
  final String searchQuery;
  const SearchMovieResults({Key? key,required this.searchQuery}) : super(key: key);

  @override
  _SearchMovieResultsState createState() => _SearchMovieResultsState();
}

class _SearchMovieResultsState extends State<SearchMovieResults> {

  SearchResultsController searchResultsController = Get.put(SearchResultsController());
  ThemeController themeController = Get.put(ThemeController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.searchQuery,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: themeController.isDarkModeEnabled.value?Colors.white:Colors.black
          )
          ,maxLines: 1,overflow: TextOverflow.ellipsis,),
        leading: IconButton(onPressed: (){
          Get.back();
        },icon: Icon(CupertinoIcons.left_chevron,color: Colors.blue,size: 30,)),
      ),

      body: Builder(
          builder: (_){
            searchResultsController.getMoviesList(widget.searchQuery);
            Timer(Duration(seconds: 10), (){
                if(searchResultsController.moviesList.value.isEmpty){
                  Fluttertoast.showToast(msg: "Soryy couldn't find any results",toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,backgroundColor: Colors.blue);
                  Get.back();
                }
            });
            return Obx(()=>
              searchResultsController.moviesList.value.isEmpty? Center(
                child: CircularProgressIndicator(),
              ): searchResultsController.moviesList.value.length<=3?LessThan3Widget(moviesList: searchResultsController.moviesList.value):
              SearchMoviesWidget(moviesList: searchResultsController.moviesList.value),
            );
      }),

    );
  }
}

class LessThan3Widget extends StatelessWidget {
  final List<MovieModel> moviesList;
   LessThan3Widget({Key? key,required this.moviesList}) : super(key: key);

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
                  GestureDetector(
                    onTap: ()=>Get.to(()=>MovieDetails(),arguments: moviesList[index]),
                    child: Padding(
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
                                      color: themeController.isDarkModeEnabled ==false?
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
                    ),
                  )
          ),
        ),
      ),
    );
  }
}

