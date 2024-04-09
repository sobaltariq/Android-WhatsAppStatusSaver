import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/screens/images/image_view.dart';
import 'package:whats_app/screens/videos/video_view.dart';

import '../../colors/all_colors.dart';
import '../../provider/getStatusProvider.dart';
import '../../widget/AcceptPermision.dart';
import '../../widget/VideoThumbnailWidget.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  dynamic whatsAppT;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetStatusProvider>(context, listen: false).getSaved(".jpg");
      Provider.of<GetStatusProvider>(context, listen: false).getSaved(".mp4");
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
          "${file.whatsAppType} ${file.whatsAppType} ${file.whatsAppPath} ${file.permissionFound} ${file.getAllStatus}");
      if ((file.whatsAppType == "WhatsApp" ||
              file.whatsAppType == "WhatsAppB") &&
          file.whatsAppPath &&
          file.permissionFound &&
          file.getAllStatus.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            debugPrint("WhatsApp Refresh Path ${file.whatsAppPath}");
            file.getSaved(".jpg");
            file.getSaved(".mp4");
          },
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: file.getAllStatus.length,
            itemBuilder: (context, index) {
              final status = file.getAllStatus[index];
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
                        ));
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
                        ));
                  },
                  child: VideoThumbnailWidget(
                    videoPath: status.path,
                  ),
                );
              }
            },
          ),
        );
      } else if (!file.permissionFound) {
        return const AcceptAPermission();
      } else if (file.getAllStatus.isEmpty) {
        debugPrint("status ${file.getAllStatus.length}");
        return const Center(child: Text("Status Not Found"));
      } else {
        return const Center(child: Text("WhatsApp Not Found"));
      }
    }));
  }
}
