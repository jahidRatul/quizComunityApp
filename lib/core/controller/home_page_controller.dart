import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/constant/local_db_constant.dart';
import 'package:critical_x_quiz/core/firebase/app_collection/firebase_user_progress_collection.dart';
import 'package:critical_x_quiz/core/firebase/app_collection/form_post_collection.dart';
import 'package:critical_x_quiz/core/firebase/app_data.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/firebase/firebase_methods.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_model.dart';
import 'package:critical_x_quiz/core/model/user/user_model.dart';
import 'package:critical_x_quiz/core/model/user_progress_model/user_progress_model.dart';
import 'package:critical_x_quiz/ui/view/screen/authScreen/AuthContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePageController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getUserData();
    getFormPostDataList();
    listenUserProgress();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // test("ready");
  }

  void test(String s) {
    userName.value = "$s";
  }

  final authDB = GetStorage();
  StreamSubscription formPostCollection;

  getFormPostDataList() {
    formPostCollection = FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.formPostCollection)
        .orderBy("postTime", descending: true)
        .snapshots()
        .listen((event) {
      print(event.runtimeType);
      formPostListContainer.clear();
      formPostList.clear();
      tempFormPostList.clear();

      event.docs.forEach((element) {
        FormPostModel model = FormPostModel.fromJson(element.data());
        formPostListContainer.add(model);
        formPostList.value = formPostListContainer.value;
      });

      //  formPostList.assignAll(tempFormPostList) ;
    });
  }

  StreamSubscription userStream;

  getUserData() async {
    User user = FirebaseAuth.instance.currentUser;
    if (user.uid == null) {
      return;
    }

    //DocumentSnapshot dp = await
    userStream = FirebaseFirestore.instance
        .collection(AppData.usersData)
        .doc(user.uid)
        .snapshots()
        .listen((event) async {
      DocumentSnapshot dp = event;
      if (dp.isNullOrBlank) return;
      if (dp.data().isNullOrBlank) return;
      if (dp.data().isEmpty) return;
      UserModel userModel = UserModel?.fromDoc(dp);
      currentUserModel = userModel;
      if (userModel.bannedUser == true) {
        Get.snackbar("Banned!!!", "You are Banned by admin",
            backgroundColor: Colors.red, colorText: Colors.white);
        await Future.delayed(Duration(seconds: 2));
        FirebaseMethods().logOutUser();
        Get.offAll(AuthContainer());
      }
      isAdminUser.value = userModel.admin;
      userName.value = userModel.fullName;
      proImage.value = userModel.proPic;
      authDB.write(DBConstant.userName, userModel.fullName);
      authDB.write(DBConstant.userUid, userModel.uid);
      authDB.save();
    });
  }

  searchByCategoryMethod(String category) {
    if (category.toLowerCase() == "all".toLowerCase()) {
      formPostList.value = formPostListContainer.value;
      return;
    }
    formPostList.value = formPostListContainer.value
        .where((element) => element.category == category)
        .toList();
  }

  Future onPostDeleteMethod(FormPostModel model) {
    return ForumPostCollection.forumPostDataDelete(model);
  }

  StreamSubscription userProgressListenner;

  listenUserProgress() {
    User user = FirebaseAuth.instance.currentUser;

    userProgressListenner =
        FireBaseUserProgress.userProgressListenner(user.uid.toString())
            .listen((event) {
      if (event.data().isNullOrBlank) return;
      if (event.data().isEmpty) return;
      userProgressModel.value = UserProgressModel?.fromJson(event.data());
      userProgressModel2 = UserProgressModel?.fromJson(event.data());
      update();
    });
  }

  UserModel currentUserModel;

  RxBool isAdminUser = false.obs;

  Rx<UserProgressModel> userProgressModel = new UserProgressModel().obs;
  UserProgressModel userProgressModel2 = new UserProgressModel();

  RxString proImage = 'https://www.woolha.com/media/2020/03/eevee.png'.obs;

  RxString userName = ''.obs;
  RxList<FormPostModel> formPostList = new RxList<FormPostModel>();
  RxList<FormPostModel> formPostListContainer = new RxList<FormPostModel>();

  List<FormPostModel> tempFormPostList = new List();

  @override
  onClose() {
    userStream?.cancel();
    formPostCollection?.cancel();
    userProgressListenner?.cancel();
    print("on close HomePageController ");
  }
}
