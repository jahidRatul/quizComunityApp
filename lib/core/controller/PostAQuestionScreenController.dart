import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/firebase/firebase_storage_method.dart';
import 'package:critical_x_quiz/core/model/categoty_model/categoryModel.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_model.dart';
import 'package:critical_x_quiz/core/tools/flutter_toast.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PostAQuestionScreenController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getAllCategory();
    super.onInit();
  }

  postAQuestion(
    BuildContext context, {
    String title,
    String category,
    String categoryImage,
    String question,
    List<File> imageList,
  }) async {
    List<String> imgList = new List();
    print("ok postAQuestion");

    EasyLoading.show(
      status: 'loading...',
    );

    for (int i = 0; i < imageList?.length ?? 0; i++) {
      String url = await FireBaseFileStorage.uploadImage(
        imageFile: imageList[i],
        dirName: "formPostImage/",
      );
      imgList.add(url);
    }
    User user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    FormPostModel model = FormPostModel(
      category: category,
      categoryImage: categoryImage,
      title: title,
      questionDescription: question,
      imageList: imgList,
      postTime: Timestamp.now(),
      authName: user.displayName,
      authorUid: user.uid,
      isAnswered: false,
      answeredList: new List(),
    );

    FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.formPostCollection)
        .doc(model.postId)
        .set(model.toJson())
        .then((value) {
      EasyLoading.show(
        status: 'loading...',
      );
      EasyLoading.dismiss();
      FlutterToast.showSuccess(message: "post success", context: context);
      AppRouter.navToHomePage(initialIndex: 2);
    });

    print("ok postAQuestion");
  }

  StreamSubscription categoryCollection;

  getAllCategory() {
    categoryCollection = FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.categoryCollection)
        .snapshots()
        .listen((event) {
      print("category length  ${event.docs.length}");
      List<CategoryModel> categoryTemp = List();
      categoryTemp.clear();
      categoryModelList.clear();
      event.docs.forEach((element) {
        CategoryModel model = new CategoryModel.fromJson(element.data());
        categoryTemp.add(model);
      });

      categoryModelList.value = categoryTemp;
    });
  }

  RxList<CategoryModel> categoryModelList = RxList<CategoryModel>();

  @override
  onClose() {
    categoryCollection?.cancel();
    print("on close HomePageController ");
  }
}
