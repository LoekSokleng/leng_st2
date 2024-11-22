import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'package:project_ma/model/course_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  CourseDetailsScreen({required this.course});

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late YoutubePlayerController _controller;
  bool isFullScreen = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.course.videos.isNotEmpty) {
      final videoId =
          YoutubePlayer.convertUrlToId(widget.course.videos[0].videoUrl);
      if (videoId != null && videoId.isNotEmpty) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid initial video URL')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No videos available for this course')),
      );
    }

    _controller.addListener(() {
      if (_controller.value.isFullScreen != isFullScreen) {
        setState(() {
          isFullScreen = _controller.value.isFullScreen;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the controller when the screen is disposed
    super.dispose();
  }

  // Function to play video based on the platform (Web or Mobile)
  void _playVideo(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId != null && videoId.isNotEmpty) {
      setState(() {
        _isPlaying = true;
      });

      if (kIsWeb) {
        setState(() {
          _controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          );
        });
      } else {
        // Mobile: Use YoutubePlayerController for mobile platforms
        _controller.load(videoId); // Load and play the selected video
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid video URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        setState(() {
          isFullScreen = false;
        });
      },
      player: YoutubePlayer(
        controller: _controller,
        liveUIColor: Colors.amber,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: Text(widget.course.title),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.course.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    height: 150,
                    width: double.infinity,
                    child: const Center(child: Text("Image not available")),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                widget.course.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Created by ${widget.course.author}'),
              Text('${widget.course.videoCount} Videos'),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality for video list button here if needed
                    },
                    child: const Text('Videos'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality for description button here if needed
                    },
                    child: const Text('Description'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isPlaying)
                Expanded(
                  child: player,
                ),
              if (!_isPlaying)
                const Center(child: Text('Select a video to play')),
              const SizedBox(height: 16),
              // List of Videos
              Expanded(
                child: ListView.builder(
                  itemCount: widget.course.videos.length,
                  itemBuilder: (context, index) {
                    final video = widget.course.videos[index];
                    return ListTile(
                      leading: const Icon(Icons.play_circle_fill,
                          color: Colors.purple),
                      title: Text(video.title),
                      subtitle: Text(video.duration),
                      onTap: () => _playVideo(video.videoUrl),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
