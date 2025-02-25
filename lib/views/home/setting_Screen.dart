import 'package:app/utilz/theme/theme.dart';
import 'package:app/controller/auth_controller.dart';
import 'package:app/controller/controler.dart';
import 'package:app/services/sharedpreference_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthController _authController = Get.put(AuthController());
  final Controller controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dashboard item opacity',
                          style: TextStyle(fontSize: 18),
                        ),
                        Slider(
                          value: controller.dashboardOpacity.value,
                          min: 0,
                          max: 1,
                          activeColor: ThemeColor().snackBarColor,
                          onChanged: (value) {
                            // setState(() {
                            controller.dashboardOpacity.value = value;
                            Sharedpreference14()
                                .saveOpacity('dashboard', value);
                            controller.dashboardOpacity.refresh();
                            // });
                          },
                        ),
                        Text(
                            'Value: ${controller.dashboardOpacity.value.toStringAsFixed(2)}'),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.brightness_6),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Device item opacity',
                          style: TextStyle(fontSize: 18),
                        ),
                        Slider(
                          value: controller.deviceOpacity.value,
                          min: 0,
                          max: 1,
                          activeColor: ThemeColor().snackBarColor,
                          onChanged: (value) {
                            // setState(() {
                            controller.deviceOpacity.value = value;
                            Sharedpreference14().saveOpacity('device', value);
                            controller.deviceOpacity.refresh();
                            // controller.changeloadOpacity(value);
                            // Sharedpreference14().loadOpacityDevice();
                            // });
                          },
                        ),
                        Text(
                            'Value: ${controller.deviceOpacity.value.toStringAsFixed(2)}'),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _authController.logoutFun();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
