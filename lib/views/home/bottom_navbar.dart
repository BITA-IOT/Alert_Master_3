import 'package:app/controller/nav_bar.dart';
import 'package:app/views/devices/device_page.dart';
import 'package:app/views/devices/devices.dart';
import 'package:app/views/home/setting_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatelessWidget {
  final NavBarController controller = Get.put(NavBarController());

  final screens = [DevicesPage(), DevicesScreen(), SettingsScreen()];

  NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Obx(() => IndexedStack(
                index: controller.currentIndex.value,
                children: screens,
              )),
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SafeArea(
                child: Obx(() => BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      elevation: 8,
                      backgroundColor: Colors.white,
                      selectedItemColor: Colors.green,
                      unselectedItemColor: Colors.grey,
                      onTap: (index) {
                        controller.updateIndex(index);
                      },
                      currentIndex: controller.currentIndex.value,
                      items: const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home), label: "Home"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.devices), label: "Add Devices"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.settings), label: "Setting"),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
