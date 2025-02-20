import 'package:app/controller/pressure_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void showPasswordDialog({
  required BuildContext context,
  required String password,
  required List<String> gasOptions,
  required Function(String selectedGas)
      onGasSelected, // Callback to publish to broker
  required String
      initialSelectedGas, // Add this parameter to remember the previously selected gas
}) {
  TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Enter Password'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: "Password"),
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
              if (passwordController.text == password) {
                Navigator.of(context).pop();
                _showGasSelectionDialog(
                  context,
                  gasOptions,
                  onGasSelected,
                  initialSelectedGas, // Pass the previously selected gas to the dialog
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid password')),
                );
              }
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void _showGasSelectionDialog(BuildContext context, List<String> gasOptions,
    Function(String) onGasSelected, String initialSelectedGas) {
  // Add parameter for previously selected gas

  final controller = Get.put(PressureController());
  controller.selectedGas.value =
      initialSelectedGas; // Set the initial selected gas

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Widget buildGasOption(String gas) {
            bool isSelected = controller.selectedGas.value == gas;

            return TextButton.icon(
              onPressed: () {
                controller.updateSelectedGas(gas);
                onGasSelected(gas);
                setState(() {});
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                });

                print('$gas selected and published');
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                backgroundColor: isSelected
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                isSelected ? Icons.check_circle : Icons.check_box_outline_blank,
                color: isSelected ? Colors.blue : Colors.black,
              ),
              label: Text(
                gas,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.green : Colors.red,
                ),
              ),
            );
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              "Gases Selection",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: gasOptions.map((gas) => buildGasOption(gas)).toList(),
              ),
            ),
          );
        },
      );
    },
  );
}
