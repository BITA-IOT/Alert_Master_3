import 'package:app/controller/pressure_controller.dart';
import 'package:app/widgets/Password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PressureScreen extends StatelessWidget {
  
  const PressureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PressureController controller = Get.put(PressureController());
    List<String> gasOptions = ['R22', 'R134', 'R410', 'R404', 'R407'];
    

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onLongPress: () {
          showPasswordDialog(
            context: context,
            password: '1234', // Replace with actual password
            gasOptions: gasOptions,
            onGasSelected: (selectedGas) {
              controller.publishSelectedGas(selectedGas);
              print('Selected gas: $selectedGas');
            },
            initialSelectedGas: controller.selectedGas.value, // Pass the current selected gas
          );
        },
        child: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Center(),
                  const SizedBox(height: 20),

                  // Title container
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(
                              "assets/images/pressure icon.png",
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Pressure',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Info cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard2(
                        context: context,
                        image: 'assets/images/pressure icon.png',
                        color: Colors.green,
                        title: 'Suction\nPressure',
                        controller: controller,
                      ),
                      _buildInfoCard(
                        context: context,
                        image: 'assets/images/pressure icon.png',
                        color: Colors.red,
                        title: 'discharge\nPressure',
                        controller: controller,
                      ),
                      
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Row with conditional card display based on GetX state
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Show first card if currentCardIndex is 1
                        if (controller.currentCardIndex.value == 1)
                          _buildInfoCard(
                            context: context,
                            image: 'assets/images/pressure icon.png',
                            color: Colors.orange,
                            title: 'Oil\nPressure',
                            controller: controller,
                          ),

                        // Show second card if currentCardIndex is 2
                        if (controller.currentCardIndex.value == 2)
                          _buildOilTemperatureCard(controller),
                      ],
                    );
                  }),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 30,
              left: 50,
              right: 50,
              child: Opacity(
                opacity: 0.0, // Makes the button fully transparent
                child: GestureDetector(
                  onDoubleTap: () {
                    controller.toggleCardVisibility();
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      // Action on normal press
                      print("Button pressed!");
                    },
                    onLongPress: () {
                      controller.toggleCardVisibility();
                      // Action on long press
                      print("Button long pressed!");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 36.0), // Adjust padding as necessary
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    child: Text(
                      "", // Empty text to ensure the button still exists
                    ),
                  ),
                ),
              ))
        ]),
      ),
    );
  }

  // Info Card Widget
