import 'package:app/controller/amphere_controller.dart';
import 'package:app/controller/mqtt_controller/mqtt_controller.dart';
import 'package:app/views/home/amphere_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AverageInfoCard extends StatelessWidget {
  final AmpereController controller;

  AverageInfoCard({required this.controller, Key? key}) : super(key: key);
  final MqttController _mqttController = Get.find<MqttController>();
  void onCardTap(BuildContext context) {
    // Navigate to AmpereScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AmpereScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Safe parsing of values, ensuring the correct data type is used for operations
    final high1 = int.tryParse(controller
                .mqttModel.containerValues['Phase 1']?['High']
                .toString() ??
            '0') ??
        0;
    final low1 = int.tryParse(controller
                .mqttModel.containerValues['Phase 1']?['Low']
                .toString() ??
            '0') ??
        0;
    final set1 = int.tryParse(controller
                .mqttModel.containerValues['Phase 1']?['Set']
                .toString() ??
            '0') ??
        0;

    final high2 = int.tryParse(controller
                .mqttModel.containerValues['Phase 2']?['High']
                .toString() ??
            '0') ??
        0;
    final low2 = int.tryParse(controller
                .mqttModel.containerValues['Phase 2']?['Low']
                .toString() ??
            '0') ??
        0;
    final set2 = int.tryParse(controller
                .mqttModel.containerValues['Phase 2']?['Set']
                .toString() ??
            '0') ??
        0;

    final set3 = int.tryParse(controller
                .mqttModel.containerValues['Phase 3']?['Set']
                .toString() ??
            '0') ??
        0;

    final avgSet = (set1 + set2 + set3) ~/ 3;

    return GestureDetector(
        onTap: () => onCardTap(context), // Handle tap
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey, width: 4),
          ),
          width: MediaQuery.of(context).size.width * 0.42,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Align horizontally
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.electric_bolt_sharp,
                              size: 40, color: Colors.redAccent),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              const Text(
                                'CURRENT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              Text(
                                '$avgSet AMP',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
