import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_app/colors/all_colors.dart';
import 'package:whats_app/screens/saved/saved_screen.dart';
import 'package:whats_app/screens/videos/videos_screen.dart';

import '../provider/getStatusProvider.dart';
import '../provider/theme_manager.dart';
import 'images/images_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool switchValue = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetStatusProvider>(context, listen: false).whatsAppType;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return DefaultTabController(
        length: 3,
        child: Consumer<GetStatusProvider>(builder: (context, file, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Whats App Status Downloader",
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Switch(
                    activeColor: MyColors.whiteColor,
                    activeTrackColor: MyColors.greenColor,
                    inactiveThumbColor: MyColors.whiteColor,
                    inactiveTrackColor: MyColors.lightGreenColor,
                    activeThumbImage: const AssetImage("assets/night-mode.png"),
                    inactiveThumbImage:
                        const AssetImage("assets/light-mode.png"),
                    value: themeManager.isDarkMode,
                    onChanged: (value) => themeManager.toggleTheme(),
                  ),
                ),
              ],
              bottom: const TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                // indicatorColor: MyColors.whiteColor,
                tabs: [
                  Tab(
                      child: Text(
                    "Image",
                    // style: TextStyle(color: MyColors.whiteColor),
                  )),
                  Tab(
                    child: Text("Video",
                        style: TextStyle(
                            // color: MyColors.whiteColor
                            )),
                  ),
                  Tab(
                      child: Text("Saved",
                          style: TextStyle(
                              // color: MyColors.whiteColor
                              ))),
                ],
              ),
            ),
            drawer: Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Set desired border radius
              ),
              child: ListView(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle,
                            // color: MyColors.whiteColor,
                            size: 48.0),
                        SizedBox(height: 12.0),
                        Text(
                          "My Whats App",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Image(
                      image: AssetImage("assets/wa.png"),
                      height: 20,
                      width: 20,
                    ),
                    title: const Text('Whats App'),
                    onTap: () {
                      Navigator.pop(context);

                      file.setWhatsAppPath(true);
                      file.setWhatsAppType("WhatsApp");
                      debugPrint("Whatsapp Clicked");
                      setState(() {});
                    },
                  ),
                  ListTile(
                    leading: const Image(
                      image: AssetImage("assets/wab.png"),
                      height: 20,
                      width: 20,
                    ),
                    title: const Text('Whats App Business'),
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        file.setWhatsAppPath(false);
                        file.setWhatsAppType("WhatsAppB");
                        debugPrint("WhatsappB Clicked");
                      });
                    },
                  ),
                ],
              ),
              // },
              // ),
            ),
            body: TabBarView(
              children: [
                file.whatsAppPath
                    ? Consumer<GetStatusProvider>(
                        builder: (context, file, child) => const ImagesScreen())
                    : const ImagesScreen(),
                file.whatsAppPath
                    ? Consumer<GetStatusProvider>(
                        builder: (context, file, child) => const VideosScreen())
                    : const VideosScreen(),
                file.whatsAppPath
                    ? Consumer<GetStatusProvider>(
                        builder: (context, file, child) => const SavedScreen())
                    : const SavedScreen(),
              ],
            ),
          );
        }));
  }
}
