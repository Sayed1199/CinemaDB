import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/save_series_controller.dart';
import 'package:cinema_db/controllers/series_info_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/person_model.dart';
import 'package:cinema_db/models/tvShow_model.dart';
import 'package:cinema_db/screens/person_details.dart';
import 'package:cinema_db/screens/season_details.dart';
import 'package:cinema_db/services/database.dart';
import 'package:cinema_db/widgets/images_carousel.dart';
import 'package:cinema_db/widgets/loading_widget.dart';
import 'package:cinema_db/widgets/video_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SeriesDetailsScreen extends StatefulWidget {
  const SeriesDetailsScreen({Key? key}) : super(key: key);

  @override
  _SeriesDetailsScreenState createState() => _SeriesDetailsScreenState();
}

class _SeriesDetailsScreenState extends State<SeriesDetailsScreen> {
  TvShowModel tvshow = Get.arguments;
  ThemeController themeController = Get.put(ThemeController());
  SaveSeriesController saveSeriesController = Get.put(SaveSeriesController());
  SeriesInfoController infoController = Get.put(SeriesInfoController());
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: ListView(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Container(
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
                                  imageTmdbApiLink + tvshow.backdropPath!),
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
                              color:
                                  themeController.isDarkModeEnabled.value==false
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
                                  SvgPicture.asset(
                                      'assets/icons/star_fill.svg'),
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
                                              text: '${tvshow.voteAverage}/',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            TextSpan(text: '10\n'),
                                            TextSpan(
                                              text:
                                                  '${tvshow.voteCount} review',
                                            ),
                                          ])),
                                ],
                              ),
                              Builder(builder: (context) {
                                saveSeriesController
                                    .checkSeriesExists(tvshow.id!);
                                return Obx(() {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (saveSeriesController
                                              .seriesSaved.value ==
                                          true) {
                                        await db.delete(
                                            tvshow.id!, db.savedSeriesTable);
                                      }
                                      if (saveSeriesController
                                              .seriesSaved.value ==
                                          false) {
                                        await db.insert(
                                            tvshow.id!, db.savedSeriesTable);
                                      }
                                      saveSeriesController.seriesSaved.value =
                                          !saveSeriesController
                                              .seriesSaved.value;
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          saveSeriesController
                                                      .seriesSaved.value ==
                                                  true
                                              ? 'assets/icons/bookmark_fill.svg'
                                              : 'assets/icons/bookmark.svg',
                                          width: 32,
                                          height: 32,
                                          color: themeController.isDarkModeEnabled.value==false
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            saveSeriesController
                                                        .seriesSaved.value ==
                                                    true
                                                ? 'Saved'
                                                : 'Save',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: saveSeriesController
                                                            .seriesSaved
                                                            .value ==
                                                        true
                                                    ? FontWeight.w500
                                                    : FontWeight.w400))
                                      ],
                                    ),
                                  );
                                });
                              }),
                              GestureDetector(
                                onTap: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/rate2.svg',
                                      width: 40,
                                      height: 40,
                                      color: Colors.yellow,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      tvshow.voteCount!,
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.6)),
                              child: SvgPicture.asset(
                                'assets/icons/left_arrow.svg',
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),

                /////////////////

                Builder(builder: (context) {
                  infoController.initializeInfoController(tvshow.id!);
                  return Obx(
                    () => infoController.seriesOmdbDetails.value != null
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
                            child: Row(children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                       tvshow.name!,
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
                                          '${tvshow.firstAirDate ==null? '':tvshow.firstAirDate}  - ',
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          infoController.seriesdetails.value!
                                                      .lastAirDate !=
                                                  null
                                              ? '${infoController.seriesdetails.value!.lastAirDate!}'
                                              : 'N/A',
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          infoController
                                              .seriesOmdbDetails.value!.rated ==null? '': infoController
                                              .seriesOmdbDetails.value!.rated!,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          infoController.seriesOmdbDetails
                                                  .value!.runtime==null? '': infoController.seriesOmdbDetails
                                              .value!.runtime!+
                                              ' / Ep',
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                    infoController.seriesdetails.value != null
                                        ? Row(
                                            children: [
                                              Text(
                                                '${infoController.seriesdetails.value!.numberOfSeasons!} Seasons  -',
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${infoController.seriesdetails.value!.numberOfEpisodes!} Episodes',
                                                style: TextStyle(),
                                              ),
                                            ],
                                          )
                                        : Container(),
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
                                            borderRadius:
                                                BorderRadius.circular(30));
                                      }),
                                    ),
                                    onPressed: () async {
                                      Fluttertoast.showToast(
                                          msg: 'Coming in the future Updates',
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.blue,
                                          toastLength: Toast.LENGTH_SHORT,
                                          fontSize: 16);

                                      /*
                                await watchController.getWatchLink(movie.id!);
                                if(watchController.link.value ==''){
                                  Fluttertoast.showToast(
                                      msg: 'Coming in the future Updates',
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.blue,
                                      toastLength: Toast.LENGTH_SHORT,
                                      fontSize: 16);
                                }else{
                                  if(!await launch(watchController.link.value)) throw "Couldn't load this url";
                                }
                                */
                                    },
                                    child: Text('Watch',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        )),
                                  ))
                            ]),
                          )
                        : Center(child: LoadingWidget()),
                  );
                }),

               Obx(
                    () => infoController.seriesOmdbDetails.value != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: SizedBox(
                              height: 36,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: infoController
                                    .seriesOmdbDetails.value==null?0: infoController
                                    .seriesOmdbDetails.value!.genre!
                                    .split(',')
                                    .length,
                                itemBuilder: (context, index) => Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 10),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Opacity(
                                      opacity: 0.8,
                                      child: Text(
                                        infoController
                                            .seriesOmdbDetails.value!.genre!
                                            .split(',')[index],
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )),
                              ),
                            ),
                          )
                        : Container()
                  ),


                Obx(()=>
                   infoController.seriesdetails.value ==null || infoController.seriesdetails.value!.homepage==''?Container():
                   infoController.seriesdetails.value!.homepage ==null ? Container(): Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      'HomePage',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
        Obx(()=>
        infoController.seriesdetails.value==null || infoController.seriesdetails.value!.homepage==''?Container():
        infoController.seriesdetails.value!.homepage ==null ? Container(): Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: InkWell(
                    onTap: () async {
                      await launchUrl(
                          Uri.parse(infoController.seriesdetails.value!.homepage!));
                    },
                    child: Obx(
                      () => infoController.seriesdetails.value != null
                          ? Text(
                              infoController.seriesdetails.value!.homepage!,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                            )
                          : Container(
                        width: 0,
                        height: 0,
                      )
                    ),
                  ),
                ),),
                SizedBox(
                  height: 10,
                ),

                tvshow.overview == null || tvshow.overview==''? Container(): Padding(
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
                  child: tvshow.overview == null || tvshow.overview==''? Container(): Text(
                    tvshow.overview!,
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

                Obx(() => infoController.tvShowPhotosList.value.isNotEmpty
                    ? CarouselImagesWidget(
                        photosList: infoController.tvShowPhotosList.value)
                    : Container(
                  width: 0,
                  height: 0,
                )),

                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    'Seasons',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),

                Obx(()=>
                    infoController.seasonsList.value.isEmpty?
                       Container(
                         width: 0,
                         height: 0,
                       ):
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height*0.5,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: infoController.seasonsList.value.length,
                                    itemBuilder: (context,index){
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              if(infoController.seasonsList.value[index].posterPath != null)
                                                Get.to(()=> SeasonDetails(seriesID: tvshow.id!,
                                                  seriesName: tvshow.name!,
                                                  seasonNumber:index+1,
                                                ),
                                                    arguments: infoController.seasonsList.value[index],transition: Transition.circularReveal,curve: Curves.bounceInOut);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              child: infoController.seasonsList.value[index].posterPath==null? Container(
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
                                                          NetworkImage(imageTmdbApiLink+ infoController.seasonsList.value[index].posterPath!)
                                                      )
                                                  )
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            width: MediaQuery.of(context).size.width*0.4,
                                            child: Center(
                                              child:  Obx(()=>
                                                  Text.rich(
                                                    TextSpan(
                                                        children:[
                                                          TextSpan(text: 'Season ',style: GoogleFonts.lato(
                                                            fontSize: 18,
                                                            color: themeController.isDarkModeEnabled.value?Colors.grey[100]:Colors.grey[900]
                                                          )),
                                                          TextSpan(text: '${infoController.seasonsList.value[index].seasonNumber}',style: GoogleFonts.lato(
                                                            fontSize: 18,
                                                            color: Colors.pinkAccent,
                                                            fontWeight: FontWeight.w400
                                                          )),
                                                        ]
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            child: Obx(()=> Text.rich(
                                              TextSpan(
                                                  children:[
                                                    TextSpan(text: '${infoController.seasonsList.value[index].episodes!.length}',style: GoogleFonts.lato(
                                                      fontSize: 18,
                                                      color: Colors.pinkAccent,
                                                      fontWeight: FontWeight.w400
                                                    )),
                                                    TextSpan(text: ' Episodes ',style: GoogleFonts.lato(
                                                      fontSize: 18,
                                                      color: themeController.isDarkModeEnabled.value?Colors.grey[100]:Colors.grey[900]
                                                    )),
                                                  ]
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            ),
                                          ),

                                        ],
                                      );
                                    },

                              ),
                            ),
                          ),
                        )
                ),

                Obx(()=>  infoController.seriesVideosList.value.isEmpty? Container(width: 0,height: 0,):
                SizedBox(height: 20,)),

                Obx(()=>
                infoController.seriesVideosList.value.isEmpty?  Container(
                      width: 0,
                      height: 0,
                    ):Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      'Trailer',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),

        Obx(()=>
        infoController.seriesVideosList.value.isEmpty?  Container(
          width: 0,
          height: 0,
        ): CarouselVideosWidget(
                        videosList: infoController.seriesVideosList.value),
        ),

                SizedBox(
                  height: 10,
                ),

                Obx(
                  () => infoController.fullCastList.value.isEmpty
                      ? Container(
                    width: 0,
                    height: 0,
                  )
                      : Padding(
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
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: infoController.fullCastList.value.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                              onTap: () async{


                                                if(infoController.fullCastList.value[index].id != null){
                                                  PersonModel personModel = await infoController.getActorAsPersonModel(infoController.fullCastList.value[index].id!);
                                                  Get.to(()=>FullPersonDetails(personModel:
                                                  personModel,));
                                                }

                                              },
                                              child: CachedNetworkImage(
                                                  imageUrl: infoController.fullCastList
                                                      .value[index]
                                                      .profilePath!= null?
                                                  imageTmdbApiLink +
                                                      infoController.fullCastList
                                                          .value[index]
                                                          .profilePath!
                                                  :errorImageUrl,
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      Center(
                                                          child: CircularProgressIndicator(
                                                              value:
                                                                  downloadProgress
                                                                      .progress)),
                                                  errorWidget: (context, url,
                                                          err) =>
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width/4,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    5.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          35)),
                                                          color: Colors
                                                              .transparent,
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/service_out.jpg'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                        margin: EdgeInsets.only(
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
                                                              infoController.fullCastList
                                                                          .value[
                                                                              index]
                                                                          .name ==
                                                                      null
                                                                  ? ''
                                                                  : infoController.fullCastList
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
                        ),
                ),

                Obx(()=>
                infoController.fullCrewList.value.isEmpty?Container(
                  width: 0,
                  height: 0,
                ):Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Column(
                    children: [
                      Text(
                        'Crew',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: SizedBox(
                          height: 160,
                          child:
                           ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                              infoController.fullCrewList.value.length,
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
                                          .fullCrewList
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
                                                          .fullCrewList
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
                                                    'assets/images/empty1.jpg'),
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
                                            .fullCrewList
                                            .value[index]
                                            .name ==
                                            null
                                            ? ''
                                            : infoController.fullCrewList
                                            .value[index].name!,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        maxLines: 2,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(infoController.fullCrewList.value[index].job!,textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,maxLines: 2,style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: themeController.isDarkModeEnabled.value?Colors.grey[100]:Colors.grey[900]
                                        ),)
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),


                Obx(()=>
                infoController.seriesOmdbDetails.value ==null?
                Container(
                  width: 0,
                  height: 0,
                ): infoController.seriesOmdbDetails.value!.writer==null?Container(): Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                      'Writers & Authors',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
                Obx(()=>
                infoController.seriesOmdbDetails.value ==null?
                Container(
                  width: 0,
                  height: 0,
                ): infoController.seriesOmdbDetails.value!.writer ==null? Container(): Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    infoController.seriesOmdbDetails.value!.writer!,
                  ),
                ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    'Awards',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),

                Obx(()=>
                infoController.seriesOmdbDetails.value ==null?
                Container(
                  width: 0,
                  height: 0,
                )
                    : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                      infoController.seriesOmdbDetails.value!.awards == null
                          ? 'N/A'
                          : infoController.seriesOmdbDetails.value!.awards!),
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
                infoController.seriesOmdbDetails.value ==null?
                Container(
                  width: 0,
                  height: 0,
                ) : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                      infoController.seriesOmdbDetails.value!.production == null
                          ? 'N/A'
                          : infoController.seriesOmdbDetails.value!.production!),
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
                infoController.seriesOmdbDetails.value ==null?
                Container(
                  width: 0,
                  height: 0,
                ) : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                      infoController.seriesOmdbDetails.value!.boxOffice == null
                          ? 'N/A'
                          : infoController.seriesOmdbDetails.value!.boxOffice!),
                ),
                ),
                SizedBox(
                  height: 20,
                )




              ],
            )),
          ],
        ),
      ),
    );
  }
}
