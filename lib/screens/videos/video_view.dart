import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../colors/all_colors.dart';
import '../../provider/getStatusProvider.dart';

class VideoView extends StatefulWidget {
  String videoPath;
  bool deleteVideo;

  VideoView({super.key, required this.videoPath, this.deleteVideo = false});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  var whatsAppType;

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
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      whatsAppType =
          Provider.of<GetStatusProvider>(context, listen: false).whatsAppPath;
    });
    debugPrint("whatsapp type $whatsAppType");
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
      log("Video file does not exist: $videoPath");
      return;
    }

    // Create the directory
    final directory = Directory(whatsAppType
        ? '/storage/emulated/0/My App/WhatsApp'
        : '/storage/emulated/0/My App/WhatsApp Business');
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
      log("Video saved to: $savePath");

      // Save video to the gallery
      final isSaved = await GallerySaver.saveVideo(savePath) ?? false;
      if (isSaved) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video downloaded successfully!')),
        );

        // Trigger media scan using platform-specific method
        if (Platform.isAndroid) {
          await const MethodChannel('plugins.flutter.io/gallery_saver')
              .invokeMethod('saveFile', {'filePath': savePath});
        } else if (Platform.isIOS) {
          await const MethodChannel('plugins.flutter.io/gallery_saver')
              .invokeMethod('saveFile', {'filePath': savePath});
        }
      } else {
        log('Failed to save video to gallery');
      }
    } catch (e) {
      log('Error saving video: $e');
    }
  }

  Future<void> _shareImage() async {
    Share.shareFiles([widget.videoPath]);
  }

  Future<void> _deleteVideo() async {
    final file = File(widget.videoPath);
    try {
      await file.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video deleted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Whats App Status Downloader"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          widget.deleteVideo
              ? FloatingActionButton(
                  // backgroundColor: MyColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  heroTag: 'fab_download', // Unique tag for download button
                  onPressed: () {
                    _deleteVideo();
                  },
                  child: const Icon(Icons.delete_forever),
                )
              : FloatingActionButton(
                  // backgroundColor: MyColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  heroTag: 'fab_download', // Unique tag for download button
                  onPressed: () {
                    _downloadVideo();
                  },
                  child: const Icon(Icons.file_download),
                ),
          const SizedBox(width: 20.0), // Added spacing between buttons
          FloatingActionButton(
            // backgroundColor: MyColors.secondaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
            return Visibility(
              visible: true,
              child: Chewie(controller: _chewieController),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
