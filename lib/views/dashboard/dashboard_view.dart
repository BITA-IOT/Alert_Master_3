import 'package:app/controller/mqtt_controller/mqtt_controller.dart';
import 'package:app/views/dashboard/custom_widget/info_card2.dart';
import 'package:app/views/dashboard/custom_widget/info_card3.dart';
import 'package:app/views/dashboard/custom_widget/oil_pressure.dart';
import 'package:app/views/dashboard/custom_widget/amphere_cards.dart';
import 'package:app/views/dashboard/custom_widget/info_card.dart';
import 'package:app/views/dashboard/custom_widget/pressure_cards.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final MqttController _mqttController = Get.put(MqttController());
  @override
  Widget build(BuildContext context) {
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
                    colors: [
                      Colors.yellow,
                      Colors.green,
                      Colors.yellow,
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
                      const SizedBox(
                        height: 40,
                      ),
                      const Center(
                        child: Text(
                          "ALERT MASTER 3",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
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
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text:
                                          _mqttController.comp1status.value == 0
                                              ? 'ON'
                                              : 'OFF',
                                      style: TextStyle(
                                        color:
                                            _mqttController.comp1status.value ==
                                                    0
                                                ? Colors.green
                                                : Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
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
                                subtitle: ' ${_mqttController.temp3.value}°C',
                                onTap: () {
                                  showUpdateDialog(
                                      context: context,
                                      title: "suction",
                                      currentTemp: _mqttController.temp3.value,
                                      currentHighTemp:
                                          _mqttController.temp3setlow.value,
                                      currentLowTemp:
                                          _mqttController.temp3sethigh.value,
                                      onUpdate: _mqttController.updateSuction);
                                },
                              )),
                          Obx(
                            () => InfoCard(
                              icon: Icons.thermostat,
                              color: Colors.redAccent,
                              title: "DISCHARGE",
                              subtitle: ' ${_mqttController.temp4.value}°C',
                              onTap: () {
                                showUpdateDialog(
                                    context: context,
                                    title: "Discharge",
                                    currentTemp: _mqttController.temp4.value,
                                    currentHighTemp:
                                        _mqttController.temp4setlow.value,
                                    currentLowTemp:
                                        _mqttController.temp4sethigh.value,
                                    onUpdate:
                                        _mqttController.updateDischargeTemp);
                              },
                            ),
                          )
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
                          ),
                          InfoCard3(
                            context: context,
                            image: 'assets/images/pressure icon.png',
                            color: Colors.redAccent,
                            title: 'H.P.',
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Enter Password'),
                                      content: TextField(
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                            hintText: "Password"),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (passwordController.text ==
                                                "1234") {
                                              Navigator.of(context).pop();
                                              _mqttController
                                                  .toggleCardVisibility();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Invalid password')),
                                              );
                                            }
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: AverageInfoCard()),
                          Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (_mqttController.currentCardIndex.value == 1)
                                  GestureDetector(
                                    onLongPress: () {
                                      _mqttController.currentCardIndex.value =
                                          0;
                                    },
                                    child: OilPressure(
                                      // context: context,
                                      image: 'assets/images/pressure icon.png',
                                      color: Colors.green,
                                      title: 'O.P.',
                                    ),
                                  ),

                                // Show second card if currentCardIndex is 2
                                if (_mqttController.currentCardIndex.value == 2)
                                  OilTemperatureCard(
                                    controller: _mqttController,
                                  )
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showTemperatureDialog(BuildContext context, String title,
      int currentTemp, Function(String) onUpdate) {
    TextEditingController tem_mqttController =
        TextEditingController(text: "$currentTemp");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update $title Temperature'),
          content: TextField(
            controller: tem_mqttController,
            decoration: const InputDecoration(
              labelText: 'New Temperature',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                onUpdate(tem_mqttController.text);
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
  required int currentTemp,
  required int currentHighTemp,
  required int currentLowTemp,
  required Function(
    String,
    String,
  ) onUpdate,
}) {
  TextEditingController highTem_mqttController =
      TextEditingController(text: "$currentHighTemp");
  TextEditingController lowTem_mqttController =
      TextEditingController(text: "$currentLowTemp");

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Update $title Temperature'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Temperature TextField
            Text("$currentTemp"),
            const SizedBox(height: 10),
            // High Temperature TextField
            TextField(
              controller: highTem_mqttController,
              decoration: const InputDecoration(
                labelText: 'High Temperature',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // Low Temperature TextField
            TextField(
              controller: lowTem_mqttController,
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
              onUpdate(highTem_mqttController.text, lowTem_mqttController.text);
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
