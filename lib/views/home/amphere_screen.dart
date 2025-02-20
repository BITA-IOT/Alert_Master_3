import 'package:app/controller/amphere_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';

class AmpereScreen extends StatelessWidget {
  const AmpereScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AmpereController controller = Get.put(AmpereController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.electric_bolt_sharp,
                        size: 30,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Ampere',
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
                  _buildInfoCard(
                    context: context,
                    icon: Icons.electric_bolt_sharp,
                    color: Colors.blue,
                    title: 'Phase 1',
                    controller: controller,
                  ),
                  _buildInfoCard(
                    context: context,
                    icon: Icons.electric_bolt_sharp,
                    color: Colors.orange,
                    title: 'Phase 2',
                    controller: controller,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard(
                    context: context,
                    icon: Icons.electric_bolt_sharp,
                    color: Colors.green,
                    title: 'Phase 3',
                    controller: controller,
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required AmpereController controller,
  }) {
    final high = controller.mqttModel.containerValues[title]?['High'] ?? 'N/A';
    final low = controller.mqttModel.containerValues[title]?['Low'] ?? 'N/A';
    final set = controller.mqttModel.containerValues[title]?['Set'] ?? 'N/A';

    return GestureDetector(
      onTap: () {
        _showDialog(context, title, controller);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
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
              'High: $high\nLow: $low\nSet: $set',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(
      BuildContext context, String title, AmpereController controller) {
    final TextEditingController highController = TextEditingController(
        text: controller.mqttModel.containerValues[title]?['High']);
    final TextEditingController lowController = TextEditingController(
        text: controller.mqttModel.containerValues[title]?['Low']);
    final TextEditingController setController = TextEditingController(
        text: controller.mqttModel.containerValues[title]?['Set']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Levels for $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: highController,
                decoration: const InputDecoration(labelText: 'High Level'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lowController,
                decoration: const InputDecoration(labelText: 'Low Level'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: setController,
                decoration: const InputDecoration(labelText: 'Set Level'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.updateContainerValues(
                  title,
                  highController.text,
                  lowController.text,
                  setController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
