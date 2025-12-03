import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:whatsapp_status_saver/colors/all_colors.dart';
import 'package:whatsapp_status_saver/controllers/status_controller.dart';
import 'package:whatsapp_status_saver/controllers/theme_controller.dart';
import 'package:whatsapp_status_saver/screens/images/images_screen.dart';
import 'package:whatsapp_status_saver/screens/saved/saved_screen.dart';
import 'package:whatsapp_status_saver/screens/videos/videos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StatusController statusController = Get.put(StatusController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            title: const Text("WhatsApp Status Saver"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Switch(
                  thumbIcon: WidgetStateProperty.all(
                    Icon(themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode),
                  ),
                  activeThumbColor: MyColors.whiteColor,
                  activeTrackColor: MyColors.greenColor,
                  inactiveThumbColor: MyColors.whiteColor,
                  inactiveTrackColor: MyColors.lightGreenColor,
                  // activeThumbImage: const AssetImage("assets/night-mode.png"),
                  // inactiveThumbImage: const AssetImage("assets/light-mode.png"),
                  value: themeController.isDarkMode.value,
                  onChanged: (value) => themeController.toggleTheme(),
                ),
              ),
            ],
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(child: Text("Images")),
                Tab(child: Text("Videos")),
                Tab(child: Text("Saved")),
              ],
            ),
          ),
          drawer: Drawer(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: ListView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 48.0),
                      SizedBox(height: 12.0),
                      Text("WhatsApp Status Saver", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Image(image: AssetImage("assets/wa.png"), height: 20, width: 20),
                  title: const Text('WhatsApp'),
                  onTap: () {
                    Navigator.pop(context);

                    statusController.setWhatsAppPath(true);
                    statusController.setWhatsAppType("WhatsApp");
                    debugPrint("Whatsapp Clicked");
                    setState(() {});
                  },
                ),
                ListTile(
                  leading: const Image(image: AssetImage("assets/wab.png"), height: 20, width: 20),
                  title: const Text('WhatsApp Business'),
                  onTap: () {
                    Navigator.pop(context);

                    setState(() {
                      statusController.setWhatsAppPath(false);
                      statusController.setWhatsAppType("WhatsAppB");
                      debugPrint("WhatsappB Clicked");
                    });
                  },
                ),
              ],
            ),
          ),
          body: Container(
            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
            child: TabBarView(
              children: [
                ImagesScreen(),
                VideosScreen(),
                SavedScreen(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
