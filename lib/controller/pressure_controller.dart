import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class PressureController extends GetxController {
  String mqttBroker = "test.mosquitto.org";
  String clientId = "flutter_mqtt_client2";
  int port = 1883;
  String publishStatus = "";
  var selectedGas = ''.obs;

  final RxMap<String, Map<String, String>> _containerValues = {
    'Discharge': {'High': '25', 'Low': '15', 'set': '63'},
    'Oil': {'High': '26', 'Low': '16', 'set': '63'},
    'Suction temp': {'High': '27', 'Low': '17', 'set': '63'},
  }.obs;

  MqttServerClient? client;

  // Getters
  Map<String, Map<String, String>> get containerValues => _containerValues;

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

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  void _onConnected() {
    print('Connected to MQTT broker.');
  }

  void publishMessage(String message) {
    const String topic = "/KRC_AM/1";
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
        publishStatus =
            'Message "$message" published successfully to topic "$topic" with retain flag.';
        update(); // Trigger update in UI
      } catch (e) {
        publishStatus = 'Failed to publish message: $e';
        update(); // Trigger update in UI
      }
    }
  }

  // Update container values
  void updateContainerValues(String title, String high, String low, String set) {
    _containerValues[title] = {'High': high, 'Low': low, 'Set': set};
    update(); // Trigger update in UI
    _publishJsonMessage(); // Call _publishJsonMessage to publish the updated container values
  }

  // This is the function that publishes container values as a JSON message
  void _publishJsonMessage() {
    final String jsonPayload = _containerValues.toString(); // Convert the map to a string or JSON
    publishMessage(jsonPayload); // Publish the message
  }

  void publishSelectedGas(String gas) {
    selectedGas.value = gas;
    publishMessage("Selected Gas: $gas");
    print('Selected gas: $gas published');
    update();
  }

  void updateSelectedGas(String gas) {
    selectedGas.value = gas; // Update the selected gas
    publishSelectedGas(gas); // Publish the selected gas
  }

  var currentCardIndex = 0.obs; // Observable variable for card visibility
  var isOilTemperatureOn = false.obs;

  void toggleCardVisibility() {
    currentCardIndex.value = (currentCardIndex.value + 1) % 3; // Cycle through 0, 1, 2
  }
}
