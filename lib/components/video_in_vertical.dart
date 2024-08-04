import 'package:flutter/material.dart';
import 'package:newsapp99/components/video_component.dart';

class VideoInVertical extends StatefulWidget {
  final List<String> videoUrls;

  VideoInVertical({required this.videoUrls});

  @override
  State<VideoInVertical> createState() => _VideoInVerticalState();
}

class _VideoInVerticalState extends State<VideoInVertical> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // Ensure the container has a bounded height
      child: ListView.builder(
        itemCount: widget.videoUrls.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Text('Video ${index + 1}'),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: VideoComponent(videoUrl: widget.videoUrls[index]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Video Player for $url',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
