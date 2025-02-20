import 'package:app/controller/pressure_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const InfoCard({
    Key? key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 4),

        ),
        width: Get.width * 0.43,
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class InfoCard2 extends StatelessWidget {
  final String image;
  final Color color;
  final String title;
  final PressureController controller;

  InfoCard2({
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
                    style: const TextStyle(fontSize: 18,  fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDialog(BuildContext context, String title, PressureController controller) {
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


class InfoCard3 extends StatefulWidget {
  final BuildContext context;
  final String image;
  final Color color;
  final String title;
  final PressureController controller;

  InfoCard3({
    Key? key,
    required this.context,
    required this.image,
    required this.color,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  State<InfoCard3> createState() => _InfoCard3State();
}

class _InfoCard3State extends State<InfoCard3> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Retrieve values from the controller
     final setValue = widget.controller.containerValues[widget.title]?['Set'] ?? '*';
  final highValue =  widget.controller.containerValues[widget.title]?['High'] ?? '*';

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
          _showDialog(context, widget.title, widget.controller);
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
                    widget.image,
                    width: 40,
                    height: 40,
                    color: widget.color,
                  ),
              
              Column(
                children: [
                 
                 
                  Text(
                    widget.title,
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
                    style: const TextStyle(fontSize: 18,  fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  // Dialog to display and edit values
  void _showDialog(
      BuildContext context, String title, PressureController controller) {
    // Retrieve initial values
    final highValue = controller.containerValues[title]?['High'] ?? '';
    final lowValue = controller.containerValues[title]?['Low'] ?? '';
    final setValue = controller.containerValues[title]?['Set'] ?? '';

    // Text controllers for editing
    final highController = TextEditingController(text: highValue);
    final lowController = TextEditingController(text: lowValue);
    final setController = TextEditingController(text: setValue);

    // Track edit mode state
    bool isEditable = false;

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
                      setState(() {
                        isEditable = true;
                      });
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