Widget _buildInfoCard({
  required BuildContext context,
  required String image,
  required Color color,
  required String title,
  required PressureController controller,
}) {
  // Retrieve the set and high values from the controller (assume 'Set' and 'High' are the keys)
  final setValue = controller.containerValues[title]?['Set'] ?? '*';
  final highValue = controller.containerValues[title]?['High'] ?? '*';

  // Determine the border color based on the set value
  Color borderColor;
  double? set = double.tryParse(setValue);
  double? high = double.tryParse(highValue);

  if (set != null && high != null) {
    // Red border: Set value is greater than or equal to the high value
    if (set >= high) {
      borderColor = Colors.red;
    }
    // Orange border: Set value is within a certain range below the high value
    else if (set >= high - 10) {
      borderColor = Colors.orange;
    }
    // Green border: Set value is significantly lower than the high value
    else {
      borderColor = Colors.green;
    }
  } else {
    borderColor = Colors.grey; // Default color for invalid or missing set value
  }

  return GestureDetector(
    onTap: () {
      _showDialog(context, title, controller);
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor, // Set the border color based on the set value
          width: 4, // Border width
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 40,
            height: 40,
            color: color,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            '$setValue psi', // Display the set value
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

Widget _buildInfoCard2({
  required BuildContext context,
  required String image,
  required Color color,
  required String title,
  required PressureController controller,
}) {
  // Retrieve the set and low values from the controller (default to '40' and '20' if not available)
  final setValue = controller.containerValues[title]?['Set'] ?? '*';
  final lowValue = controller.containerValues[title]?['Low'] ?? '*';

  // Attempt to parse the set and low values as doubles
  Color borderColor;
  double? set = double.tryParse(setValue);
  double? low = double.tryParse(lowValue);

  // Logic for determining the border color based on the set value
  if (set != null && low != null) {
    // Red border: Set value is less than or equal to the low value (indicating a dangerously low value)
    if (set <= low) {
      borderColor = Colors.red;
    }
    // Orange border: Set value is within a moderate range above the low value (indicating a warning level)
    else if (set <= low + 10) {
      borderColor = Colors.orange;
    }
    // Green border: Set value is significantly higher than the low value (indicating a safe level)
    else {
      borderColor = Colors.green;
    }
  } else {
    // Default to grey border if the values are invalid or missing
    borderColor = Colors.grey;
  }

  return GestureDetector(
    onTap: () {
      _showDialog(context, title, controller);
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor, // Set the border color based on the set value
          width: 4, // Border width
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 40,
            height: 40,
            color: color,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            '$setValue psi', // Display the set value
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

  // Oil Temperature Card Widget with Switch
// Oil Temperature Card Widget with Status and Indicator
Widget _buildOilTemperatureCard(PressureController controller) {
  return 
  
  
  Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
    ),
    width: 150,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon for Oil Temperature
        Icon(
          Icons.thermostat_outlined,
          color: Colors.blue,
          size: 40,
        ),
        const SizedBox(height: 10),
        
        // Title for Oil Temperature
        const Text(
          'Oil\nTemperature',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        
        const SizedBox(height: 10),
        
        // Row for displaying the status
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Status: ',
              style: TextStyle(fontSize: 14),
            ),
            Obx(() {
              return Text(
                controller.isOilTemperatureOn.value ? 'ON' : 'OFF',
                style: TextStyle(
                  color: controller.isOilTemperatureOn.value
                      ? Colors.green
                      : Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ],
        ),
        
        const SizedBox(height: 10),
        
        // Row for displaying the switch indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return Switch(
                value: controller.isOilTemperatureOn.value,
                onChanged: (bool value) {
                  controller.isOilTemperatureOn(value);
                },
                activeColor: Colors.green,
                inactiveTrackColor: Colors.grey,
              );
            }),
          ],
        ),
      ],
    ),
  );


}





void _showDialog(
    BuildContext context, String title, PressureController controller) {
  // Initial values to display
  final highValue = controller.containerValues[title]?['High'] ?? '';
  final lowValue = controller.containerValues[title]?['Low'] ?? '';
  final setValue = controller.containerValues[title]?['Set'] ?? '';

  // Text controllers for editing
  final highController = TextEditingController(text: highValue);
  final lowController = TextEditingController(text: lowValue);
  final setController = TextEditingController(text: setValue);

  // State to manage edit mode
  bool isEditable = false;

  // Password input controller
  final passwordController = TextEditingController();

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
                        decoration: const InputDecoration(labelText: 'High Level'),
                        keyboardType: TextInputType.number,
                      )
                    : Text('High Level: $highValue'),
                isEditable
                    ? TextField(
                        controller: lowController,
                        decoration: const InputDecoration(labelText: 'Low Level'),
                        keyboardType: TextInputType.number,
                      )
                    : Text('Low Level: $lowValue'),
                isEditable
                    ? TextField(
                        controller: setController,
                        decoration: const InputDecoration(labelText: 'Set Level'),
                        keyboardType: TextInputType.number,
                      )
                    : Text('Set Level: $setValue'),
              ],
            ),
            actions: [
              // Edit button - check for password if not in edit mode
              if (!isEditable)
                TextButton(
                  onPressed: () {
                    // Show password dialog before allowing editing
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Enter Password to Edit'),
                          content: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Password'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Validate password
                                if (passwordController.text == '1234') {
                                  setState(() {
                                    isEditable = true; // Switch to edit mode
                                  });
                                  Navigator.pop(context); // Close the password dialog
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Incorrect password')),
                                  );
                                  Navigator.pop(context); // Close the password dialog
                                }
                              },
                              child: const Text('OK'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context), // Close password dialog
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Edit'),
                ),
              // Cancel button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              // Save button - only enabled if in editable mode
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
                        const SnackBar(content: Text('Please enter valid numbers')),
                      );
                      return;
                    }

                    controller.updateContainerValues(
                        title, newHighValue, newLowValue, newSetValue);
                    Navigator.pop(context); // Close the main dialog
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
