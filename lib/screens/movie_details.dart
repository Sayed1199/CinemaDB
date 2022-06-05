import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/movie_info_controller.dart';
import 'package:cinema_db/controllers/saved_movies_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/controllers/watch_controller.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:cinema_db/screens/person_details.dart';
import 'package:cinema_db/services/database.dart';
import 'package:cinema_db/widgets/loading_widget.dart';
import 'package:cinema_db/widgets/images_carousel.dart';
import 'package:cinema_db/widgets/video_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({Key? key}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  MovieModel movie = Get.arguments;
  ThemeController themeController = Get.put(ThemeController());
  MovieInfoController infoController = Get.put(MovieInfoController());
  SaveMoviesController saveController = Get.put(SaveMoviesController());
  WatchController watchController = Get.put(WatchController());

  MyDatabase db = MyDatabase();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Expanded(
            child: ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                 BuildBackdrop(movie: movie, themeController: themeController, infoController: infoController,
                     saveController: saveController, db: db),
              Obx(()=>
                infoController.movieDetailsModel.value != null
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
                        child: Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title==null?'':movie.title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    fontSize: 24,
                                    color: themeController.isDarkModeEnabled.value?Colors.white:Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${movie.releaseDate}',
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      infoController
                                          .movieDetailsModel.value!.rated!,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      infoController
                                          .movieDetailsModel.value!.runtime!,
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 50,
                              width: 100,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color?>(
                                          Colors.pinkAccent),
                                  shape: MaterialStateProperty.resolveWith<
                                      OutlinedBorder>((states) {
                                    return RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30));
                                  }),
                                ),
                                onPressed: () async {
                                  await watchController.getWatchLink(movie.id!);
                                  if(watchController.link.value ==''){
                                        Fluttertoast.showToast(
                                            msg: 'Coming in the future Updates',
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.blue,
                                            toastLength: Toast.LENGTH_SHORT,
                                            fontSize: 16);
                                      }else{
                                        if(!await launchUrl(Uri.parse(watchController.link.value))) throw "Couldn't load this url";
                                      }
                                },
                                child: Text('Watch',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    )),
                              ))
                        ]),
                      )
                    : LoadingWidget(),
              ),

              Builder(
                builder: (context) {
                  infoController.getMovieGenresAsStrings(movie.genres!);
                  return Obx(()=>
                  infoController.genresListAsStrings.value.isNotEmpty? Padding(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: infoController.genresListAsStrings.value.length,
                          itemBuilder: (context, index) => Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 10),
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Opacity(
                                opacity: 0.8,
                                child: Text(
                                  infoController.genresListAsStrings.value[index],
                                  style: TextStyle(
                                      fontSize: 16),
                                ),
                              )),
                        ),
                      ),
                    ):LoadingWidget(),
                  );
                }
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  'Plot Summary',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  movie.overview!,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  'Photos',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Builder(
                builder: (context) {
                  infoController.getImages(movie.id!);
                  return Obx(()=> infoController.imagesList.value.isNotEmpty?
                  CarouselImagesWidget(photosList: infoController.imagesList.value):LoadingWidget());
                }
              ),
              SizedBox(
                height: 10,
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  'Trailer',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Builder(
                builder: (context) {
                  infoController.getMovieVideos(movie.id!);
                  return Obx(()=> infoController.movieVideosList.value.isNotEmpty?
                  CarouselVideosWidget(videosList: infoController.movieVideosList.value):LoadingWidget());
                }
              ),
              SizedBox(
                height: 10,
              ),


              Builder(
                builder: (context) {
                  infoController.initializeController(movie.id!);
                  return Obx(()=>
                     infoController.castList.value.isEmpty
                        ? LoadingWidget() : CastWidget(infoController: infoController)
                  );
                }
              ),
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: Column(
                  children: [
                    Text(
                      'Director(s)',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                     Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: SizedBox(
                        height: 130,
                        child: Obx(()=>
                        infoController.direcList.value.isEmpty
                              ? LoadingWidget()
                              : DirectorsWidget(infoController: infoController)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Writers & Authors',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Obx(()=>
                 infoController.movieDetailsModel.value ==null?
         LoadingWidget():Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      infoController.movieDetailsModel.value!.writer!,
                    ),

                ),
              ),

              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Release Dates',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),

              SizedBox(height: 10,),

              Builder(
                builder: (context) {
                  infoController.getReleaseDates(movie.id!);
                  return Obx(()=>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15,left: 25, right: 10),
                        child: SizedBox(
                            height: 200,
                            child: infoController.releaseDatesList.value.isEmpty
                                ? LoadingWidget(): ReleaseDatesWidget(infoController: infoController)
                        ),
                      ),
                  );
                }
              ),



              ///////////////////////////////////////////////////////


              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Awards',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),

                  Obx(()=>
                    infoController.movieDetailsModel.value ==null?
                    Center(
                        child: CircularProgressIndicator(),
                      )
                     : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20,
                ),
                child: Text(
                      infoController.movieDetailsModel.value!.awards == null
                          ? 'N/A'
                          : infoController.movieDetailsModel.value!.awards!),
              ),
                  ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Production',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
                  Obx(()=>
                     infoController.movieDetailsModel.value ==null?
                    Center(
                      child: CircularProgressIndicator(),
                    ) : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20,
                ),
                child: Text(
                      infoController.movieDetailsModel.value!.production == null
                          ? 'N/A'
                          : infoController.movieDetailsModel.value!.production!),
              ),
                  ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Box-Office',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
                  Obx(()=>
                     infoController.movieDetailsModel.value ==null?
                    Center(
                      child: CircularProgressIndicator(),
                    ) : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20,
                ),
                child: Text(
                      infoController.movieDetailsModel.value!.boxOffice == null
                          ? 'N/A'
                          : infoController.movieDetailsModel.value!.boxOffice!),
              ),
                  ),
              SizedBox(
                height: 20,
              )
            ]),
          ),
        ]),
      ),
    );
  }
}

