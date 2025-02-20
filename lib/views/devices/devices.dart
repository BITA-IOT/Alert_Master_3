import 'package:app/model/user_device_model.dart';
import 'package:app/services/firebase_service.dart';
import 'package:app/views/devices/qr_scan.dart';
import 'package:app/widgets/device_card.dart';
import 'package:flutter/material.dart';


class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<DeviceModel> allDeviceData = [];

  void getTaskListner() {
    SharedPreferencesService().listenToUserDevices().listen((allTask) {
      debugPrint('Received Data: $allTask');
      setState(() {
        allDeviceData = allTask;
      });
    }, onError: (error) {
      debugPrint('Error in Listener: $error');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskListner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Devices list"),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QRCodeScanner()));
                },
                icon: Icon(
                  Icons.add,
                  size: 30,
                ))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: allDeviceData.length,
          itemBuilder: (context, index) {
            return DeviceCard(
                title: '${allDeviceData[index].deviceName}',
                macAddress: '${allDeviceData[index].deviceMac}',
                deviceId: '${allDeviceData[index].deviceId}',
                ipAddress: '${allDeviceData[index].deviceIp}',
                onSetting: () {},
                onDelete: () {
                  SharedPreferencesService().deleteDeviceData(
                      deviceId: allDeviceData[index].deviceId ?? "");
                });
          },
        ),
      ),
    );
  }
}