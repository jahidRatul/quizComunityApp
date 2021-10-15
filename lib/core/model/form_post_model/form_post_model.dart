import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:get/get.dart';

import 'form_post_answer_model.dart';

class FormPostModel {
  String category;
  String categoryImage;
  String authName;
  String authorUid;
  bool isAnswered = false;
  Timestamp postTime = Timestamp.now();
  String questionDescription;
  String title;
  List<String> imageList = new List();
  String postId;
  List<FormPostAnswerModel> answeredList = new List();

  FormPostAnswerModel answerAt(int index) {
    if (this.answeredList == null) return null;
    if (this.answeredList.length < index) return null;
    try {
      return this.answeredList[index];
    } catch (e) {
      return null;
    }
  }

  bool isPostOwner(String s) {
    bool b = false;
    if (this.authorUid == s) return true;
    return false;
  }

  void setCorrectAns(int i, bool value) {
    bool b = false;
    int len = this?.answeredList?.length ?? 0;
    if (len < i) return;
    for (int i = 0; i < len; i++) {
      this?.answeredList[i].isCorrect = false;
    }

    this?.answeredList[i].isCorrect = value;
    this.isAnswered = value;
    // return b;
  }

  bool getIsThereAnyCorrectAns() {
    bool b = false;
    int len = this?.answeredList?.length ?? 0;
    for (int i = 0; i < len; i++) {
      if (this?.answeredList[i].isCorrect == true) {
        b = true;
        break;
      }
    }
    this.isAnswered = b;
    return b;
  }

  FormPostModel({
    this.category,
    this.authName,
    this.authorUid,
    this.isAnswered = false,
    this.postTime,
    this.questionDescription,
    this.title,
    this.imageList,
    this.answeredList,
    this.categoryImage,
  }) {
    this.postId = "$authName$authorUid$postTime";
  }

  FormPostModel.fromJson(Map<String, dynamic> json) {
    this.category = json['category'];
    this.authName = json['authName'];
    this.authorUid = json['authorUid'];
    this.isAnswered = json['isAnswered'];
    this.postTime = json['postTime'];
    this.questionDescription = json['questionDescription'];
    this.title = json['title'];
    this.imageList = new List<String>();
    if (json['imageList'] != null) {
      json['imageList'].forEach((e) {
        imageList.add(e.toString());
      });
    }

    this.postId = json['postId'];
    this.answeredList = new List<FormPostAnswerModel>();

    if (json['answeredList'] != null) {
      json['answeredList'].forEach((e) {
        this.answeredList.add(FormPostAnswerModel.fromJson(e));
      });
    }
    this.categoryImage = json['categoryImage'];
    getIsThereAnyCorrectAns();
  }

  _fromJson(Map<String, dynamic> json) {
    this.category = json['category'];
    this.authName = json['authName'];
    this.authorUid = json['authorUid'];
    this.isAnswered = json['isAnswered'];
    this.postTime = json['postTime'];
    this.questionDescription = json['questionDescription'];
    this.title = json['title'];
    this.imageList = new List<String>();
    if (json['imageList'] != null) {
      json['imageList'].forEach((e) {
        imageList.add(e.toString());
      });
    }

    this.postId = json['postId'];
    this.answeredList = new List<FormPostAnswerModel>();

    if (json['answeredList'] != null) {
      json['answeredList'].forEach((e) {
        this.answeredList.add(FormPostAnswerModel.fromJson(e));
      });
    }
    this.categoryImage = json['categoryImage'];
    getIsThereAnyCorrectAns();
  }

  StreamSubscription _listen;

  void toListen({Function(DocumentSnapshot dp) listen}) async {
    if (this.postId.isNullOrBlank) {
      this?.cancel();
      return;
    }
    if (this.postId == null) {
      this?.cancel();
      return;
    }
    try {
      _listen = FirebaseFirestore.instance
          .collection(FireBaseCollectionNames.formPostCollection)
          .doc(this.postId)
          .snapshots()
          .listen((event) async {
        if (event.isNullOrBlank) return;
        this._fromJson(event.data());
        await Future.delayed(Duration(microseconds: 100));
        listen?.call(event);
      });
    } catch (e) {}
  }

  cancel() {
    try {
      print("cancel _listen FormPostModel ");
      _listen?.cancel();
    } catch (e) {}
  }

  toJson() {
    getIsThereAnyCorrectAns();
    Map<String, dynamic> map = new Map();
    map['category'] = this.category;
    map['categoryImage'] = this.categoryImage;
    map['authName'] = this.authName;
    map['authorUid'] = this.authorUid;
    map['isAnswered'] = this.isAnswered;
    map['postTime'] = this.postTime ?? Timestamp.now();
    map['questionDescription'] = this.questionDescription;
    map['title'] = this.title;
    map['imageList'] = this.imageList ?? new List<String>();
    map['postId'] = "$authName$authorUid$postTime";
    map['answeredList'] = this.answeredList == null
        ? new List<FormPostAnswerModel>()
        : this.answeredList.map((e) => e.toJson()).toList();

    return map;
  }

  FormPostModel copy() {
    return new FormPostModel.fromJson(this.toJson());
  }
}
