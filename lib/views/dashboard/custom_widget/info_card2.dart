import 'package:app/controller/pressure_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoCard2 extends StatelessWidget {
  final String image;
  final Color color;
  final String title;
  final PressureController controller;

  const InfoCard2({
    Key? key,
    required this.image,
    required this.color,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Obx to make the widget reactive
    return Obx(() {
      // Retrieve the set and low values from the controller
      final setValue = controller.containerValues[title]?['Set'] ?? '*';
      final lowValue = controller.containerValues[title]?['Low'] ?? '*';

      // Attempt to parse the set and low values as doubles
      Color borderColor;
      double? set = double.tryParse(setValue);
      double? low = double.tryParse(lowValue);

      // Logic for determining the border color based on the set value
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
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 4,
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.43,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                image,
                width: 40,
                height: 40,
                color: color,
              ),
              Column(
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
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDialog(
      BuildContext context, String title, PressureController controller) {
    final highValue = controller.containerValues[title]?['High'] ?? '';
    final lowValue = controller.containerValues[title]?['Low'] ?? '';
    final setValue = controller.containerValues[title]?['Set'] ?? '';

    final highController = TextEditingController(text: highValue);
    final lowController = TextEditingController(text: lowValue);
    final setController = TextEditingController(text: setValue);

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

                      controller.updateContainerValues(
                          title, newHighValue, newLowValue, newSetValue);
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
