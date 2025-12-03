import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status_saver/constants/whatsapp_path.dart';
import 'package:whatsapp_status_saver/controllers/status_controller.dart';

class VideoView extends StatefulWidget {
  final String videoPath;
  final bool deleteVideo;

  const VideoView({super.key, required this.videoPath, this.deleteVideo = false});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  final StatusController statusController = Get.find();

  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(File(widget.videoPath));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.play(); // Start playing the video
    });

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      errorBuilder: (context, errorMessage) {
        return Center(child: Text('Error loading video: $errorMessage'));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> _downloadVideo() async {
    // Get the video path
    final videoPath = widget.videoPath;

    // Check if the video path exists
    if (!File(videoPath).existsSync()) {
      debugPrint("Video file does not exist: $videoPath");
      return;
    }

    // Create directory if doesn't exist
    final directory = Directory(
      statusController.whatsAppPath.value ? WhatsAppPath.whatsappDir : WhatsAppPath.whatsappBDir,
    );
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Extract the filename
    final fileName = path.basename(videoPath);

    // Construct the save path
    final savePath = path.join(directory.path, fileName);

    // Copy the video file
    try {
      await File(videoPath).copy(savePath);
      debugPrint("Video saved to: $savePath");

      // Save video to the gallery
      // final isSaved = await GallerySaver.saveVideo(savePath) ?? false;
      final isSaved = await GallerySaver.saveVideo(savePath) ?? false;
      if (isSaved) {
        // Show success message
        ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text('Video downloaded successfully!')));
      } else {
        debugPrint('Failed to save video to gallery');
      }
    } catch (e) {
      debugPrint('Error saving video: $e');
    }
  }

  Future<void> _shareImage() async {
    final file = XFile(widget.videoPath);
    await SharePlus.instance.share(ShareParams(files: [file]));
  }

  Future<void> _deleteVideo() async {
    final file = File(widget.videoPath);
    try {
      await file.delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video deleted successfully!'), duration: Duration(seconds: 2)),
        );
        Get.back();
      }
    } catch (e) {
      debugPrint("Error deleting file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WhatsApp Status Saver")),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          widget.deleteVideo
              ? FloatingActionButton(
                  // backgroundColor: MyColors.secondaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  heroTag: 'fab_deleted', // Unique tag for download button
                  onPressed: () {
                    _deleteVideo();
                  },
                  child: const Icon(Icons.delete_forever),
                )
              : FloatingActionButton(
                  // backgroundColor: MyColors.secondaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  heroTag: 'fab_download', // Unique tag for download button
                  onPressed: () {
                    _downloadVideo();
                  },
                  child: const Icon(Icons.file_download),
                ),
          const SizedBox(width: 20.0), // Added spacing between buttons
          FloatingActionButton(
            // backgroundColor: MyColors.secondaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            heroTag: 'fab_share', // Unique tag for share button
            onPressed: () {
              _shareImage();
            },
            // onPressed: () => debugPrint('Check out this image!'),
            child: const Icon(Icons.share),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Visibility(visible: true, child: Chewie(controller: _chewieController));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
