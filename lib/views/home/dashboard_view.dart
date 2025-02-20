import 'package:app/controller/amphere_controller.dart';
import 'package:app/controller/dashboard_controller.dart';
import 'package:app/controller/mqtt_controller.dart';
import 'package:app/controller/pressure_controller.dart';
import 'package:app/widgets/amphere_cards.dart';
import 'package:app/widgets/info_card.dart';
import 'package:app/widgets/pressure_cards.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final pcontroller = Get.put(PressureController());
    final acontroller = Get.put(AmpereController());
    final MqttController _mqttController = Get.put(MqttController());

    TextEditingController passwordController = TextEditingController();

    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: () async {
            _mqttController.onInit();
          },
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    // colors: [Color.fromARGB(255, 9, 58, 71), Color.fromARGB(255, 9, 58, 71),],
                    colors: [
                      Colors.green,
                      Colors.green,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Text(
                          "ALERT MASTER 3",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            _mqttController.compStatus(
                                _mqttController.comp1status.value == 1
                                    ? "0"
                                    : "1");
                          },
                          child: Obx(() => Container(
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey, width: 4),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'COMPRESSOR STATUS: ',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                        // Hardcoded text always black
                                        ),
                                    children: [
                                      TextSpan(
                                        text:
                                            _mqttController.comp1status.value ==
                                                    1
                                                ? 'ON'
                                                : 'OFF',
                                        style: TextStyle(
                                          color: _mqttController
                                                      .comp1status.value ==
                                                  1
                                              ? Colors.green
                                              : Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => InfoCard(
                              icon: Icons.thermostat,
                              color: Colors.blue,
                              title: 'C.W. IN',
                              subtitle: ' ${_mqttController.temp1.value}°C',
                              onTap: () => _showTemperatureDialog(
                                context,
                                'Chilled water in',
                                _mqttController.temp1.value,
                                _mqttController.updateChilledWaterInTemp,
                              ),
                            ),
                          ),
                          InfoCard(
                              icon: Icons.thermostat,
                              color: Colors.redAccent,
                              title: 'C.W. OUT',
                              subtitle: ' ${_mqttController.temp2.value}°C',
                              onTap: () {
                                _showTemperatureDialog(
                                  context,
                                  'Chilled water out',
                                  _mqttController.temp2.value,
                                  _mqttController.updateChilledWateroutTemp,
                                );
                              }),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => InfoCard(
                                icon: Icons.thermostat,
                                color: Colors.blue,
                                title: "SUCTION",
                                subtitle:
                                    ' ${controller.model.suctionTemp.value}°C',
                                onTap: () {
                                  showUpdateDialog(
                                    context: context,
                                    title: "suction",
                                    currentTemp:
                                        controller.model.suctionTemp.value,
                                    currentHighTemp:
                                        controller.model.suctionHighTemp.value,
                                    currentLowTemp:
                                        controller.model.suctionLowTemp.value,
                                    onUpdate: (temp, high, low) {
                                      controller.updateSuctionTemps(
                                          temp, high, low);
                                    },
                                  );
                                },
                              )),
                          Obx(() => InfoCard(
                                icon: Icons.thermostat,
                                color: Colors.redAccent,
                                title: "DISCHARGE ",
                                subtitle:
                                    ' ${controller.model.dischargeTemp.value}°C',
                                onTap: () {
                                  showUpdateDialog(
                                    context: context,
                                    title: "Discharge",
                                    currentTemp:
                                        controller.model.dischargeTemp.value,
                                    currentHighTemp: controller
                                        .model.dischargeHighTemp.value,
                                    currentLowTemp:
                                        controller.model.dischargeLowTemp.value,
                                    onUpdate: (temp, high, low) {
                                      controller.updateDischargeTemp(
                                          temp, high, low);
                                    },
                                  );
                                },
                              )),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InfoCard2(
                            // context: context,
                            image: 'assets/images/pressure icon.png',
                            color: Colors.blue,
                            title: 'L.P.',
                            controller: pcontroller,
                          ),
                          InfoCard3(
                            context: context,
                            image: 'assets/images/pressure icon.png',
                            color: Colors.redAccent,
                            title: 'H.P.',
                            controller: pcontroller,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AverageInfoCard(controller: acontroller),
                          Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Show first card if currentCardIndex is 1
                                if (pcontroller.currentCardIndex.value == 1)
                                  InfoCard2(
                                    // context: context,
                                    image: 'assets/images/pressure icon.png',
                                    color: Colors.green,
                                    title: 'O.P.',
                                    controller: pcontroller,
                                  ),

                                // Show second card if currentCardIndex is 2
                                if (pcontroller.currentCardIndex.value == 2)
                                  OilTemperatureCard(
                                    controller: pcontroller,
                                  )
                              ],
                            );
                          }),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.0, // Makes the button fully transparent
                    child: GestureDetector(
                      onDoubleTap: () {
                        pcontroller.toggleCardVisibility();
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          // Action on normal press
                          print("Button pressed!");
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Enter Password'),
                                content: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration:
                                      InputDecoration(hintText: "Password"),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (passwordController.text == "1234") {
                                        Navigator.of(context).pop();
                                        pcontroller.toggleCardVisibility();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('Invalid password')),
                                        );
                                      }
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );

                          // Action on long press
                          print("Button long pressed!");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              vertical: 36.0), // Adjust padding as necessary
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                        ),
                        child: Text(
                          "", // Empty text to ensure the button still exists
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      );
    });
  }

  void _showTemperatureDialog(BuildContext context, String title,
      int currentTemp, Function(String) onUpdate) {
    TextEditingController tempController =
        TextEditingController(text: "$currentTemp");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update $title Temperature'),
          content: TextField(
            controller: tempController,
            decoration: const InputDecoration(
              labelText: 'New Temperature',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                onUpdate(tempController.text);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

void showUpdateDialog({
  required BuildContext context,
  required String title,
  required String currentTemp,
  required String currentHighTemp,
  required String currentLowTemp,
  required Function(String, String, String) onUpdate,
}) {
  TextEditingController tempController =
      TextEditingController(text: currentTemp);
  TextEditingController highTempController =
      TextEditingController(text: currentHighTemp);
  TextEditingController lowTempController =
      TextEditingController(text: currentLowTemp);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Update $title Temperature'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Temperature TextField
            TextField(
              controller: tempController,
              decoration: const InputDecoration(
                labelText: 'Temperature',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // High Temperature TextField
            TextField(
              controller: highTempController,
              decoration: const InputDecoration(
                labelText: 'High Temperature',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // Low Temperature TextField
            TextField(
              controller: lowTempController,
              decoration: const InputDecoration(
                labelText: 'Low Temperature',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          // Update button
          TextButton(
            onPressed: () {
              // Call onUpdate with the new values from the controllers
              onUpdate(
                tempController.text,
                highTempController.text,
                lowTempController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void _showDialog(
    BuildContext context, String title, PressureController controller) {
  final highValue = controller.containerValues[title]?['High'] ?? '';
  final lowValue = controller.containerValues[title]?['Low'] ?? '';
  final setValue = controller.containerValues[title]?['Set'] ?? '';

  final highController = TextEditingController(text: highValue);
  final lowController = TextEditingController(text: lowValue);
  final setController = TextEditingController(text: setValue);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Update $title Pressure'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: setController,
              decoration: const InputDecoration(
                labelText: 'Set Pressure',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: highController,
              decoration: const InputDecoration(
                labelText: 'High Pressure',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: lowController,
              decoration: const InputDecoration(
                labelText: 'Low Pressure',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.updateContainerValues(
                title,
                setController.text,
                highController.text,
                lowController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
