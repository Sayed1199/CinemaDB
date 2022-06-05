import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/controllers/person_controller.dart';
import 'package:cinema_db/controllers/theme_controller.dart';
import 'package:cinema_db/models/person_model.dart';
import 'package:cinema_db/screens/full_image_view.dart';
import 'package:cinema_db/screens/movie_details.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
                  return Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: personController.worksList.value.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                Get.to(()=>MovieDetails(),arguments: personController.worksList.value[index]);
                              },
                              child: Container(
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: imageTmdbApiLink +
                                          personController.worksList.value[index].posterPath!,
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
                                                  child: Obx(()=> Text( personController.worksList.value[index].title==null?'':personController.worksList.value[index].title!,textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 18),overflow: TextOverflow.ellipsis,)),
                                                ),
                                                Obx(()=>
                                                    Text.rich(
                                                      TextSpan(
                                                          children:[
                                                            TextSpan(text: '${(double.parse(( personController.worksList.value[index].voteAverage)!)/2).toStringAsFixed(1)}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.pinkAccent)),
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


        ],
      ),
    );
  }
}
