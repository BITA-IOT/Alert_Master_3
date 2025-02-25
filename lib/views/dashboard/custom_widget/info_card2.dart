import 'package:app/controller/mqtt_controller/mqtt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoCard2 extends StatelessWidget {
  final String image;
  final Color color;
  final String title;

  InfoCard2({
    super.key,
    required this.image,
    required this.color,
    required this.title,
  });
  final MqttController controller = Get.find<MqttController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final setValue = controller.psig1.value;
      final lowValue = controller.psig1sethigh.value;

      Color borderColor;
      double? set = double.tryParse(setValue.toString());
      double? low = double.tryParse(lowValue.toString());

      if (set != null && low != null) {
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
              const SizedBox(
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
                      '$setValue PSI',
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
    final highValue = controller.psig1setlow.value;
    final lowValue = controller.psig1sethigh.value;
    final setValue = controller.psig1;

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

                      controller.updateContainerValuesLP(
                          newLowValue, newHighValue);
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
