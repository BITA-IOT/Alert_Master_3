import 'package:app/controller/mqtt_controller.dart';
import 'package:app/controller/dashboard_model.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';

class DashboardController extends GetxController {
  final DashboardModel model = DashboardModel();

  MqttServerClient? client;
  var isConnected = true.obs;
  @override
  void onInit() {
    super.onInit();
    _setupMqttClient();
    _connectMqtt();
  }

  void _setupMqttClient() {
    client = MqttServerClient(model.mqttBroker, model.clientId);
    client?.port = model.port;
    client?.logging(on: true);
    client?.onDisconnected = _onDisconnected;
    client?.onConnected = _onConnected;
  }

  void _connectMqtt() async {
    try {
      await client?.connect();

      print('Connected');
    } catch (e) {
      print('Exception: $e');
      client?.disconnect();
    }
  }

  void _onDisconnected() {
    print('Disconnected from MQTT broker.');
  }

  void _onConnected() {
    isConnected.value = false;

    print('Connected to MQTT broker.');
  }

  void publishMessage(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage(
      '/KRC/am3/1',
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: true,
    );
  }

  void updateDashboard() {
    // Prepare a single JSON object with all the relevant data
    final Map<String, dynamic> dashboardData = {
      "compressorStatus": model.isCompressorOn.value ? "ON" : "OFF",
      "chilledWaterInTemp": model.chilledWaterInTemp.value,
      "chilledWaterOutTemp": model.chilledWaterOutTemp.value,
      "suctionTemp": model.suctionTemp.value,
      "suctionHighTemp": model.suctionHighTemp.value,
      "suctionLowTemp": model.suctionLowTemp.value,
      "dischargeTemp": model.dischargeTemp.value,
      "dischargeHighTemp": model.dischargeHighTemp.value,
      "dischargeLowTemp": model.dischargeLowTemp.value,
    };

    // Convert the Map to a JSON string
    final String jsonPayload = jsonEncode(dashboardData);

    // Publish the message
    publishMessage(jsonPayload);
    print('Dashboard Data Published: $jsonPayload');
  }

  void toggleCompressor() {
    model.toggleCompressor();
    updateDashboard(); // Publish all data including the compressor status
  }

  void updateChilledWaterOutTemp(String temp) {
    model.updateChilledWaterOutTemp(temp);
    updateDashboard(); // Publish all data including the chilled water out temperature
  }

  void updateSuctionTemps(String temp, String highTemp, String lowTemp) {
    print("Updating suction temps: Temp=$temp, High=$highTemp, Low=$lowTemp");
    model.suctionTemp.value = temp;
    model.suctionHighTemp.value = highTemp;
    model.suctionLowTemp.value = lowTemp;
    updateDashboard(); // Publish all data including the suction temps
  }

  void updateDischargeTemp(String temp, String high, String low) {
    print("Updating discharge temps: Temp=$temp, High=$high, Low=$low");
    model.updateDischargeTemp(temp, high, low);
    updateDashboard(); // Publish all data including the discharge temps
  }
}
