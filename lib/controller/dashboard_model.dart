import 'package:get/get.dart';

//farig

class DashboardModel extends GetxController {
  RxBool isCompressorOn = false.obs;
  RxString chilledWaterInTemp = '25'.obs;
  RxString chilledWaterOutTemp = '25'.obs;
  RxString suctionTemp = '25'.obs;
  RxString suctionHighTemp = '30'.obs;
  RxString suctionLowTemp = '20'.obs;
  RxString dischargeTemp = '35'.obs;
  RxString dischargeHighTemp = '40'.obs;
  RxString dischargeLowTemp = '30'.obs;

  String mqttBroker = "192.168.18.112";
  String clientId = "flutter_mqtt_client2";
  int port = 1883;

  void toggleCompressor() {
    isCompressorOn.value = !isCompressorOn.value;
  }

  void updateChilledWaterOutTemp(String temp) {
    chilledWaterOutTemp.value = temp;
  }

  void updateSuctionTemp(String temp, String high, String low) {
    print("Model updating suction: Temp=$temp, High=$high, Low=$low");
    suctionTemp.value = temp;
    suctionHighTemp.value = high;
    suctionLowTemp.value = low;
  }

  void updateDischargeTemp(String high, String low) {
    print("Model updating discharge:  High=$high, Low=$low");
    dischargeHighTemp.value = high;
    dischargeLowTemp.value = low;
  }
}
