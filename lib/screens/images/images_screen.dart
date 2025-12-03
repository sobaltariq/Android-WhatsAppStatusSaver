import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_status_saver/controllers/status_controller.dart';
import 'package:whatsapp_status_saver/screens/images/image_view.dart';
import 'package:whatsapp_status_saver/widget/accept_permission.dart';

class ImagesScreen extends StatelessWidget {
  ImagesScreen({super.key});

  final StatusController statusController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Trigger fetching images after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statusController.getStatus(".jpg");
    });

    return Obx(() {
      if (!statusController.permissionFound.value) {
        return const AcceptPermission();
      }
      if (statusController.imagesList.isEmpty) {
        return const Center(child: Text("Status Not Found"));
      }
      if (!statusController.whatsAppPath.value) {
        return const Center(child: Text("WhatsApp Not Found"));
      }
      return RefreshIndicator(
        onRefresh: () async {
          debugPrint("WhatsApp Refresh Path ${statusController.whatsAppPath}");
          statusController.getStatus(".jpg");
        },
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: statusController.imagesList.length,
          itemBuilder: (context, index) {
            final image = statusController.imagesList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageView(imagePath: image.path)),
                );
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(image: FileImage(File(image.path)), fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
