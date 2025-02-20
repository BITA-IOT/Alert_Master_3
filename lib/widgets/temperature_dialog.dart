import 'dart:convert';

import 'package:app/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void showTemperatureDialog(
  BuildContext context, {
  required String title,
  required String currentTemp,
  required Function(String) onUpdate,
}) {
  final tempController = TextEditingController(text: currentTemp);

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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void _showSuctionDischargeTempDialog(
  BuildContext context,
  String title,
  String currentTemp,
  String currentHighTemp,
  String currentLowTemp,
  Function(String, String, String) onUpdate,
) {
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
            TextField(
              controller: tempController,
              decoration: const InputDecoration(
                labelText: 'Temperature',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: highTempController,
              decoration: const InputDecoration(
                labelText: 'High Temperature',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
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
          TextButton(
            onPressed: () {
              onUpdate(
                tempController.text,
                highTempController.text,
                lowTempController.text,
              );

              final jsonPayload = jsonEncode({
                "Temperature": tempController.text,
                "High": highTempController.text,
                "Low": lowTempController.text,
              });

              // Call the publishMessage method from the controller
              Get.find<DashboardController>().publishMessage(jsonPayload);

              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close without updating
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}



void showSuctionDischargeTempDialog({
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
            TextField(
              controller: tempController,
              decoration: const InputDecoration(
                labelText: 'Temperature',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: highTempController,
              decoration: const InputDecoration(
                labelText: 'High Temperature',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
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
          TextButton(
            onPressed: () {
              onUpdate(
                tempController.text,
                highTempController.text,
                lowTempController.text,
              );

              final jsonPayload = jsonEncode({
                "Temperature": tempController.text,
                "High": highTempController.text,
                "Low": lowTempController.text,
              });

              // Call the publishMessage method from the controller
              Get.find<DashboardController>().publishMessage(jsonPayload);

              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close without updating
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}




