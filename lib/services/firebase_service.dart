import 'dart:convert';

import 'package:app/model/user_device_model.dart';
import 'package:app/utilz/App_dialog.dart';
import 'package:app/views/home/bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String deviceIdMobile = '';

  void register(BuildContext context, String email, String password,
      String confirmPassword) async {
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      AppDialogs()
          .showErrorDialog(context, 'Please enter a valid email address.');
      return;
    } else if (password.isEmpty || password.length < 6) {
      AppDialogs().showErrorDialog(
          context, 'Password must be at least 6 characters long.');
      return;
    } else if (password != confirmPassword) {
      AppDialogs().showErrorDialog(context, 'Passwords do not match.');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore
          .collection('users')
          .doc(userCredential.user?.uid ?? "")
          .set({
        'email': email,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green.shade200,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'The email address is already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      }

      AppDialogs().showErrorDialog(context, errorMessage);
    }
  }

  void login(BuildContext context, String email, String password) async {
    // Email validation regex
    final emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );

    // Validate email and password
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address!'),
          backgroundColor: Colors.green.shade200,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 6 characters long!'),
          backgroundColor: Colors.green.shade200,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.offAll(() => NavBar());
    } on FirebaseAuthException catch (e) {
      // Handle errors
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = e.message ?? 'An unknown error occurred';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
          ),
          backgroundColor: Colors.green.shade200,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class SharedPreferencesService {
  final String _devicesKey = 'user_devices';

  /// Listen to User Devices (simulating a stream using SharedPreferences)
  Stream<List<DeviceModel>> listenToUserDevices() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    while (true) {
      final devicesData = prefs.getStringList(_devicesKey) ?? [];
      final devices = devicesData
          .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
          .toList();
      yield devices;
      await Future.delayed(const Duration(seconds: 1)); // Simulated polling
    }
  }

  /// Save a device (add or update)
  Future<void> sendDeviceData({required DeviceModel data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final devicesData = prefs.getStringList(_devicesKey) ?? [];

    // Parse existing devices
    final devices = devicesData
        .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
        .toList();

    // Update or add device
    final index = devices.indexWhere((d) => d.deviceId == data.deviceId);
    if (index != -1) {
      devices[index] = data.copyWith(
          lastUpdated: Timestamp.now().toDate()); // Update existing device
    } else {
      devices.add(data.copyWith(
          lastUpdated: Timestamp.now().toDate())); // Add new device
    }

    // Save back to SharedPreferences
    final updatedDevicesData =
        devices.map((device) => jsonEncode(device.toJson())).toList();
    await prefs.setStringList(_devicesKey, updatedDevicesData);
  }

  /// Update specific fields of a device
  Future<void> updateDeviceData({
    required String deviceId,
    String? updatedIp,
    String? updatedMac,
    String? updatedName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final devicesData = prefs.getStringList(_devicesKey) ?? [];

    // Parse existing devices
    final devices = devicesData
        .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
        .toList();

    // Update the specified device
    final index = devices.indexWhere((d) => d.deviceId == deviceId);
    if (index != -1) {
      final updatedDevice = devices[index].copyWith(
        deviceIp: updatedIp,
        deviceMac: updatedMac,
        deviceName: updatedName,
        lastUpdated: Timestamp.now().toDate(),
      );
      devices[index] = updatedDevice;

      // Save updated list back to SharedPreferences
      final updatedDevicesData =
          devices.map((device) => jsonEncode(device.toJson())).toList();
      await prefs.setStringList(_devicesKey, updatedDevicesData);
    }
  }

  /// Delete a device
  Future<void> deleteDeviceData({required String deviceId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final devicesData = prefs.getStringList(_devicesKey) ?? [];

    // Parse and filter out the device
    final updatedDevicesData = devicesData
        .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
        .where((device) => device.deviceId != deviceId)
        .map((device) => jsonEncode(device.toJson()))
        .toList();

    // Save updated list back to SharedPreferences
    await prefs.setStringList(_devicesKey, updatedDevicesData);
  }
}
