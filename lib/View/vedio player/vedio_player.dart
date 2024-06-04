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
    diableFuction();
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

  diableFuction() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 237, 216, 167), // 43%
              Color.fromARGB(255, 223, 214, 192), // 7.74%
              Color.fromARGB(255, 231, 221, 198), // 22.45%
            ],
          ),
        ),
        child: Center(
          child: _controller.value.isInitialized
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay_10),
                          onPressed: () {
                            _controller.seekTo(Duration(
                                seconds:
                                    _controller.value.position.inSeconds - 10));
                          },
                        ),
                        IconButton(
                          icon: _isPlaying
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                          onPressed: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.forward_10),
                          onPressed: () {
                            _controller.seekTo(Duration(
                                seconds:
                                    _controller.value.position.inSeconds + 10));
                          },
                        ),
                      ],
                    ),
                    Slider(
                      thumbColor: AppTheme.appColor,
                      activeColor: AppTheme.appColor,
                      value: _currentSliderValue,
                      min: 0,
                      max: _controller.value.duration!.inSeconds.toDouble(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                        _controller.seekTo(Duration(seconds: value.toInt()));
                      },
                    ),
                  ],
                )
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
