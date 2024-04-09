import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../colors/all_colors.dart';
import '../../provider/getStatusProvider.dart';

class ImageView extends StatefulWidget {
  String imagePath;
  bool deleteImage;

  ImageView({super.key, required this.imagePath, this.deleteImage = false});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late bool whatsAppType = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      whatsAppType =
          Provider.of<GetStatusProvider>(context, listen: false).whatsAppPath;
    });
    debugPrint("Whatsapp Type $whatsAppType");
  }

  Future<void> _downloadImage() async {
    // Get the image path
    final imagePath = widget.imagePath;

    // Check if the image path exists
    if (!File(imagePath).existsSync()) {
      log("Image file does not exist: $imagePath");
      return;
    }

    // Read image file as bytes
    final Uint8List imageBytes = await File(imagePath).readAsBytes();

    // Create the directory
    final directory = Directory(whatsAppType
        ? '/storage/emulated/0/My App/WhatsApp'
        : '/storage/emulated/0/My App/WhatsApp Business');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Extract the filename
    final fileName = path.basename(imagePath);

    // Construct the save path
    final savePath = path.join(directory.path, fileName);

    // Copy the image file
    try {
      await File(imagePath).copy(savePath);
      log("Image saved to: $savePath");

      // Trigger media scan
      final response = await ImageGallerySaver.saveImage(imageBytes);
      final savedImagePath = response['filePath'] ?? '';

      if (savedImagePath.isNotEmpty) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image downloaded successfully!')),
        );

        // Trigger media scan using platform-specific method
        if (Platform.isAndroid) {
          await const MethodChannel('plugins.flutter.io/image_gallery_saver')
              .invokeMethod('scanFile', {'path': savedImagePath});
        } else if (Platform.isIOS) {
          await const MethodChannel('plugins.flutter.io/image_gallery_saver')
              .invokeMethod('saveFile', {'path': savedImagePath});
        }
      } else {
        log('Failed to save image to gallery');
      }
    } catch (e) {
      log('Error saving image: $e');
    }
  }

  Future<void> _shareImage() async {
    final file = File(widget.imagePath);
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await file.copy(path);
    final xFile = XFile(path);
    await Share.shareXFiles([xFile]);
  }

  Future<void> _deleteImage() async {
    final file = File(widget.imagePath);
    try {
      await file.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image deleted successfully!'),
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
          widget.deleteImage
              ? FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  heroTag: 'fab_download', // Unique tag for download button
                  onPressed: () {
                    _deleteImage();
                  },
                  child: const Icon(Icons.delete_forever),
                )
              : FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  heroTag: 'fab_download', // Unique tag for download button
                  onPressed: () {
                    _downloadImage();
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
      body: Center(
        child: Stack(
          children: [
            InteractiveViewer(
                minScale: 1.0,
                maxScale: double.infinity,
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit
                      .contain, // Ensure the image fits within the viewport
                )),
            // Progress indicator
            if (widget.imagePath.isEmpty)
              const CircularProgressIndicator(color: MyColors.lightGreenColor),
          ],
        ),
      ),
    );
  }
}
