import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_status_saver/colors/all_colors.dart';
import 'package:whatsapp_status_saver/constants/whatsapp_path.dart';
import 'package:whatsapp_status_saver/controllers/status_controller.dart';
import 'package:path/path.dart' as path;

class ImageView extends StatelessWidget {
  final String imagePath;
  final bool deleteImage;

  ImageView({super.key, required this.imagePath, this.deleteImage = false});

  final StatusController statusController = Get.find();

  Future<void> _downloadImage(BuildContext context) async {
    // Copy the image file
    try {
      final file = File(imagePath);
      if (!file.existsSync()) return;

      // Read image file as bytes
      final Uint8List imageBytes = await file.readAsBytes();

      // Create directory if doesn't exist
      final directory = Directory(
        statusController.whatsAppPath.value ? WhatsAppPath.whatsappDir : WhatsAppPath.whatsappBDir,
      );
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      // Extract the filename
      final fileName = path.basename(imagePath);

      // Construct the save path
      final savePath = path.join(directory.path, fileName);

      await file.copy(savePath);
      debugPrint("Image saved to: $savePath");

      // Trigger media scan
      final response = await ImageGallerySaverPlus.saveImage(imageBytes);
      final savedImagePath = response['filePath'] ?? '';

      if (savedImagePath.isNotEmpty) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image downloaded successfully!")),
        );
      } else {
        debugPrint('Failed to save image to gallery');
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
    }
  }

  Future<void> _shareImage() async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = path.join(tempDir.path, path.basename(imagePath));
    await File(imagePath).copy(tempPath);
    await Share.shareXFiles([XFile(tempPath)]);
  }

  Future<void> _deleteImage(BuildContext context) async {
    final file = File(imagePath);
    try {
      await file.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image deleted successfully!"), duration: Duration(seconds: 2)),
      );
      Get.back();
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
          deleteImage
              ? FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  heroTag: 'fab_deleted', // Unique tag for download button
                  onPressed: () {
                    _deleteImage(context);
                  },
                  child: const Icon(Icons.delete_forever),
                )
              : FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  heroTag: 'fab_download', // Unique tag for download button
                  onPressed: () {
                    _downloadImage(context);
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
      body: Center(
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 1.0,
              maxScale: double.infinity,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain, // Ensure the image fits within the viewport
              ),
            ),
            // Progress indicator
            if (imagePath.isEmpty) const CircularProgressIndicator(color: MyColors.lightGreenColor),
          ],
        ),
      ),
    );
  }
}
