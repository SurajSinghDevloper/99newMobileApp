import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:newsapp99/components/carousel.dart';
import 'package:newsapp99/components/landing_page_header.dart';
import 'package:http/http.dart' as http;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPage> {
  List<VideoData> _topVideosData = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchLatestVideos();
  }

  Future<void> fetchLatestVideos() async {
    final url = Uri.parse('https://99news.co:8080/api/v1/news/latest-videos/public');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
        final List<dynamic> topVideos = jsonResponse.where((videoData) => videoData['videoPriority'] == "OTHERS").toList();
        setState(() {
          _topVideosData = getTopVideoData(topVideos);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Request failed with status: ${response.statusCode}.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  List<VideoData> getTopVideoData(List<dynamic> topVideos) {
    return topVideos.map((videoData) {
      final String url = "https://www.youtube.com/watch?v=${videoData['videoId']}";
      final String title = videoData['title'] ?? 'No Title';
      return VideoData(url: url, title: title);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const LandingPageHeader(),
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 10,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        '99News',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Stay Informed. Stay Ahead.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Handle loading and error states
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Center(child: Text(_errorMessage!))
            else if (_topVideosData.isNotEmpty)
                VideoCarousel(videoDataList: _topVideosData)
              else
                Center(child: Text('No videos available')),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Featured Articles',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Example of Featured Articles Section
            // Uncomment and customize if needed
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: 3,
            //   itemBuilder: (context, index) {
            //     return Card(
            //       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //       child: ListTile(
            //         contentPadding: EdgeInsets.all(10),
            //         leading: Image.asset(
            //           'assets/images/featured_${index + 1}.jpg',
            //           width: 100,
            //           fit: BoxFit.cover,
            //         ),
            //         title: Text('Featured Article #${index + 1}'),
            //         subtitle: Text('Short description of the article...'),
            //       ),
            //     );
            //   },
            // ),
            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement the action for the button
                },
                child: Text('Explore More News'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
