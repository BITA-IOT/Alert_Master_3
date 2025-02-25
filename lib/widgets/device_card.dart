import 'package:app/utilz/theme/theme.dart';
import 'package:flutter/material.dart';

class DeviceCard extends StatefulWidget {
  final String title;
  final String macAddress;
  final String deviceId;
  final String ipAddress;
  final void Function() onSetting;
  final void Function() onDelete;

  const DeviceCard({
    super.key,
    required this.title,
    required this.macAddress,
    required this.deviceId,
    required this.ipAddress,
    required this.onSetting,
    required this.onDelete,
  });

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool isSheetOpen = false;

  void _toggleSheet() {
    setState(() {
      isSheetOpen = !isSheetOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.green,
                    ),
                    child: IconButton(
                      icon: const Center(
                        child: Icon(
                          Icons.settings,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: widget.onSetting,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.green,
                    ),
                    child: IconButton(
                      icon: const Center(
                        child: Icon(
                          Icons.delete_forever,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: widget.onDelete,
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleSheet,
                    child: Icon(
                      isSheetOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isSheetOpen ? 120 : 0,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ThemeColor().dialogBox,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MAC: ${widget.macAddress}',
                    style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 5),
                Text('Device ID: ${widget.deviceId}',
                    style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 5),
                Text('IP Address: ${widget.ipAddress}',
                    style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
