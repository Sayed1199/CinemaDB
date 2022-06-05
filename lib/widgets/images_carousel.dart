import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinema_db/constants.dart';
import 'package:cinema_db/screens/full_image_view.dart';
import 'package:cinema_db/widgets/image_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarouselImagesWidget extends StatelessWidget {
  final List<String> photosList;
   CarouselImagesWidget({Key? key,required this.photosList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: RawScrollbar(
        thumbColor: Colors.lightBlue,
        radius: Radius.circular(20),
        thickness: 5,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
          child: CarouselSlider.builder(
            itemCount: photosList.length,
            itemBuilder: (context, index, idx) {
              return Stack(
                children: [
                  GestureDetector(

                    onTap: () {
                     /////
                      if(photosList[index] != null) {
                        Get.to(() => FullImageView(imagesList: photosList,index: index,));
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: photosList[index] != null? CachedNetworkImage(
                        imageUrl: imageTmdbApiLink+ photosList[index],
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
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
                    ),
                  ),
                ],
              );
            },
            options: CarouselOptions(
              enableInfiniteScroll: false,
              autoPlay: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(microseconds: 500),
              pauseAutoPlayOnTouch: true,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
              initialPage: 0,
            ),
          ),
        ),
      ),
    );
  }
}
