import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  YoutubePlayerController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'awHyqJv3WKE',
      params: YoutubePlayerParams(
        startAt: Duration(seconds: 0),
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _controller!= null? YoutubePlayerControllerProvider( // Provides controller to all the widget below it.
        controller: _controller!,
        child: YoutubePlayerIFrame(
          aspectRatio: 16 / 9,
        ),
      ):Container(),


    );
  }
}
