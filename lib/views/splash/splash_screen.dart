import 'dart:ui';
import 'package:app/views/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () { //
     Get.off(LoginScreen());
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.green,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          width: 220,
                          height: 220,
                          color:
                              Colors.white.withOpacity(0.2), // Semi-transparent
                          alignment: Alignment.center,
                        ),
                      ),
                    ),

                    // Image
                    Image.asset(
                      "assets/images/woe.png",
                      width: 200, // Adjust the width
                      height: 200, // Adjust the height
                    ),
                  ],
                ),

                const SizedBox(height: 20), // Space between the image and text
                const Text(
                  'Alert Master', // Replace with your text
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
