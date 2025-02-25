import 'package:app/controller/mqtt_controller/mqtt_controller.dart';
import 'package:app/views/home/amphere_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AverageInfoCard extends StatelessWidget {
  AverageInfoCard({super.key});
  final MqttController _mqttController = Get.find<MqttController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(() => const AmpereScreen());
        },
        child: Container(
          height: Get.height * 0.13,
          width: Get.width * 0.43,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey, width: 4),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              const Icon(Icons.electric_bolt_sharp,
                  size: 40, color: Colors.redAccent),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      final set1 =
                          int.tryParse(_mqttController.amp2.value.toString()) ??
                              0;
                      final set2 =
                          int.tryParse(_mqttController.amp3.value.toString()) ??
                              0;

                      final set3 =
                          int.tryParse(_mqttController.amp1.value.toString()) ??
                              0;

                      final avgSet = (set1 + set2 + set3) ~/ 3;
                      return Text(
                        '$avgSet AMP',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
