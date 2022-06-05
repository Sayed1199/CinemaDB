import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/controllers/tvshow_controller.dart';
import 'package:cinema_db/screens/series_details.dart';
import 'package:cinema_db/widgets/drawer_widget.dart';
import 'package:cinema_db/widgets/home_appbar.dart';
import 'package:cinema_db/widgets/image_error_widget.dart';
import 'package:cinema_db/widgets/loading_widget.dart';
import 'package:cinema_db/widgets/tvshow_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';


class SeriesScreen extends StatefulWidget {
  const SeriesScreen({Key? key}) : super(key: key);

  @override
  _SeriesScreenState createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {

  TvShowController controller = Get.put(TvShowController());
  ThemeController themeController = Get.put(ThemeController());
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),

      body: Center(
        child:  ListView(

          children: [

            HomeAppBar(isMovie: false,),
            SizedBox(height: 10,),
            TvShowCategoriesWidget(categoriesList: tvShowCategoriesList),
            //TvShowGenresContainer(genresList: genresList),
            SizedBox(height: 10,),

             Obx(()=>
               controller.allTvShowsList.value.length==0?ImageErrorWidget():
            controller.allTvShowsList.value.isNotEmpty && controller.allTvShowsList.value.length>controller.currentIndex.value? Stack(
                children: [

                  Obx(()=>
                      CarouselSlider(
                          carouselController: carouselController,
                          items:controller.allTvShowsList.value.map((e)
                          {
                            return Builder(builder: (context){
                              print('List: ${controller.allTvShowsList.value.length}');
                              print('ewww ${controller.currentIndex.value}');
                              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                if(controller.currentIndex.value ==0){
                                  carouselController.animateToPage(0);
                                }
                              });
                              return  GestureDetector(
                                onTap: (){
                                  Get.to(()=>SeriesDetailsScreen(),arguments: e,transition: Transition.zoom,curve: Curves.bounceInOut);
                                },
                                child: e.posterPath != null? CachedNetworkImage(imageUrl: imageTmdbApiLink+e.posterPath!,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                  errorWidget: (context,url,err)=>Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                      color: Colors.transparent,
                                      image: DecorationImage(image: AssetImage('assets/images/error.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  imageBuilder: (context,imageProvider)=> Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                      color: Colors.transparent,
                                      image: DecorationImage(image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ):Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.all(Radius.circular(35)),
                                    color: Colors.transparent,
                                    image: DecorationImage(image: AssetImage('assets/images/error.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            });
                          }
                          ).toList() ,options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16/9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (int index,reason){
                          controller.currentIndex.value=index;
                        },
                        scrollDirection: Axis.horizontal,
                      )),
                  ),
                ],
            ):LoadingWidget(),
             ),


            SizedBox(height: 10,),

            Obx(()=>
              controller.allTvShowsList.value.length !=0 && controller.allTvShowsList.value.isNotEmpty && controller.allTvShowsList.value.length>controller.currentIndex.value ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Obx(()=>
                    Text(controller.allTvShowsList.value[controller.currentIndex.value].name!,maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style:
                    GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: themeController.isDarkModeEnabled.value?Colors.white:Colors.black
                    ),)
                ),
              ):Container(),
            ),


            SizedBox(height: 10,),

            Obx(()=>
               controller.allTvShowsList.value.length !=0 && controller.allTvShowsList.value.isNotEmpty && controller.allTvShowsList.value.length>controller.currentIndex.value?Center(
                child:
                Obx(()=>
                    RatingBar.builder(
                      initialRating: double.parse((controller.allTvShowsList.value[controller.currentIndex.value].voteAverage)!)/2,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 15,
                      ),
                      onRatingUpdate: (rating) {
                      },
                    ),
                ),

              ):Container(),
            ),

            SizedBox(height: 10,),

            Obx(()=>
               controller.allTvShowsList.value.length !=0 && controller.allTvShowsList.value.isNotEmpty && controller.allTvShowsList.value.length>controller.currentIndex.value?
              Center(
                child: Obx(()=>
                    Text.rich(
                        TextSpan(
                            children:[
                              controller.currentIndex.value>controller.allTvShowsList.value.length?
                              TextSpan(text: '-',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400,color: Colors.blue)):
                              TextSpan(text: '${(double.parse((controller.allTvShowsList.value[controller.currentIndex.value].voteAverage)!)/2).toStringAsFixed(1)}',
                                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400,color: Colors.blue)),
                              TextSpan(text: ' / ',style: TextStyle(fontSize: 40,fontWeight: FontWeight.w800)),
                              TextSpan(text: '5',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600)),
                            ]
                        )
                    ),
                ),
              ):Container(),
            ),

            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trending Series',textAlign: TextAlign.start,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  ToggleSwitch(minWidth: 70.0,
                    initialLabelIndex: 0,
                    cornerRadius: 35.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: ['Daily', 'Weekly'],
                    activeBgColors: [[Colors.blue],[Colors.pink]],
                    onToggle: (index) async{
                      print('switched to: $index');
                      if(index==0){
                        controller.isDaily.value=true;
                       await  controller.mapTrendingMovies(true);
                      }else{
                        controller.isDaily.value=false;
                       await  controller.mapTrendingMovies(false);
                      }
                    },),

                ],
              ),
            ),

            SizedBox(height: 10,),


            Obx(()=>
               controller.trendingTvShowsList.value.isNotEmpty? Padding(
                padding: const EdgeInsets.fromLTRB(10,5,10,10),
                child: SizedBox(
                  height: 300,
                  child: Obx(()=>
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.trendingTvShowsList.value.length,
                        itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: (){
                             Get.to(SeriesDetailsScreen(),arguments: controller.trendingTvShowsList.value[index],transition: Transition.rightToLeft,curve: Curves.bounceInOut);
                            },
                            child: Container(
                              child: Stack(
                                children: [
                                  CachedNetworkImage(imageUrl: imageTmdbApiLink+controller.trendingTvShowsList.value[index].posterPath!,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                    errorWidget: (context,url,err)=>Container(
                                      width: MediaQuery.of(context).size.width/2,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(Radius.circular(35)),
                                        color: Colors.transparent,
                                        image: DecorationImage(image: AssetImage('assets/images/error.jpg'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    imageBuilder: (context,imageProvider)=> Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/2,
                                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(35)),
                                            color: Colors.transparent,
                                            image: DecorationImage(image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          bottom: 0,
                                          left: 5,
                                          width: MediaQuery.of(context).size.width/2,
                                          child: Obx(()=>
                                              Container(
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
                                                      child: Obx(()=> Text(controller.trendingTvShowsList.value[index].name!,textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,)),
                                                    ),
                                                    Obx(()=>
                                                        Text.rich(
                                                          TextSpan(
                                                              children:[
                                                                TextSpan(text: '${(double.parse((controller.trendingTvShowsList.value[index].voteAverage)!)/2).toStringAsFixed(1)}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.pinkAccent)),
                                                                TextSpan(text: ' / ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800)),
                                                                TextSpan(text: '5',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600)),
                                                              ]
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                    ),
                                                  ],
                                                ),

                                              ),
                                          ),

                                        ),

                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );},
                      ),
                  ),
                ),
              ):LoadingWidget(),
            ),

            //////////////////////////////////


            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Recommended Series',textAlign: TextAlign.start,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            ),

            SizedBox(height: 10,),


            Obx(()=>
               controller.recommendedTvShowsList.value.isNotEmpty? Padding(
                padding: const EdgeInsets.fromLTRB(10,5,10,10),
                child: SizedBox(
                  height: 300,
                  child: Obx(()=>
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.recommendedTvShowsList.value.length,
                        itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: (){
                              Get.to(()=>SeriesDetailsScreen(),arguments: controller.recommendedTvShowsList.value[index],transition: Transition.size,curve: Curves.bounceInOut);
                            },
                            child: Container(
                              child: Stack(
                                children: [
                                  CachedNetworkImage(imageUrl: imageTmdbApiLink+controller.recommendedTvShowsList.value[index].posterPath!,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                    errorWidget: (context,url,err)=>Container(
                                      width: MediaQuery.of(context).size.width/2,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(Radius.circular(35)),
                                        color: Colors.transparent,
                                        image: DecorationImage(image: AssetImage('assets/images/error.jpg'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    imageBuilder: (context,imageProvider)=> Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/2,
                                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(35)),
                                            color: Colors.transparent,
                                            image: DecorationImage(image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          bottom: 0,
                                          left: 5,
                                          width: MediaQuery.of(context).size.width/2,
                                          child: Obx(()=>
                                              Container(
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
                                                      child: Obx(()=> Text(controller.recommendedTvShowsList.value[index].name!,textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,)),
                                                    ),
                                                    Obx(()=>
                                                        Text.rich(
                                                          TextSpan(
                                                              children:[
                                                                TextSpan(text: '${(double.parse((controller.recommendedTvShowsList.value[index].voteAverage)!)/2).toStringAsFixed(1)}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.pinkAccent)),
                                                                TextSpan(text: ' / ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800)),
                                                                TextSpan(text: '5',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600)),
                                                              ]
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                    ),
                                                  ],
                                                ),

                                              ),
                                          ),

                                        ),

                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          );},
                      ),
                  ),
                ),
              ):LoadingWidget(),
            ),



          ],

        ),

      ),



    );
  }
}