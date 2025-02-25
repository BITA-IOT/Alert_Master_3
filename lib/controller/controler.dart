import 'package:app/services/sharedpreference_service.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  RxDouble dashboardOpacity = 0.5.obs;
  RxDouble deviceOpacity = 0.5.obs;

  @override
  void onInit() {
    super.onInit();
    // loadOpacity();
    loadOpacity();
  }

  Future<void> loadOpacity() async {
    dashboardOpacity.value =
        await Sharedpreference14().loadOpacity('dashboard');
    deviceOpacity.value = await Sharedpreference14().loadOpacity('device');

    // log(dashboardOpacity.toString());
    // log(deviceOpacity.toString());
    dashboardOpacity.refresh();

    deviceOpacity.refresh();
  }
}
