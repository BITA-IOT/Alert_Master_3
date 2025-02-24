import 'package:app/controller/mqtt_controller/mqtt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OilTemperatureCard extends StatelessWidget {
  final MqttController controller;

  const OilTemperatureCard({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 4),
      ),
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.thermostat_outlined,
            color: Colors.blue,
            size: 40,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'O.P.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return Text(
                      controller.isOilTemperatureOn.value ? 'OPEN' : 'CLOSE',
                      style: TextStyle(
                        color: controller.isOilTemperatureOn.value
                            ? Colors.green
                            : Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
