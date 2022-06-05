import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/episode_details_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/tvShow_episode_model.dart';
import 'package:cinema_db/widgets/images_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class EpisodeDetails extends StatefulWidget {
  final int seriesID;
  final String seriesName;
  final int seasonNumber;
  final int episodeNumber;
  const EpisodeDetails({Key? key,required this.seriesID,required this.seriesName,required this.seasonNumber,required this.episodeNumber}) : super(key: key);

  @override
  _EpisodeDetailsState createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends State<EpisodeDetails> {

  Episodes episodesModel = Get.arguments;
  ThemeController themeController = Get.put(ThemeController());
  EpisodeInfoController infoController = Get.put(EpisodeInfoController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [

          SliverPadding(
            padding: EdgeInsets.only(left: 35, bottom: 20),
            sliver: SliverAppBar(
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/left_arrow.svg',
                    width: 30,
                    height: 30,
                    color: Colors.blue,
                  )),
              pinned: false,
              backgroundColor: Colors.transparent,
              expandedHeight: 300.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  episodesModel.name==null?'': '${episodesModel.name}',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                background: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        topLeft: Radius.circular(10)),
                    child: Image(
                      image: NetworkImage(
                          '$imageTmdbApiLink${episodesModel.stillPath}'),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    )),
              ),
            ),
          ),


          SliverList(delegate: SliverChildListDelegate([

            SizedBox(height: 0,),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                'AirDate - ${episodesModel.airDate}',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),

            SizedBox(
              height: 20,
            ),


            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                'Name',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child:
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    child: Text(
                      episodesModel.name==null?'': episodesModel.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: themeController.isDarkModeEnabled.value?Colors.white:Colors.black
                      ),
                    ),
                  ),

                ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
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
                            Fluttertoast.showToast(
                                msg: 'Coming in the future Updates',
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.blue,
                                toastLength: Toast.LENGTH_SHORT,
                                fontSize: 16);
                          },
                          child: Text('Watch',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              )),
                        ),
                ),
                    )


              ],
            ),


            SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                'OverView',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                episodesModel.overview!,
                style: TextStyle(fontSize: 15),
              ),
            ),

            SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Photos',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Builder(
                builder: (context){
              infoController.getEpisodeImages(widget.seriesID, widget.seriesName , widget.seasonNumber, widget.episodeNumber);
              return Obx(()=>
              infoController.mimagesList.value.isEmpty?
                  Center(
                    child: CircularProgressIndicator(),
                  ):Center(child: CarouselImagesWidget(photosList: infoController.mimagesList.value,),
              ),
              );
            }),

            SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Guest Stars',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),

            Builder(
              builder: (context) {
                infoController.getGuestStars(episodesModel);
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10,top: 0),
                  child: SizedBox(
                    height: 200,
                    child: Obx(()=>
                    infoController.guestStars.value.isEmpty
                        ? Center(
                      child: CircularProgressIndicator(),
                    ): ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                        infoController.guestStars.value.length,
                        itemBuilder:
                            (context, index) => GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 100,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                infoController.guestStars.value[index].profilePath !=
                                    null
                                    ? Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            imageTmdbApiLink +
                                                infoController.guestStars.value[index].profilePath!,
                                          ),
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.high)),
                                )
                                    : Container(
                                  height: 90,
                                  decoration: BoxDecoration(
                                      shape:
                                      BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/service_out1.jpg'),
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
                                  infoController.guestStars.value[index]
                                      .name ==
                                      null
                                      ? ''
                                      : infoController.guestStars.value[index].name!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2,
                                  maxLines: 2,
                                ),

                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  infoController.guestStars.value[index]
                                      .name ==
                                      null
                                      ? ''
                                      : infoController.guestStars.value[index].character!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                    fontWeight: FontWeight.w800
                                  ),
                                  maxLines: 2,
                                ),

                              ],
                            ),
                          ),
                        )),
                    ),
                  ),
                );
              }
            ),


            SizedBox(
              height: 20,
            ),





          ]
          )),
        ],
      ),
    );
  }
}
