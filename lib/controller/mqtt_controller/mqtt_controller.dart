import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

//new controller

class MqttController extends GetxController {
  String topicSSIDvalue = "";
  var amp1 = 18.obs;
  var amp2 = 18.obs;
  var amp3 = 18.obs;
  var temp1 = 18.obs;
  var temp2 = 18.obs;
  var temp3 = 18.obs;
  var temp4 = 18.obs;
  var psig1 = 18.25.obs;
  var psig2 = 18.24.obs;
  var psig3 = 18.18.obs;
  var temp1setlow = 18.obs;
  var temp2setlow = 18.obs;
  var temp3setlow = 18.obs;
  var temp4setlow = 18.obs;
  var psig1setlow = 18.obs;
  var psig2setlow = 18.obs;
  var psig3setlow = 18.obs;

  var temp1sethigh = 18.obs;
  var temp2sethigh = 18.obs;
  var temp3sethigh = 18.obs;
  var temp4sethigh = 18.obs;
  var psig1sethigh = 18.obs;
  var psig2sethigh = 18.obs;
  var psig3sethigh = 18.obs;

  var amp1high = 18.obs;
  var amp2high = 18.obs;
  var amp3high = 18.obs;
  var amp1low = 18.obs;
  var amp2low = 18.obs;
  var amp3low = 18.obs;
  var comp1status = 1.obs;

  var mqttBroker = "192.168.18.112".obs;
  var clientId = "flutter45".obs;
  var port = 1883.obs;
  var receivedMessage = "".obs;

  var isConnected = false.obs;
  var message = "".obs;

  var correctPassword = "1234567".obs;
  var isPasswordCorrect = false.obs;
  var currentCardIndex = 0.obs;
  var isOilTemperatureOn = false.obs;
  MqttServerClient? client;

  @override
  void onInit() {
    log("MQTT controller onit");
    super.onInit();
    _setupMqttClient();
    _connectMqtt();
  }

  updatetopicSSIDvalue(value) {
    print("log 3232:${value} ");
    topicSSIDvalue = value;
    update();
  }

  void _setupMqttClient() {
    client = MqttServerClient(mqttBroker.value, clientId.value);
    client?.port = port.value;
    client?.logging(on: true);
    client?.onDisconnected = _onDisconnected;
    client?.onConnected = _onConnected;
    client?.onSubscribed = _onSubscribed;
  }

  void _onDisconnected() {
    log('Disconnected from MQTT broker.');
    isConnected.value = false;
  }