class BuildBackdrop extends StatelessWidget {

  final MovieModel movie;
  final ThemeController themeController;
  final MovieInfoController infoController;
  final SaveMoviesController saveController;
  final MyDatabase db;

  const BuildBackdrop({Key? key,required this.movie,required this.themeController,
  required this.infoController,required this.saveController,required this.db}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4 - 50,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50)),
                image: DecorationImage(
                  image: NetworkImage(
                      imageTmdbApiLink + movie.backdropPath!),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                )),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 100,
              decoration: BoxDecoration(
                  color: themeController.isDarkModeEnabled.value==false
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 5),
                        blurRadius: 50,
                        color: Color(0xFF121530)..withOpacity(0.2))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/star_fill.svg'),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                  color: themeController.isDarkModeEnabled.value==false
                                      ? Colors.black
                                      : Colors.white),
                              children: [
                                TextSpan(
                                  text: '${movie.voteAverage}/',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(text: '10\n'),
                                TextSpan(
                                  text: '${movie.voteCount} review',
                                ),
                              ])),
                    ],
                  ),
                  Builder(
                      builder: (context) {
                        saveController.checkMovieExists(movie.id!);
                        return Obx(() {
                          return GestureDetector(
                            onTap: () async {
                              if (saveController.movieSaved.value ==
                                  true) {
                                await db.delete(movie.id!,db.savedMoviesTable);
                              }
                              if (saveController.movieSaved.value ==
                                  false) {
                                await db.insert(movie.id!,db.savedMoviesTable);
                              }
                              saveController.movieSaved.value =
                              !saveController.movieSaved.value;
                              print(
                                  'dbbb: ${await db.query(
                                      'savedMovies')}');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              children: [
                                SvgPicture.asset(
                                  saveController.movieSaved.value ==
                                      true
                                      ? 'assets/icons/bookmark_fill.svg'
                                      : 'assets/icons/bookmark.svg',
                                  width: 32,
                                  height: 32,
                                  color: themeController.isDarkModeEnabled.value == false
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    saveController.movieSaved.value ==
                                        true
                                        ? 'Saved'
                                        : 'Save',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: saveController
                                            .movieSaved.value ==
                                            true
                                            ? FontWeight.w500
                                            : FontWeight.w400))
                              ],
                            ),);
                        }
                        );


                      }
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/rate2.svg',
                          width: 40,
                          height: 40,
                          color:Colors.yellow,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          movie.popularity!,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SafeArea(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  margin: EdgeInsets.only(left: 10, top: 15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.6)),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/left_arrow.svg',
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class CastWidget extends StatelessWidget {
  final MovieInfoController infoController;
  const CastWidget({Key? key,required this.infoController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cast',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 130,
            child: infoController.castList.value.isEmpty
                ? LoadingWidget()
                : Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: infoController
                        .castList.value.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {

                            Get.to(()=>FullPersonDetails(personModel:
                            infoController.castList.value[index],));

                          },
                          child: CachedNetworkImage(
                              imageUrl: imageTmdbApiLink +
                                  infoController
                                      .castList
                                      .value[index]
                                      .profilePath!,
                              progressIndicatorBuilder: (context,
                                  url,
                                  downloadProgress) =>
                                  Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress
                                              .progress)),
                              errorWidget: (context, url,
                                  err) =>
                                  Container(
                                    width: MediaQuery.of(
                                        context)
                                        .size
                                        .width,
                                    margin: EdgeInsets
                                        .symmetric(
                                        horizontal:
                                        5.0),
                                    decoration:
                                    BoxDecoration(
                                      shape: BoxShape
                                          .rectangle,
                                      borderRadius:
                                      BorderRadius
                                          .all(Radius
                                          .circular(
                                          35)),
                                      color: Colors
                                          .transparent,
                                      image:
                                      DecorationImage(
                                        image: AssetImage(
                                            'assets/images/error.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              imageBuilder: (context,
                                  imageProvider) =>
                                  Container(
                                    margin:
                                    EdgeInsets.only(
                                        right: 10),
                                    width: 80,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .center,
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              shape: BoxShape
                                                  .circle,
                                              image: DecorationImage(
                                                  image:
                                                  imageProvider,
                                                  fit: BoxFit
                                                      .cover)),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          infoController
                                              .castList
                                              .value[
                                          index]
                                              .name ==
                                              null
                                              ? ''
                                              : infoController
                                              .castList
                                              .value[
                                          index]
                                              .name!,
                                          textAlign:
                                          TextAlign
                                              .center,
                                          style: Theme.of(
                                              context)
                                              .textTheme
                                              .bodyText2,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  )));
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DirectorsWidget extends StatelessWidget {
  final MovieInfoController infoController;
  const DirectorsWidget({Key? key,required this.infoController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
        infoController.direcList.value.length,
        itemBuilder:
            (context, index) => GestureDetector(
          onTap: () {

          },
          child: Container(
            margin: EdgeInsets.only(right: 10),
            width: 80,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                infoController
                    .direcList
                    .value[index]
                    .profilePath !=
                    null
                    ? Container(
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                            imageTmdbApiLink +
                                infoController
                                    .direcList
                                    .value[
                                index]
                                    .profilePath!,
                          ),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high)),
                )
                    : Container(
                  height: 80,
                  decoration: BoxDecoration(
                      shape:
                      BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/error.jpg'),
                          fit: BoxFit
                              .cover,
                          filterQuality:
                          FilterQuality
                              .high)),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  infoController
                      .direcList
                      .value[index]
                      .name ==
                      null
                      ? ''
                      : infoController.direcList
                      .value[index].name!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        )
    );
  }
}

class ReleaseDatesWidget extends StatelessWidget {
  final MovieInfoController infoController;
  const ReleaseDatesWidget({Key? key,required this.infoController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount:
          infoController.releaseDatesList.value.length,
          itemBuilder:
              (context, index) => GestureDetector(
            onTap: () {
            },
            child: Container(
                margin: EdgeInsets.only(right: 10),
                width: 80,
                child: Row(
                  children: [
                    Text(
                      '\u2022',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      '${infoController.releaseDatesList.value[index]['country']} : ${infoController.releaseDatesList.value[index]['releaseDate']}',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),

                  ],
                )
            ),
          )),
    );


  }
}
