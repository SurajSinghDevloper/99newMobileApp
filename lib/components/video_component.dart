import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoComponent extends StatefulWidget {
  final String videoUrl; // Parameter to accept the video URL

  const VideoComponent({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoComponentState createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  late YoutubePlayerController _controller;
  bool isPlayerReady = false;
  bool isMuted = true; // Initial mute state

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: false, // Start paused by default
          mute: true, // Default mute setting
        ),
      )..addListener(() {
        if (_controller.value.hasError) {
          // Handle player error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading video: ${_controller.value.errorCode}')),
          );
        }
      });
      _controller.addListener(() {
        if (mounted) {
          setState(() {
            isPlayerReady = _controller.value.isReady;
          });
        }
      });
    } else {
      // Handle invalid video URL
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid video URL')),
      );
    }
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
      _controller.setVolume(isMuted ? 0 : 100); // Set volume to 0 if muted
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0), // Add margin for better spacing
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  // Handle player ready state
                  setState(() {
                    isPlayerReady = true;
                  });
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: IconButton(
            icon: Icon(
              isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: _toggleMute,
          ),
        ),
      ],
    );
  }
}