  void _onConnected() {
    log('Connected to Onconnect.');
    isConnected.value = true;

    client?.subscribe('/KRC/AM3-AAA001', MqttQos.atLeastOnce);
    client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? messages) {
      final MqttPublishMessage msg = messages![0].payload as MqttPublishMessage;

      log('subscribe.');
      log('subscribe_____/KRC/$topicSSIDvalue');
      final String topic = messages[0].topic;
      final String message =
          MqttPublishPayload.bytesToStringAsString(msg.payload.message);
      log(topic);
      log("message1");
      receivedMessage.value = message;

      if (topic == "/KRC/AM3-AAA001") {
        print('Message Received on /KRC/$topicSSIDvalue: $message');
        _handleMessage(message);
      }
    });
  }

  Future<void> _connectMqtt() async {
    while (true) {
      try {
        log('Attempting to connect...');
        await client?.connect();
        if (client?.connectionStatus?.state == MqttConnectionState.connected) {
          log('Connected to MQTT broker.');
          isConnected.value = true;
          break;
        } else {
          log('Connection failed: ${client?.connectionStatus?.state}');
        }
      } catch (e) {
        log('Exception while connecting: $e');
      }
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void _handleMessage(String message) async {
    try {
      Map<String, dynamic> jsonMap = jsonDecode(message);

      amp1.value = int.tryParse(jsonMap['value0']?.toString() ?? '') ?? 0;
      amp2.value = int.tryParse(jsonMap['value8']?.toString() ?? '') ?? 0;
      amp3.value = int.tryParse(jsonMap['value9']?.toString() ?? '') ?? 0;
      temp1.value = int.tryParse(jsonMap['value1']?.toString() ?? '') ?? 0;
      temp2.value = int.tryParse(jsonMap['value2']?.toString() ?? '') ?? 0;
      temp3.value = int.tryParse(jsonMap['value3']?.toString() ?? '') ?? 0;
      temp4.value = int.tryParse(jsonMap['value4']?.toString() ?? '') ?? 0;

      // Handle decimal values as double
      psig1.value = double.tryParse(jsonMap['value5']?.toString() ?? '') ?? 0.0;
      psig2.value = double.tryParse(jsonMap['value6']?.toString() ?? '') ?? 0.0;
      psig3.value = double.tryParse(jsonMap['value7']?.toString() ?? '') ?? 0.0;

      temp1setlow.value =
          int.tryParse(jsonMap['value10']?.toString() ?? '') ?? 0;
      temp2setlow.value =
          int.tryParse(jsonMap['value11']?.toString() ?? '') ?? 0;
      temp3setlow.value =
          int.tryParse(jsonMap['value12']?.toString() ?? '') ?? 0;
      temp4setlow.value =
          int.tryParse(jsonMap['value13']?.toString() ?? '') ?? 0;

      psig1setlow.value =
          int.tryParse(jsonMap['value14']?.toString() ?? '') ?? 0;
      psig2setlow.value =
          int.tryParse(jsonMap['value15']?.toString() ?? '') ?? 0;
      psig3setlow.value =
          int.tryParse(jsonMap['value16']?.toString() ?? '') ?? 0;

      temp1sethigh.value =
          int.tryParse(jsonMap['value21']?.toString() ?? '') ?? 0;
      temp2sethigh.value =
          int.tryParse(jsonMap['value22']?.toString() ?? '') ?? 0;
      temp3sethigh.value =
          int.tryParse(jsonMap['value23']?.toString() ?? '') ?? 0;
      temp4sethigh.value =
          int.tryParse(jsonMap['value24']?.toString() ?? '') ?? 0;

      psig1sethigh.value =
          int.tryParse(jsonMap['value25']?.toString() ?? '') ?? 0;
      psig2sethigh.value =
          int.tryParse(jsonMap['value26']?.toString() ?? '') ?? 0;
      psig3sethigh.value =
          int.tryParse(jsonMap['value27']?.toString() ?? '') ?? 0;

      amp1high.value = int.tryParse(jsonMap['value28']?.toString() ?? '') ?? 0;
      amp2high.value = int.tryParse(jsonMap['value29']?.toString() ?? '') ?? 0;
      amp3high.value = int.tryParse(jsonMap['value20']?.toString() ?? '') ?? 0;
      amp1low.value = int.tryParse(jsonMap['value17']?.toString() ?? '') ?? 0;
      amp2low.value = int.tryParse(jsonMap['value18']?.toString() ?? '') ?? 0;
      amp3low.value = int.tryParse(jsonMap['value19']?.toString() ?? '') ?? 0;
      comp1status.value =
          int.tryParse(jsonMap['value30']?.toString() ?? '') ?? 0;

      log("Received MQTT Data:");
      log("amp1 = $amp1");
      log("amp2 = $amp2");
      log("amp3 = $amp3");
      log("temp1 = $temp1");
      log("temp2 = $temp2");
      log("temp3 = $temp3");
      log("temp4 = $temp4");
      log("psig1 = $psig1");
      log("psig2 = $psig2");
      log("psig3 = $psig3");
      log("temp1setlow = $temp1setlow");
      log("temp2setlow = $temp2setlow");
      log("temp3setlow = $temp3setlow");
      log("temp4setlow = $temp4setlow");
      log("psig1setlow = $psig1setlow");
      log("psig2setlow = $psig2setlow");
      log("psig3setlow = $psig3setlow");
      log("temp1sethigh = $temp1sethigh");
      log("temp2sethigh = $temp2sethigh");
      log("temp3sethigh = $temp3sethigh");
      log("temp4sethigh = $temp4sethigh");
      log("psig1sethigh = $psig1sethigh");
      log("psig2sethigh = $psig2sethigh");
      log("psig3sethigh = $psig3sethigh");
      log("amp1high = $amp1high");
      log("amp2high = $amp2high");
      log("amp3high = $amp3high");
      log("amp1low = $amp1low");
      log("amp2low = $amp2low");
      log("amp3low = $amp3low");
      log("comp1status = $comp1status");
    } catch (e) {
      log("Error parsing JSON: $e");
    }
  }

  void _buildJsonPayload() {
    Map<String, dynamic> jsonPayload = {
      "amp1": amp1.value.toString(),
      "amp2": amp2.value.toString(),
      "amp3": amp3.value.toString(),
      "temp1": temp1.value.toString(),
      "temp2": temp2.value.toString(),
      "temp3": temp3.value.toString(),
      "temp4": temp4.value.toString(),
      "psig1": psig1.value.toString(),
      "psig2": psig2.value.toString(),
      "psig3": psig3.value.toString(),
      "temp1set_LOW": temp1setlow.value.toString(),
      "temp2set_LOW": temp2setlow.value.toString(),
      "temp3set_LOW": temp3setlow.value.toString(),
      "temp4set_LOW": temp4setlow.value.toString(),
      "psig1set_LOW": psig1setlow.value.toString(),
      "psig2set_LOW": psig2setlow.value.toString(),
      "psig3set_LOW": psig3setlow.value.toString(),
      "temp1set_HIGH": temp1sethigh.value.toString(),
      "temp2set_HIGH": temp2sethigh.value.toString(),
      "temp3set_HIGH": temp3sethigh.value.toString(),
      "temp4set_HIGH": temp4sethigh.value.toString(),
      "psig1set_HIGH": psig1sethigh.value.toString(),
      "psig2set_HIGH": psig2sethigh.value.toString(),
      "psig3set_HIGH": psig3sethigh.value.toString(),
      "amp1set_HIGH": amp1high.value.toString(),
      "amp2set_HIGH": amp2high.value.toString(),
      "amp3set_HIGH": amp3high.value.toString(),
      "amp1set_LOW": amp1low.value.toString(),
      "amp2set_LOW": amp2low.value.toString(),
      "amp3set_LOW": amp3low.value.toString(),
      "comp1status": comp1status.value.toString(),
    };

    String jsonString = jsonEncode(jsonPayload);
    publishMessage(jsonString);
  }

  void toggleCardVisibility() {
    currentCardIndex.value =
        (currentCardIndex.value + 1) % 3; // Cycle through 0, 1, 2
  }

  void updateChilledWaterInTemp(String temp) {
    temp1.value = int.parse(temp);
    _buildJsonPayload();
  }

  void updateChilledWateroutTemp(String temp) {
    temp2.value = int.parse(temp);
    _buildJsonPayload();
  }

  void compStatus(String status) {
    comp1status.value = int.parse(status);
    _buildJsonPayload();
  }

  void updateSuction(String low, String high) {
    temp3setlow.value = int.parse(low);
    temp3sethigh.value = int.parse(high);
    _buildJsonPayload();
  }

  void updateDischargeTemp(String high, String low) {
    temp4setlow.value = int.parse(high);
    temp4sethigh.value = int.parse(low);
    _buildJsonPayload();
  }

  void updateContainerValuesLP(String low, String high) {
    psig1sethigh.value = int.parse(low);
    psig1setlow.value = int.parse(high);
    _buildJsonPayload();
  }

  void updateOilPressure(String low, String high) {
    psig3sethigh.value = int.parse(low);
    psig3setlow.value = int.parse(high);
    _buildJsonPayload();
  }

  void updateContainerValuesHP(String high, String low) {
    psig2sethigh.value = int.parse(low);
    psig2setlow.value = int.parse(high);
    _buildJsonPayload();
  }

  void updateContainerValuesAmpereph1(String high, String low) {
    log(high.toString());
    amp1low.value = int.parse(high);
    amp1high.value = int.parse(low);
    _buildJsonPayload();
  }

  void updateContainerValuesAmpereph2(String high, String low) {
    amp2low.value = int.parse(high);
    amp2high.value = int.parse(low);
    _buildJsonPayload();
  }

  void updateContainerValuesAmpereph3(String high, String low) {
    amp3low.value = int.parse(high);
    amp3high.value = int.parse(low);
    _buildJsonPayload();
  }

  void publishMessage(String message) {
    String topic = "/test/AM3-AAA001/1";
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
        log('Message published to $topic: $message');
      } catch (e) {
        log('Failed to publish message: $e');
      }
    }
  }

  Future<void> showPasswordDialog(BuildContext context) async {
    TextEditingController passwordController = TextEditingController();

    await Get.dialog(
      AlertDialog(
        title: Text("Enter Password"),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: "Enter password"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (passwordController.text == correctPassword.value) {
                isPasswordCorrect.value = true;

                Get.back();
              } else {
                Get.snackbar("Error", "Incorrect Password");
              }
            },
            child: Text("Submit"),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
