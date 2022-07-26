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
import 'package:google_fonts/google_fonts.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children:[
         SizedBox(
           height: MediaQuery.of(context).size.height*0.6,
           width: MediaQuery.of(context).size.width,
           child:  CupertinoScrollbar(
           child: Padding(
             padding: const EdgeInsets.only(top: 10,bottom: 10),
             child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount: seriesList.length,
                 shrinkWrap: true,
                 itemBuilder: (context, index) =>

                             Column(
                               children: [
                                 GestureDetector(
                                   onTap: (){
                                     if(seriesList[index].posterPath!=null)
                                       Get.to(()=>SeriesDetailsScreen(),arguments: seriesList[index]);
                                   },
                                   child: Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 20),
                                     child:  Container(
                                       height: MediaQuery.of(context).size.height*0.5,
                                         width: MediaQuery.of(context).size.width*0.6,
                                         decoration: BoxDecoration(
                                           shape: BoxShape.rectangle,
                                           borderRadius: BorderRadius.circular(30),
                                           image: DecorationImage(
                                             filterQuality: FilterQuality.high,
                                             fit: BoxFit.cover,
                                             image:
                                             NetworkImage(imageTmdbApiLink+ seriesList[index].posterPath!)
                                           )
                                         )
                                     ),
                                   ),
                                 ),

                                 SizedBox(
                                     width: MediaQuery.of(context).size.width/2,
                                     child: Center(
                                       child: Obx(()=>
                                       Text(seriesList[index].name==null?'':seriesList[index].name!,
                                         maxLines: 2,textAlign: TextAlign.center,overflow:TextOverflow.ellipsis, style: GoogleFonts.lato(
                                             fontSize: 18,
                                             color: themeController.isDarkModeEnabled.value?Colors.grey[100]:Colors.grey[900]
                                         ),),
                                 ),
                                     ),),


                               ],
                             ),




                     )
             ),
           ),

         ),
       ],
    );
  }
}
