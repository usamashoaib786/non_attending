import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:non_attending/Utils/resources/app_text.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  double _currentSliderValue = 0.0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    disableFunction();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(() {
      if (_controller.value.isPlaying) {
        setState(() {
          _isPlaying = true;
          _currentSliderValue = _controller.value.position.inSeconds.toDouble();
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  disableFunction() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;

    return Scaffold(
      appBar: isPortrait
          ? AppBar(
              backgroundColor: AppTheme.appColor,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    "assets/images/back.png",
                    height: 30,
                  ),
                ),
              ),
              centerTitle: true,
              title: AppText.appText("Video Player",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  textColor: const Color(0xff0D2393)),
            )
          : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 237, 216, 167),
              Color.fromARGB(255, 223, 214, 192),
              Color.fromARGB(255, 231, 221, 198),
            ],
          ),
        ),
        child: Center(
          child: _controller.value.isInitialized
              ? (isPortrait
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        VideoControls(_controller, _isPlaying, _currentSliderValue, setState),
                      ],
                    )
                  : Stack(
                      children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: VideoControls(_controller, _isPlaying, _currentSliderValue, setState),
                        ),
                      ],
                    ))
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isPlaying;
  final double currentSliderValue;
  final Function setState;

  const VideoControls(this.controller, this.isPlaying, this.currentSliderValue, this.setState);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        VideoProgressIndicator(controller, allowScrubbing: true),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.replay_10),
              onPressed: () {
                controller.seekTo(Duration(seconds: controller.value.position.inSeconds - 10));
              },
            ),
            IconButton(
              icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () {
                setState(() {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.forward_10),
              onPressed: () {
                controller.seekTo(Duration(seconds: controller.value.position.inSeconds + 10));
              },
            ),
          ],
        ),
      ],
    );
  }
}
