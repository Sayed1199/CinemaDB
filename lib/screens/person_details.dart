import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/person_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/movie_model.dart';
import 'package:cinema_db/models/person_model.dart';
import 'package:cinema_db/models/tvShow_model.dart';
import 'package:cinema_db/screens/full_image_view.dart';
import 'package:cinema_db/screens/movie_details.dart';
import 'package:cinema_db/screens/series_details.dart';
import 'package:cinema_db/screens/series_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FullPersonDetails extends StatefulWidget {
  final PersonModel personModel;

  const FullPersonDetails({Key? key, required this.personModel})
      : super(key: key);

  @override
  _FullPersonDetailsState createState() => _FullPersonDetailsState();
}

class _FullPersonDetailsState extends State<FullPersonDetails> {
  PersonController personController = Get.put(PersonController());
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
                  widget.personModel.name == null
                      ? ''
                      : widget.personModel.name!,
                  style: TextStyle(
                    fontSize: 18,
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
                          '$imageTmdbApiLink${widget.personModel.profilePath}'),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    widget.personModel.birthday == null
                        ? 'N/A'
                        : widget.personModel.birthday!,
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '-',
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.personModel.deathday == null
                        ? 'N/A'
                        : widget.personModel.deathday!,
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                'Biography',
                style: TextStyle(fontSize: 22, letterSpacing: 1.2),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, top: 10, right: 10),
              child: RawScrollbar(
                  thumbColor: Colors.blue,
                  child: Text(
                    widget.personModel.biography == null
                        ? 'N/A'
                        : widget.personModel.biography!,
                    style: TextStyle(fontSize: 18, letterSpacing: 1.2),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 20),
              child: Text(
                'PlaceOfBirth',
                style: TextStyle(fontSize: 22, letterSpacing: 1.2),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, top: 10, right: 10),
              child: Text(
                widget.personModel.placeOfBirth == null
                    ? 'N/A'
                    : widget.personModel.placeOfBirth!,
                style: TextStyle(fontSize: 18, letterSpacing: 1.2),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, top: 20,bottom: 10),
              child: Text(
                'Photos',
                style: TextStyle(fontSize: 22, letterSpacing: 1.2),
              ),
            ),
          ]),
          ),
          Builder(builder: (context) {
            personController.getImages(widget.personModel.id!);
            return SliverToBoxAdapter(
              child: Obx(() {
                if (personController.imagesList.value.isEmpty)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  return Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 250,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: personController.imagesList.value.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  Get.to(()=>FullImageView(imagesList: personController.imagesList.value, index: index));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: imageTmdbApiLink +
                                      personController.imagesList.value[index],
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                                  errorWidget: (context, url, err) => Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                        image:
                                        AssetImage('assets/images/error.jpg'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  imageBuilder: (context, imageProvider) => Stack(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width / 2,
                                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                          color: Colors.transparent,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                  );
                }
              }),
            );
          }),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 30, top: 20,bottom: 10),
              child: Text(
                'Works',
                style: TextStyle(fontSize: 22, letterSpacing: 1.2),
              ),
            ),
          ),


          Builder(builder: (context) {
            personController.getPersonWorks(widget.personModel.id!,widget.personModel.name!);
            return SliverToBoxAdapter(
              child: Obx(() {
                if (personController.worksList.value.isEmpty)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5,5,5,10),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.5,
                      width: MediaQuery.of(context).size.width,
                      child: Obx(()=>
                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: personController.worksList.value.length,
                            itemBuilder: (context,index){
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      if(personController.worksList.value[index]['media_type']=='movie'){
                                        Get.to(()=>MovieDetails(),arguments: MovieModel.fromJson(personController.worksList.value[index] as Map<String,dynamic>));
                                      }else{
                                        Get.to(()=>SeriesDetailsScreen(),arguments: TvShowModel.fromJson(personController.worksList.value[index] as Map<String,dynamic>));
                                      }
                                     //
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: personController.worksList.value[index]['poster_path'] ==null? Container(
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
                                                  NetworkImage(imageTmdbApiLink+ personController.worksList.value[index]['poster_path'])
                                              )
                                          )
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.4,
                                    child: Center(
                                      child: Obx(()=>
                                          Text(personController.worksList.value[index]['media_type']=='movie'?
                                          personController.worksList.value[index]['title']:personController.worksList.value[index]['name'],
                                            maxLines: 2,textAlign: TextAlign.center,overflow:TextOverflow.ellipsis, style: GoogleFonts.lato(
                                                fontSize: 18,
                                                color: themeController.isDarkModeEnabled.value?Colors.grey[100]:Colors.grey[900]
                                            ),),
                                      ),
                                    ),),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.4,
                                    child: Obx(()=>
                                        Text.rich(
                                          TextSpan(
                                              children:[
                                                TextSpan(text: '${(personController.worksList.value[index]['vote_average']/2).toStringAsFixed(1)}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.pinkAccent)),
                                                TextSpan(text: ' / ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800)),
                                                TextSpan(text: '5',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
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
                  );
                }
              }),
            );
          }),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),


        ],
      ),
    );
  }
}
