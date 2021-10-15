import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/firebase/firebase_storage_method.dart';
import 'package:get/get.dart';

class CategoryModel {
  String title;
  String categoryImage;

  CategoryModel({this.title, this.categoryImage});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.categoryImage = json['categoryImage'];
  }

  delete() {
    if (this.title.isNullOrBlank) return;
    if (this.title == null) return;
    if (!this.categoryImage.isNullOrBlank) {
      FireBaseFileStorage.deleteFile(this.categoryImage);
    }

    return FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.categoryCollection)
        .doc(this.title)
        .delete();
  }

  toJson() {
    Map<String, dynamic> json = new Map();
    json['title'] = this.title ?? "";
    json['categoryImage'] = this.categoryImage;

    return json;
  }
}
