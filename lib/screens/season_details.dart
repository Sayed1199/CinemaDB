import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/tvShow_season_details_model.dart';
import 'package:cinema_db/screens/episode_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class SeasonDetails extends StatefulWidget {
  final int seriesID;
  final String seriesName;
  final int seasonNumber;
  const SeasonDetails({Key? key,required this.seriesID,required this.seriesName,required this.seasonNumber}) : super(key: key);

  @override
  _SeasonDetailsState createState() => _SeasonDetailsState();
}

class _SeasonDetailsState extends State<SeasonDetails> {

  TvSeasonDetailsModel seasonModel = Get.arguments;
  ThemeController themeController = Get.put(ThemeController());

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
              expandedHeight: 500.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  //'\nSeason ${seasonModel.seasonNumber}',
                  '',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
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
                          '$imageTmdbApiLink${seasonModel.posterPath}'),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    )),
              ),
            ),
          ),


          SliverList(delegate: SliverChildListDelegate([

            SizedBox(height: 20,),

            Padding(
              padding: EdgeInsets.only(left: 30,),
              child: Text(
                'AirDate - ${seasonModel.airDate}',
                style: TextStyle(fontSize: 22, letterSpacing: 1.2),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Padding(
              padding: EdgeInsets.only(left: 30,),
              child: Text(
                'Episodes',
                style: TextStyle(fontSize: 22, letterSpacing: 1.2),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 350,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: seasonModel.episodes!.length,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){

                          Get.to(()=>EpisodeDetails(seriesID: widget.seriesID,seriesName: widget.seriesName, seasonNumber: widget.seasonNumber,
                            episodeNumber: index+1,),arguments: seasonModel.episodes![index],transition: Transition.circularReveal,curve: Curves.bounceInOut);

                        }, child: Container(
                        child: Stack(
                          children: [
                            CachedNetworkImage(imageUrl: imageTmdbApiLink+seasonModel.episodes![index].stillPath!,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                              errorWidget: (context,url,err)=>Container(
                                width: MediaQuery.of(context).size.width*0.6,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(35)),
                                  color: Colors.transparent,
                                  image: DecorationImage(image: AssetImage('assets/images/service_out1.jpg'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              imageBuilder: (context,imageProvider)=> Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.6,
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
                                    width: MediaQuery.of(context).size.width*0.6,
                                    child:
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

                                              Text(seasonModel.episodes![index].name!,maxLines: 2,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 18,
                                                color: themeController.isDarkModeEnabled.value?Colors.white:Colors.black
                                              )),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                                child:
                                                    Text.rich(
                                                      TextSpan(
                                                          children:[
                                                            TextSpan(text: '${(double.parse((seasonModel.episodes![index].voteAverage)!)/2).toStringAsFixed(1)}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.pinkAccent)),
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
            ),

            SizedBox(height: 20,),







          ]
          )),



        ],
      ),
    );
  }
}
