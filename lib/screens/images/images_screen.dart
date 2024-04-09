import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/screens/images/image_view.dart';

import '../../colors/all_colors.dart';
import '../../provider/getStatusProvider.dart';
import '../../widget/AcceptPermision.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  dynamic whatsAppT;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetStatusProvider>(context, listen: false).getStatus(".jpg");
    });
    var whatsAppT =
        Provider.of<GetStatusProvider>(context, listen: false).whatsAppType;
    debugPrint("ImageScreen Whatsapp Type $whatsAppT");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<GetStatusProvider>(builder: (context, file, child) {
      debugPrint(
          "ImageScreen WA type ${file.whatsAppType} WA Path ${file.whatsAppPath}");
      if ((file.whatsAppType == "WhatsApp" ||
              file.whatsAppType == "WhatsAppB") &&
          file.whatsAppPath &&
          file.permissionFound &&
          file.getImages.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            debugPrint("WhatsApp Refresh Path ${file.whatsAppPath}");
            file.getStatus(".jpg");
          },
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: file.getImages.length,
            itemBuilder: (context, index) {
              final image = file.getImages[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageView(imagePath: image.path),
                      ));
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    // color: MyColors.secondaryColor,
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: FileImage(File(image.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      } else if (!file.permissionFound) {
        return const AcceptAPermission();
      } else if (file.getImages.isEmpty) {
        return const Center(child: Text("Status Not Found"));
      } else {
        return const Center(child: Text("WhatsApp Not Found"));
      }
    }));
  }
}
