import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/category_genres_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:cinema_db/screens/movie_details.dart';
import 'package:cinema_db/widgets/drawer_widget.dart';
import 'package:cinema_db/widgets/home_appbar.dart';
import 'package:cinema_db/widgets/home_categories_widget.dart';
import 'package:cinema_db/widgets/image_error_widget.dart';
import 'package:cinema_db/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeMoviesScreen extends StatefulWidget {
  const HomeMoviesScreen({Key? key}) : super(key: key);

  @override
  State<HomeMoviesScreen> createState() => _HomeMoviesScreenState();
}

class _HomeMoviesScreenState extends State<HomeMoviesScreen> {

  CategoryNGenreController controller = Get.put(CategoryNGenreController());
  CarouselController carouselController = CarouselController();
  ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      body: ListView(

        children: [

          HomeAppBar(isMovie: true,),
          SizedBox(height: 10,),
          HomeCategoriesWidget(categoriesList: categoriesList),
          SizedBox(height: 10,),
          Obx(()=>controller.allMoviesList.value.isNotEmpty?
          MovieCard(controller: controller, carouselController: carouselController):LoadingWidget(),),
          SizedBox(height: 20,),
          Obx(()=>
             controller.allMoviesList.value.isNotEmpty?
            MovieTitle(controller: controller):Container(),
          ),
          SizedBox(height: 10,),
          Obx(()=>controller.allMoviesList.value.isNotEmpty?MovieRating(controller: controller):Container()),
          SizedBox(height: 10,),
          Obx(()=>
             controller.allMoviesList.value.isNotEmpty?
            MovieRatingText(controller: controller):Container(),
          ),
          SizedBox(height: 20,),

          TrendingToggleWidget(controller: controller),

          SizedBox(height: 10,),

          Obx(()=>controller.trendingMoviesList.value.isNotEmpty?
          TrendingMoviesList(controller: controller, themeController: themeController):LoadingWidget(),),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            child: Text('Recommended Movies',textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
          ),

          SizedBox(height: 10,),

          Obx(()=>controller.recommendedMoviesList.value.isNotEmpty? RecommendedMovies(controller: controller,
              themeController: themeController):LoadingWidget(),),



        ],
      )
    );
  }
}



class MovieCard extends StatelessWidget {
  final CategoryNGenreController controller;
  final CarouselController carouselController;
  const MovieCard({Key? key,required this.controller,required this.carouselController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Obx(()=>
            CarouselSlider(
                carouselController: carouselController,
                items:controller.allMoviesList.value.map((e)
                {
                  return Builder(builder: (context){
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if(controller.currentIndex.value ==0){
                        carouselController.animateToPage(0);
                      }
                    });
                    return  GestureDetector(
                      onTap: (){
                        Get.to(()=>MovieDetails(),arguments: e,transition: Transition.zoom,curve: Curves.bounceInOut);
                      },
                      child: e.posterPath != null? CachedNetworkImage(imageUrl: imageTmdbApiLink+e.posterPath!,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                        errorWidget: (context,url,err)=>ImageErrorWidget(),
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
                      ):ImageErrorWidget(),
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
    );
  }
}

class MovieTitle extends StatelessWidget {
  final CategoryNGenreController controller;
  const MovieTitle({Key? key,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Obx(()=>
          Text(controller.allMoviesList.value[controller.currentIndex.value].title!,maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.w700),)
      ),
    );
  }
}

class MovieRating extends StatelessWidget {
  final CategoryNGenreController controller;
  const MovieRating({Key? key,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          //print('star: ${(double.parse((controller.moviesList.value[controller.currentIndex.value].voteAverage)!)/2).toStringAsFixed(1)}');
          return Center(
            child:
            Obx(()=>
                RatingBar.builder(
                  initialRating: double.parse((double.parse((controller.allMoviesList.value[controller.currentIndex.value].voteAverage)!)/2).toStringAsFixed(1)),
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

          );
        }
    );
  }
}

class MovieRatingText extends StatelessWidget {
  final CategoryNGenreController controller;
  const MovieRatingText({Key? key,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(()=>
          Text.rich(
              TextSpan(
                  children:[
                    TextSpan(text: '${(double.parse((controller.allMoviesList.value[controller.currentIndex.value].voteAverage)!)/2).toStringAsFixed(1)}',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400,color: Colors.blue)),
                    TextSpan(text: ' / ',style: TextStyle(fontSize: 40,fontWeight: FontWeight.w800)),
                    TextSpan(text: '5',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600)),
                  ]
              )
          ),
      ),
    );
  }
}


class TrendingToggleWidget extends StatelessWidget {
  final CategoryNGenreController controller;
  TrendingToggleWidget({Key? key,required this.controller}) : super(key: key);

  List<String> trendingLabelsList=['Daily', 'Weekly'];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Trending Movies',textAlign: TextAlign.start,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
          ToggleSwitch(minWidth: 70.0,
            initialLabelIndex: 0,
            cornerRadius: 35.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: trendingLabelsList,
            activeBgColors: [[Colors.blue],[Colors.pink]],
            onToggle: (index) {
              print('switched to: $index');
              if(index==0){
                controller.isDaily.value=true;
                controller.mapTrendingMovies(true);
              }else{
                controller.isDaily.value=false;
                controller.mapTrendingMovies(false);
              }
            },),

        ],
      ),
    );
  }
}

