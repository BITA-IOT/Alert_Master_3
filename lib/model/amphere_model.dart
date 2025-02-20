import 'dart:convert';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttModel extends GetxController {
  MqttServerClient? client;
  String mqttBroker = "192.168.18.112";
  String clientId = "flutter_mqtt_client2";
  int port = 1883;

  // Map to store high and low values for each title
  var containerValues = <String, Map<String, String>>{
    'Face 1': {'High': '25', 'Low': '15', 'Set': '63'},
    'Face 2': {'High': '26', 'Low': '16', 'Set': '63'},
    'Face 3': {'High': '27', 'Low': '17', 'Set': '63'},
  }.obs;

  @override
  void onInit() {
    super.onInit();
    _setupMqttClient();
    _connectMqtt();
  }

  void _setupMqttClient() {
    client = MqttServerClient(mqttBroker, clientId);
    client?.port = port;
    client?.logging(on: true);
    client?.onDisconnected = _onDisconnected;
    client?.onConnected = _onConnected;
    client?.onSubscribed = _onSubscribed;
  }

  Future<void> _connectMqtt() async {
    try {
      await client?.connect();
      print('Connected');
    } catch (e) {
      print('Exception: $e');
      client?.disconnect();
    }
  }

  void _onConnected() {
    print('Connected to MQTT broker.');
  }

  void _onDisconnected() {
    print('Disconnected from MQTT broker.');
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void publishMessage(String message) {
    const String topic = "/KRC_AM/3";
    if (client != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      try {
        client!.publishMessage(
          topic,
          MqttQos.atLeastOnce,
          builder.payload!,
          retain: true,
        );
      } catch (e) {
        print('Failed to publish message: $e');
      }
    }
  }

  String publishJsonMessage() {
    final String jsonPayload = jsonEncode(containerValues);
    publishMessage(jsonPayload);
    return jsonPayload;
  }
}
