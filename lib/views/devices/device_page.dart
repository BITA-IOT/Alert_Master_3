import 'dart:developer';
import 'package:app/utilz/theme/theme.dart';
import 'package:app/controller/controler.dart';
import 'package:app/controller/mqtt_controller/mqtt_controller.dart';
import 'package:app/model/user_device_model.dart';
import 'package:app/services/firebase_service.dart';
import 'package:app/views/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttServerClient? client;

// ignore: must_be_immutable
class DevicesPage extends StatefulWidget {
  DevicesPage({super.key});

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  List<DeviceModel> allDeviceData = [];
  final Controller controller = Get.put(Controller());
  MqttController _mqttcontroller = Get.put(MqttController());
  @override
  void initState() {
    super.initState();
    getTaskListner();
    _mqttcontroller.onInit();
    log("call");
  }

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
  Widget build(BuildContext context) {
    // final MqttController _controller = Get.put(MqttController());
    // _controller.onInit();
    return RefreshIndicator(
      onRefresh: () async {
        _mqttcontroller.onInit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Devices"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
        ),
        body: allDeviceData.isEmpty
            ? Center(
                child: Text('No Devices Found'),
              )
            : GridView.builder(
                itemCount: allDeviceData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final device = allDeviceData[index];

                  return Obx(
                    () => Card(
                      color: ThemeColor().snackBarColor.withOpacity(
                          controller.deviceOpacity.value < 0.2
                              ? 0.2
                              : controller.deviceOpacity.value),
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()));
                          _mqttcontroller.updatetopicSSIDvalue(device.deviceId);
                        },
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Delete Device"),
                                    content: Text(
                                        "Are you sure you want to delete this device? "),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel")),
                                      TextButton(
                                          onPressed: () async {
                                            SharedPreferencesService()
                                                .deleteDeviceData(
                                                    deviceId:
                                                        device.deviceId ?? "");
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Delete"))
                                    ],
                                  ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                device.deviceName ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.asset(
                                  "assets/images/device.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 10),
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: _mqttcontroller.isConnected == true
                                    ? Colors.green
                                    : _mqttcontroller.isConnected == false
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${device.deviceId}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