class TrendingMoviesList extends StatelessWidget {
  final CategoryNGenreController controller;
  final ThemeController themeController;
  TrendingMoviesList({Key? key,required this.controller,required this.themeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5,5,5,10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width,
        child: Obx(()=>
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.trendingMoviesList.value.length,
              itemBuilder: (context,index){
                return Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          MovieModel e = controller.trendingMoviesList.value[index];
                          Get.to(MovieDetails(),arguments: e,transition: Transition.rightToLeft,curve: Curves.bounceInOut);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: controller.trendingMoviesList.value[index].posterPath==null? Container(
                              height: MediaQuery.of(context).size.height*0.4,
                              width: MediaQuery.of(context).size.width*0.5,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                      filterQuality: FilterQuality.high,
                                      fit: BoxFit.cover,
                                      image:
                                      AssetImage('assets/images/empty1.jpg')
                                  )
                              )
                          ): Container(
                              height: MediaQuery.of(context).size.height*0.4,
                              width: MediaQuery.of(context).size.width*0.5,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                      filterQuality: FilterQuality.high,
                                      fit: BoxFit.cover,
                                      image:
                                      NetworkImage(imageTmdbApiLink+ controller.trendingMoviesList.value[index].posterPath!)
                                  )
                              )
                          ),
                        ),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Center(
                          child: Obx(()=>
                              Text(controller.trendingMoviesList.value[index].title==null?'':controller.trendingMoviesList.value[index].title!,
                                maxLines: 2,textAlign: TextAlign.center,overflow:TextOverflow.ellipsis, style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: themeController.isDarkModeEnabled.value?Colors.grey[100]:Colors.grey[900]
                                ),),
                          ),
                        ),),

                    ],
                  );
                },
            ),
        ),
      ),
    );
  }
}


class RecommendedMovies extends StatelessWidget {
  final CategoryNGenreController controller;
  final ThemeController themeController;
  const RecommendedMovies({Key? key,required this.controller,required this.themeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,10,10,10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width,
        child: Obx(()=>
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.recommendedMoviesList.value.length,
              itemBuilder: (context,index){
                return Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        MovieModel e = controller.recommendedMoviesList.value[index];
                        Get.to(MovieDetails(),arguments: e,transition: Transition.size,curve: Curves.bounceInOut);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:  controller.recommendedMoviesList.value[index].posterPath==null? Container(
                            height: MediaQuery.of(context).size.height*0.4,
                            width: MediaQuery.of(context).size.width*0.5,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    image:
                                    AssetImage('assets/images/empty1.jpg')
                                )
                            )
                        ): Container(
                            height: MediaQuery.of(context).size.height*0.4,
                            width: MediaQuery.of(context).size.width*0.5,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    image:
                                    NetworkImage(imageTmdbApiLink+ controller.recommendedMoviesList.value[index].posterPath!)
                                )
                            )
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.4,
                      child: Center(
                        child: Obx(()=>
                            Text(controller.recommendedMoviesList.value[index].title==null?'':controller.recommendedMoviesList.value[index].title!,
                              maxLines: 2,textAlign: TextAlign.center,overflow:TextOverflow.ellipsis, style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: themeController.isDarkModeEnabled.value?Colors.grey[100]:Colors.grey[900]
                              ),),
                        ),
                      ),),


                  ],
                );

                },
            ),
        ),
      ),
    );
  }
}

