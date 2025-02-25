import 'dart:developer';

import 'package:app/controller/mqtt_controller/mqtt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OilPressure extends StatelessWidget {
  final String image;
  final Color color;
  final String title;

  OilPressure({
    Key? key,
    required this.image,
    required this.color,
    required this.title,
  }) : super(key: key);
  final MqttController controller = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final setValue = controller.psig3.value;
      final lowValue = controller.psig3sethigh.value;

      Color borderColor;
      double? set = double.tryParse(setValue.toString()); //22
      double? low = double.tryParse(lowValue.toString()); //14

      if (set != null && low != null) {
        log(set.toString());
        log(low.toString());
        if (set <= low) {
          borderColor = Colors.red;
        } else if (set <= low + 10) {
          borderColor = Colors.orange;
        } else {
          borderColor = Colors.green;
        }
      } else {
        borderColor = Colors.grey;
      }

      return GestureDetector(
        onTap: () {
          _showDialog(context, title, controller);
        },
        child: Container(
          height: Get.height * 0.13,
          width: Get.width * 0.43,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 4,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Image.asset(
                image,
                width: 40,
                height: 40,
                color: color,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '$setValue PSI', // Display the set value
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDialog(
      BuildContext context, String title, MqttController controller) {
    final highValue = controller.psig3setlow.value;
    final lowValue = controller.psig3sethigh.value;
    final setValue = controller.psig3;

    final highController = TextEditingController(text: highValue.toString());
    final lowController = TextEditingController(text: lowValue.toString());
    final setController = TextEditingController(text: setValue.toString());

    bool isEditable = false;
    final passwordController = TextEditingController(text: '1234');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Set Levels for $title'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isEditable
                      ? TextField(
                          controller: highController,
                          decoration:
                              const InputDecoration(labelText: 'High Level'),
                          keyboardType: TextInputType.number,
                        )
                      : Text('High Level: $highValue'),
                  isEditable
                      ? TextField(
                          controller: lowController,
                          decoration:
                              const InputDecoration(labelText: 'Low Level'),
                          keyboardType: TextInputType.number,
                        )
                      : Text('Low Level: $lowValue'),
                  isEditable
                      ? TextField(
                          controller: setController,
                          decoration:
                              const InputDecoration(labelText: 'Set Level'),
                          keyboardType: TextInputType.number,
                        )
                      : Text('Set Level: $setValue'),
                ],
              ),
              actions: [
                if (!isEditable)
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Enter Password to Edit'),
                            content: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (passwordController.text == '1234') {
                                    setState(() {
                                      isEditable = true;
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Incorrect password')),
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('OK'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Edit'),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                if (isEditable)
                  TextButton(
                    onPressed: () {
                      final newHighValue = highController.text;
                      final newLowValue = lowController.text;
                      final newSetValue = setController.text;

                      if (double.tryParse(newHighValue) == null ||
                          double.tryParse(newLowValue) == null ||
                          double.tryParse(newSetValue) == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter valid numbers')),
                        );
                        return;
                      }

                      controller.updateOilPressure(newLowValue, newHighValue);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
