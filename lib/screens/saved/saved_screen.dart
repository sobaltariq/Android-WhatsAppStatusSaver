import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_status_saver/controllers/status_controller.dart';
import 'package:whatsapp_status_saver/screens/images/image_view.dart';
import 'package:whatsapp_status_saver/screens/videos/video_view.dart';
import 'package:whatsapp_status_saver/widget/video_thumbnail_widget.dart';
import 'package:whatsapp_status_saver/widget/accept_permission.dart';

class SavedScreen extends StatelessWidget {
  SavedScreen({super.key});

  final statusController = Get.find<StatusController>();

  @override
  Widget build(BuildContext context) {
    // Trigger fetching videos after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statusController.getSaved();
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
          statusController.getSaved();
        },
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: statusController.allList.length,
          itemBuilder: (context, index) {
            final status = statusController.allList[index];
            if (status.path.endsWith(".jpg")) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageView(
                        imagePath: status.path,
                        deleteImage: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    // color: MyColors.secondaryColor,
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: FileImage(File(status.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            } else if (status.path.endsWith(".mp4")) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoView(
                        videoPath: status.path,
                        deleteVideo: true,
                      ),
                    ),
                  );
                },
                child: VideoThumbnailWidget(
                  videoPath: status.path,
                ),
              );
            }
          },
        ),
      );
    });
  }
}
