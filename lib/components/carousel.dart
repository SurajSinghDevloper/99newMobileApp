import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Define the VideoData class
class VideoData {
  final String url;
  final String title;

  VideoData({required this.url, required this.title});
}

// Define the VideoCarousel class
class VideoCarousel extends StatefulWidget {
  final List<VideoData> videoDataList;

  VideoCarousel({required this.videoDataList});

  @override
  _VideoCarouselState createState() => _VideoCarouselState();
}

class _VideoCarouselState extends State<VideoCarousel> {
  late List<YoutubePlayerController> _controllers;
  bool _isPlaying = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controllers = widget.videoDataList.map((videoData) {
      final videoId = YoutubePlayer.convertUrlToId(videoData.url) ?? '';
      final controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: _isMuted,
        ),
      );
      controller.addListener(() {
        if (controller.value.isPlaying) {
          if (!_isPlaying) {
            setState(() {
              _isPlaying = true;
            });
          }
        } else if (_isPlaying) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
      return controller;
    }).toList();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      for (var controller in _controllers) {
        controller.setVolume(_isMuted ? 0 : 100);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        autoPlay: !_isPlaying,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        autoPlayInterval: Duration(seconds: 8),
      ),
      items: List.generate(widget.videoDataList.length, (index) {
        final controller = _controllers[index];
        final videoData = widget.videoDataList[index];
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Adjust radius as needed
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.red.withOpacity(0.5),
                  width: 1.0, // Border width
                ),
                color: Colors.white, // Background color
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FittedBox(
                            fit: BoxFit.cover, // Ensure the video covers the entire container
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 200.0, // Match the height of the CarouselSlider
                              child: YoutubePlayer(
                                controller: controller,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.amber,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: IconButton(
                            icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                            ),
                            onPressed: _toggleMute,
                          ),
                        ),
                       ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      videoData.title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansDevanagari',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
