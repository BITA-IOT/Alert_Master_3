import 'dart:developer';
import 'package:app/views/button/button.dart';
import 'package:app/utilz/theme/theme.dart';
import 'package:app/model/user_device_model.dart';
import 'package:app/services/firebase_service.dart';
import 'package:app/views/home/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class QRCodeScanner extends StatefulWidget {
  QRCodeScanner();

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  bool isScanning = true;
  MobileScannerController cameraController = MobileScannerController();
  List<Map<String, String>> scannedConnections = [];
  int id = 0;
  bool isConnectedToDevice = false;
  bool isLoading = false;
  final apiUrl = Uri.parse('http://192.168.4.1/wifi_param_by_app');

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.location.request();
  }

  Future<void> sendWifiCredentials(
      String ssid, String password, String dssid, String dpassword) async {
    print("asdfghjkl 2063| response body");
    var response = await http.post(apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"ssid": ssid, "password": password}));
    print(
        "checkingissue 2063| response body= ${response.body} response code = ${response.statusCode}");
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Response: ${response.body}')),
      );
      log('dsfdfsdfdff 1');
      WiFiForIoTPlugin.forceWifiUsage(false);
      log('dsfdfsdfdff 2');

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        log('ESP32 successfully configured.');
        await _showdevicenameDialog(dssid, dpassword);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
        log('Error: ${response.body}');
      }
    } else {
      log('Failed with status code: ${response.statusCode} ISUEEEEEEEEEE______-');
    }
  }

  Future<void> diconnectwifi() async {
    final disconnectedd = await WiFiForIoTPlugin.disconnect();
    if (disconnectedd) {
      log("Disconnected");
    } else {
      log("Not Disconnected");
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty && isScanning) {
      final String? code = capture.barcodes.first.rawValue;
      if (code != null) {
        setState(() {
          isScanning = false;
          cameraController.stop();
        });

        _parseQRCode(code);
      }
    }
  }

  Future<void> _parseQRCode(String code) async {
    print("Scanned QR Code: $code");

    final wifiRegex = RegExp(
      r'WIFI:T:[^;]*;S:(?<ssid>[^;]*);P:(?<password>[^;]*);(?:H:(?:true|false|);)?',
      caseSensitive: false,
    );

    final wifiMatch = wifiRegex.firstMatch(code);

    if (wifiMatch != null) {
      final ssid = wifiMatch.namedGroup('ssid');
      final password = wifiMatch.namedGroup('password');

      if (ssid?.isNotEmpty == true && password?.isNotEmpty == true) {
        _connectToWiFi(ssid!, password!);
      } else {
        print("SSID or Password is null or empty.");
      }
    } else {
      print("No match for Wi-Fi QR code.");
    }
  }

  Future<void> _connectToWiFi(String ssid, String password) async {
    bool isConnected = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
      isHidden: true,
      joinOnce: true,
      withInternet: false,
    );

    if (isConnectedToDevice == false) {
      if (isConnected) {
        isConnectedToDevice = true;
        print("Connected to ${ssid}");

        await _showWiFiDialog(ssid, password);

        print("Connected to ${ssid}");
        await WiFiForIoTPlugin.forceWifiUsage(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('There was an error scanning the code please try again'),
            duration: Duration(seconds: 4),
          ),
        );
        print("Failed to connect to $ssid");
      }
    }
  }

  Future<void> _showWiFiDialog(String ssid, String password) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connect Damper to Wi-Fi'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelText: 'Connection Name',
                    labelStyle: TextStyle(color: ThemeColor().buttonColor),
                  ),
                  cursorColor: ThemeColor().buttonColor,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: ThemeColor().buttonColor),
                  ),
                  cursorColor: ThemeColor().buttonColor,
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Button(
                onTap: () {
                  final ssidd = nameController.text;
                  final pass = passwordController.text;

                  if (ssidd != "") {
                    sendWifiCredentials(
                        ssidd.toString(), pass.toString(), ssid, password);
                  }
                  Navigator.of(context).pop();
                },
                buttonText: 'Send')
          ],
        );
      },
    );
  }

  Future<void> _showdevicenameDialog(String ssid, String password) async {
    TextEditingController nameController = TextEditingController();
    bool isDialogLoading = false; // Local state for the dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Enter Your Device Name'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: 'Device Name',
                        labelStyle: TextStyle(color: ThemeColor().buttonColor),
                      ),
                      cursorColor: ThemeColor().buttonColor,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isDialogLoading = true; // Update the dialog's state
                    });

                    final ssidd = nameController.text;
                    final ip = "000.000.000.000";
                    final mac = "00:00:00:00:00:00";
                    String deviceid = ssid;

                    debugPrint(ip + " " + mac + " " + ssidd + " " + deviceid);

                    await SharedPreferencesService().sendDeviceData(
                      data: DeviceModel(
                        deviceId: deviceid,
                        deviceIp: ip,
                        deviceMac: mac,
                        deviceName: ssidd,
                      ),
                    );

                    final isDisconnect = await WiFiForIoTPlugin.disconnect();
                    log("${isDisconnect} Disconnected");

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('deviceId', deviceid);
                    log("${prefs.getString('deviceId')} Device Saved");

                    setState(() {
                      isDialogLoading = false; // Reset the dialog's state
                    });

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavBar(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor().buttonColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isDialogLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Send",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              height: Get.height * 0.8,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: ThemeColor().buttonColor, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: isScanning
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: MobileScanner(
                        controller: cameraController,
                        onDetect: _onDetect,
                      ),
                    )
                  : const Center(
                      child: Text(
                      'Scanning stopped',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
