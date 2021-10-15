import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/app_data.dart';
import 'package:critical_x_quiz/core/firebase/firebase_methods.dart';
import 'package:critical_x_quiz/core/firebase/firebase_storage_method.dart';
import 'package:critical_x_quiz/core/model/user/user_model.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/view/screen/authScreen/AuthContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  // GetStorage authDB = GetStorage(DBConstant.authDb);
  final authDB = GetStorage();

  deleteAccount(BuildContext context) async {
    DialogRouter.displayProgressDialog(context);
    bool b = await _firebaseMethods.deleteUser();
    authDB.erase();
    DialogRouter.closeProgressDialog(context);

    if (b == true) {
      Get.offAll(AuthContainer());
    }
  }

  logOut() async {
    bool b = await _firebaseMethods.logOutUser();
    authDB.erase();
    if (b == true) {
      Get.offAll(AuthContainer());
    }
  }

  updateProfileImage(
    File profileImage,
  ) async {
    Get.snackbar("Update", "Profile picture updating");
    User user = FirebaseAuth.instance.currentUser;
    String imageUrl;
    Map<String, dynamic> userMap = new Map();
    if (profileImage != null) {
      imageUrl = await FireBaseFileStorage.uploadImage(
          imageFile: profileImage, dirName: "profileImage");

      userMap['proPic'] = imageUrl ?? null;
      if (imageUrl != null) {
        try {
          /* DocumentSnapshot ds=await   FirebaseFirestore.instance
              .collection(AppData.usersData)
              .doc(user.uid).get();*/
          if (GetUtils.isURL(user.photoURL))
            FireBaseFileStorage.deleteFile(user.photoURL);
        } catch (e) {}
        user.updateProfile(
          photoURL: imageUrl,
        );

        FirebaseFirestore.instance
            .collection(AppData.usersData)
            .doc(user.uid)
            .update(userMap)
            .then((value) {
          Get.snackbar("Update", "Profile picture updated");
        });
      }
    }
  }

  profileUpdateMethod({
    String name,
  }) async {
    User user = FirebaseAuth.instance.currentUser;

    Map<String, dynamic> userMap = new Map();

    if (name != null) {
      userMap['fullName'] = name;

      user.updateProfile(
        displayName: name,
      );
    }

    if (userMap.isNotEmpty) {
      Get.snackbar("Update", "Profile updating");
      FirebaseFirestore.instance
          .collection(AppData.usersData)
          .doc(user.uid)
          .update(userMap)
          .then((value) {
        Get.snackbar("Update", "Profile update  successful");
      });
    }
  }

  updatePassword(
    String password,
  ) async {
    if (password == null) return;
    if ((password?.length ?? 0) < 6) return;
    Get.snackbar("password", "password updating");
    User user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> userMap = new Map();
    userMap['password'] = password;

    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection(AppData.usersData)
        .doc(user.uid)
        .get();

    UserModel userModel = UserModel.fromDoc(ds);

    String res = await _firebaseMethods.logInUser(
        email: userModel.email, password: userModel.password);
    user = FirebaseAuth.instance.currentUser;
    if (res != AppData.successful) return;
    try {
      print(user.email);
      await user?.updatePassword(password);
      FirebaseFirestore.instance
          .collection(AppData.usersData)
          .doc(user.uid)
          .update(userMap)
          .then((value) {
        Get.snackbar("password", "password update  successful");
      }).catchError(() {
        Get.snackbar("password", "password update  unsuccessful");
      });
    } catch (e) {
      Get.snackbar("password", "password update  unsuccessful");
    }
  }
}
