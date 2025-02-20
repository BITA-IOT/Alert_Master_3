import 'package:app/services/firebase_service.dart';
import 'package:app/views/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController signinEmailController = TextEditingController();
  final TextEditingController signinPasswordController =
      TextEditingController();
  RxBool isPasswordVisible = false.obs;
  toggle() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  signupFun(context) {
    FirebaseService().register(context, emailController.text,
        passwordController.text, confirmPasswordController.text);
  }

  signinFun(context) {
    FirebaseService().login(
        context, signinEmailController.text, signinPasswordController.text);
  }

  logoutFun() {
    FirebaseAuth.instance.signOut();
    Get.offAll(() =>LoginScreen() );
  }
}