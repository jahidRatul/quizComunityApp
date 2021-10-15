import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/constant/local_db_constant.dart';
import 'package:critical_x_quiz/core/tools/flutter_toast.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:critical_x_quiz/ui/view/home/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../firebase/app_data.dart';
import '../firebase/firebase_methods.dart';

class AuthController extends GetxController {
  String name;
  String email;
  String password;
  String confirmPassword;

//  GetStorage authDB = GetStorage(DBConstant.authDb);
  final authDB = GetStorage();

  FirebaseMethods _firebaseMethods = FirebaseMethods();

  loginMethod(BuildContext context, String email, String password) async {
    try {
      DialogRouter.displayProgressDialog(context);
      String res =
          await _firebaseMethods.logInUser(email: email, password: password);

      if (res == AppData.successful) {
        User user = FirebaseAuth.instance.currentUser;
        if (user.uid == null) {
          FlutterToast.showErrorToast(
              message: "login failed.", context: context);
          return;
        }

        DocumentSnapshot dp = await FirebaseFirestore.instance
            .collection(AppData.usersData)
            .doc(user.uid)
            .get();
        if (dp.get('bannedUser') == true) {
          _firebaseMethods.logOutUser();
          AppRouter.navToAuthController();
          Get.snackbar("Banned User", "you are baned by admin",
              colorText: Colors.white, backgroundColor: Colors.red);
          return;
        }

        if (dp.get('admin') == true) {
          authDB.write(DBConstant.admin, true);
          authDB.write(DBConstant.userName, dp.get('fullName'));
          authDB.save();

          FlutterToast.showSuccess(
              message: "Admin Login successful", context: context);
        } else {
          authDB.write(DBConstant.admin, false);
          authDB.write(DBConstant.userName, dp.get('fullName'));
          authDB.save();
          FlutterToast.showSuccess(
              message: "Login successful", context: context);
        }

        DialogRouter.closeProgressDialog(context);
        AppRouter.navToHomePage();
      } else {
        DialogRouter.closeProgressDialog(context);
        FlutterToast.showErrorToast(message: "$res", context: context);
      }
    } catch (e) {}
  }

  signUpMethod(BuildContext context,
      {String email, String password, String name}) async {
    try {
      DialogRouter.displayProgressDialog(context);
      String res = await _firebaseMethods.createUserAccount(
          email: email, password: password, name: name);
      DialogRouter.closeProgressDialog(context);

      if (res == AppData.successful) {
        authDB.write(DBConstant.admin, false);
        FlutterToast.showSuccess(
            message: "SignUp successful", context: context);
        Get.offAll(HomeScreen(), transition: Transition.fade);
      } else {
        FlutterToast.showErrorToast(message: "$res", context: context);
      }
    } catch (e) {}
  }

  retrievePasswordMethod(BuildContext context, String email) async {
    try {
      DialogRouter.displayProgressDialog(context);
      String res = await _firebaseMethods.firebaseResetPassword(email);
      DialogRouter.closeProgressDialog(context);
      if (res == AppData.successful) {
        FlutterToast.showSuccess(
            message: "Password reset successful\nplease check your email",
            context: context);
      } else {
        FlutterToast.showErrorToast(
            message: "reset password failed", context: context);
      }
    } catch (e) {
      print(e);
    }
  }
}
