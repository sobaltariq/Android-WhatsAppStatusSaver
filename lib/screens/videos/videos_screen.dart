import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/screens/videos/video_view.dart';

import '../../provider/getStatusProvider.dart';
import '../../widget/AcceptPermision.dart';
import '../../widget/VideoThumbnailWidget.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  dynamic whatsAppT;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetStatusProvider>(context, listen: false).getStatus(".mp4");
    });
    var whatsAppT =
        Provider.of<GetStatusProvider>(context, listen: false).whatsAppType;
    debugPrint("VideoScreen Whatsapp Type $whatsAppT");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<GetStatusProvider>(builder: (context, file, child) {
      debugPrint(
          "${file.whatsAppType} ${file.whatsAppType} ${file.whatsAppPath} ${file.permissionFound} ${file.getVideos.isNotEmpty}");
      if ((file.whatsAppType == "WhatsApp" ||
              file.whatsAppType == "WhatsAppB") &&
          file.whatsAppPath &&
          file.permissionFound &&
          file.getVideos.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            debugPrint("WhatsApp Refresh Path ${file.whatsAppPath}");
            file.getStatus(".mp4");
          },
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: file.getVideos.length,
            itemBuilder: (context, index) {
              final video = file.getVideos[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoView(videoPath: video.path),
                      ));
                },
                child: VideoThumbnailWidget(videoPath: video.path),
              );
            },
          ),
        );
      } else if (!file.permissionFound) {
        return const AcceptAPermission();
      } else if (file.getVideos.isEmpty) {
        return const Center(child: Text("Status Not Found"));
      } else {
        return const Center(child: Text("WhatsApp Not Found"));
      }
    }));
  }
}
