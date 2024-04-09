import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../provider/getStatusProvider.dart';

// class VideoThumbnailWidget extends StatefulWidget {
//   var videoPath;
//
//   VideoThumbnailWidget({super.key, required this.videoPath});
//
//   @override
//   State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
// }
//
// class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
//   late VideoPlayerController _videoPlayerController;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<GetStatusProvider>(context, listen: false).getStatus(".mp4");
//     });
//
//     _videoPlayerController = VideoPlayerController.file(
//       File(widget.videoPath),
//     )..initialize().then((_) {
//         setState(() {});
//       });
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           VideoPlayer(_videoPlayerController),
//           const Icon(
//             Icons.play_arrow,
//             size: 50,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }
// }

class VideoThumbnailWidget extends StatefulWidget {
  final String videoPath;

  const VideoThumbnailWidget({Key? key, required this.videoPath})
      : super(key: key);

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _videoPlayerController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetStatusProvider>(context, listen: false).getStatus(".mp4");
      _initializeVideoPlayer();
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.videoPath),
    );

    await _videoPlayerController.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _isInitialized
            ? VideoPlayer(_videoPlayerController)
            : Container(), // Placeholder or loading indicator while initializing
        const Icon(
          Icons.play_arrow,
          size: 50,
          color: Colors.white,
        ),
      ],
    );
  }
}
