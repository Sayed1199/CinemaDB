import 'package:cinema_db/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CarouselVideosWidget extends StatefulWidget {
  final List<MovieVideosModel> videosList;

  CarouselVideosWidget({Key? key, required this.videosList}) : super(key: key);

  @override
  State<CarouselVideosWidget> createState() => _CarouselVideosWidgetState();
}

class _CarouselVideosWidgetState extends State<CarouselVideosWidget> {


  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
    child: Builder(builder: (context){
      String key = '';
      widget.videosList.forEach((element) {
        if (element.type == 'Trailer') {
          key = element.key!;
        }
      });

      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: key,
        params: YoutubePlayerParams(
          startAt: Duration(seconds: 0),
          showControls: true,
          showFullscreenButton: true,
        ),
      );

      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4,
          child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
            child: YoutubePlayerControllerProvider( // Provides controller to all the widget below it.
              controller: _controller,
              child: YoutubePlayerIFrame(
                aspectRatio: 16 / 9,
              ),
            ),
      ),
      );

    }),
    );
    /*
      Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
          child: Builder(builder: (context) {
            String key = '';
            widget.videosList.forEach((element) {
              if (element.type == 'Trailer') {
                key = element.key!;
              }
            });

            YoutubePlayerController _controller = YoutubePlayerController(
              initialVideoId: key,
              flags: YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            );

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:

                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.amber,
                    progressColors: ProgressBarColors(
                      playedColor: Colors.amber,
                      handleColor: Colors.amberAccent,
                    ),
                    bottomActions: [],
                    onReady: () {
                      //_controller.addListener(listener);
                    },
                  )

              ),
            );
          }),
          /*
          CarouselSlider.builder(
            itemCount: videosList.length,
            itemBuilder: (context, index, idx) {
              YoutubePlayerController _controller = YoutubePlayerController(
                initialVideoId: videosList[index].key!,
                flags: YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              );
              return Stack(
                children: [
                  GestureDetector(

                    onTap: () {
                      /*
                      if(photosList[index] != null) {
                        Get.to(() => FullImageView(imagesList: photosList,index: index,));
                      }
                      */
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: videosList[index] != null?
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height/2,
                            child: YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Colors.amber,
                              progressColors: ProgressBarColors(
                                playedColor: Colors.amber,
                                handleColor: Colors.amberAccent,
                              ),
                              bottomActions: [],
                              onReady: (){
                                //_controller.addListener(listener);
                              },
                            ),

                          )
                          :Container(
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
          */

    );
    */


  }
}
