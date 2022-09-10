import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class video_player extends StatefulWidget {
  const video_player({Key? key}) : super(key: key);

  @override
  State<video_player> createState() => _video_playerState();
}

class _video_playerState extends State<video_player>
    with TickerProviderStateMixin {
  VideoPlayerController? _playerController;
  late VoidCallback listner;
  AnimationController? _controller;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    listner = () {
      setState(() {});
    };
  }

  void CreateVideo() {
    if (_playerController == null) {
      _playerController = VideoPlayerController.network(
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        ..addListener(listner)
        ..setVolume(1.0)
        ..initialize()
        ..play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          child: _playerController != null
              ? VideoPlayer(_playerController!)
              : Container(),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        CreateVideo();
        setState(() {
          // If the video is playing, pause it.
          if (_playerController!.value.isPlaying) {
            _playerController!.pause();
          } else {
            // If the video is paused, play it.
            _playerController!.play();
          }
        });
      }),
    );
  }
}
