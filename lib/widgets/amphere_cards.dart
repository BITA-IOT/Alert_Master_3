import 'package:app/controller/mqtt_controller/mqtt_controller.dart';
import 'package:app/views/home/amphere_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AverageInfoCard extends StatelessWidget {
  AverageInfoCard({super.key});
  final MqttController _mqttController = Get.find<MqttController>();
  void onCardTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AmpereScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                              Obx(() {
                                final set1 = int.tryParse(_mqttController
                                        .amp2.value
                                        .toString()) ??
                                    0;
                                final set2 = int.tryParse(_mqttController
                                        .amp3.value
                                        .toString()) ??
                                    0;

                                final set3 = int.tryParse(_mqttController
                                        .amp1.value
                                        .toString()) ??
                                    0;

                                final avgSet = (set1 + set2 + set3) ~/ 3;
                                return Text(
                                  '$avgSet AMP',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                );
                              }),
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
