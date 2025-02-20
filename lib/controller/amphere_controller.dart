import 'package:app/model/amphere_model.dart';
import 'package:get/get.dart';

class AmpereController extends GetxController {
  final MqttModel mqttModel = Get.put(MqttModel());

  var publishStatus = ''.obs;

  // Update values in container map
  void updateContainerValues(
      String title, String high, String low, String set) {
    mqttModel.containerValues[title] = {'High': high, 'Low': low, 'Set': set};
    mqttModel.publishJsonMessage();
  }
}
