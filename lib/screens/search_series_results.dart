import 'dart:async';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/search_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/tvShow_model.dart';
import 'package:cinema_db/screens/series_details.dart';
import 'package:cinema_db/widgets/search_Series_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SearchSeriesResults extends StatefulWidget {
  final String searchQuery;
  const SearchSeriesResults({Key? key,required this.searchQuery}) : super(key: key);

  @override
  _SearchSeriesResultsState createState() => _SearchSeriesResultsState();
}

class _SearchSeriesResultsState extends State<SearchSeriesResults> {

  SearchResultsController searchResultsController = Get.put(SearchResultsController());
  ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.searchQuery,
          style: TextStyle(fontSize: 22, color: themeController.isDarkModeEnabled.value==false?Colors.black:Colors.white)
          ,maxLines: 1,overflow: TextOverflow.ellipsis,),
        leading: IconButton(onPressed: (){
          Get.back();
        },icon: Icon(CupertinoIcons.left_chevron,color: Colors.blue,size: 30,)),
      ),

      body: Builder(
          builder: (_){
            searchResultsController.getSeriesList(widget.searchQuery);
            Timer(Duration(seconds: 10), (){
              if(searchResultsController.seriesList.value.isEmpty){
                Fluttertoast.showToast(msg: "Soryy couldn't find any results",toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,backgroundColor: Colors.blue);
                Get.back();
              }
            });
            return Obx(()=>
            searchResultsController.seriesList.value.isEmpty? Center(
              child: CircularProgressIndicator(),
            ): searchResultsController.seriesList.value.length<=3?LessThan3Widget(seriesList: searchResultsController.seriesList.value):
            SearchSeriesWidget(seriesList: searchResultsController.seriesList.value),
            );
          }),

    );
  }
}

class LessThan3Widget extends StatelessWidget {
  final List<TvShowModel> seriesList;
  LessThan3Widget({Key? key,required this.seriesList}) : super(key: key);

  ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 350,
        child: CupertinoScrollbar(
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: seriesList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  GestureDetector(
                    onTap: ()=>Get.to(()=>SeriesDetailsScreen(),arguments: seriesList[index]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.5,
                          child:(Stack(
                            children: [
                              seriesList[index].posterPath != null?
                              Image.network(imageTmdbApiLink+ seriesList[index].posterPath!,fit: BoxFit.cover,filterQuality: FilterQuality.high,):
                              Image.asset('assets/images/error.jpg'),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child:Container(
                                  height: 80,
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
                                        child: Text(seriesList[index].name!,textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                            children:[
                                              TextSpan(text: '${(double.parse((seriesList[index].voteAverage)!)/2).toStringAsFixed(1)}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.pinkAccent)),
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
