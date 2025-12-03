import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_status_saver/controllers/status_controller.dart';
import 'package:whatsapp_status_saver/screens/videos/video_view.dart';
import 'package:whatsapp_status_saver/widget/accept_permission.dart';
import 'package:whatsapp_status_saver/widget/video_thumbnail_widget.dart';

class VideosScreen extends StatelessWidget {
  VideosScreen({super.key});

  final statusController = Get.find<StatusController>();
  @override
  Widget build(BuildContext context) {
    // Trigger fetching videos after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statusController.getStatus(".mp4");
    });

    return Obx(() {
      if (!statusController.permissionFound.value) {
        return const AcceptPermission();
      }
      if (statusController.videosList.isEmpty) {
        return const Center(child: Text("Status Not Found"));
      }
      if (!statusController.whatsAppPath.value) {
        return const Center(child: Text("WhatsApp Not Found"));
      }
      return RefreshIndicator(
        onRefresh: () async {
          debugPrint("WhatsApp Refresh Path ${statusController.whatsAppPath}");
          statusController.getStatus(".mp4");
        },
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: statusController.videosList.length,
          itemBuilder: (context, index) {
            final video = statusController.videosList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoView(videoPath: video.path),
                  ),
                );
              },
              child: VideoThumbnailWidget(videoPath: video.path),
            );
          },
        ),
      );
    });
  }
}
