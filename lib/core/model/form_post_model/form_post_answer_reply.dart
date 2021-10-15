import 'package:cloud_firestore/cloud_firestore.dart';

class FormPostAnswerReplyModel {
  Timestamp postTime = Timestamp.now();
  String authorName;
  String replyDescription;
  String authorUid;

  FormPostAnswerReplyModel({
    this.postTime,
    this.authorName,
    this.replyDescription,
    this.authorUid,
  });

  FormPostAnswerReplyModel.fromJson(Map<String, dynamic> json) {
    this.authorUid = json['authorUid'];
    this.authorName = json['authorName'];
    this.replyDescription = json['replyDescription'];
    this.postTime = json['postTime'];
  }

  bool isAnswerReplyOwner(String s) {
    bool b = false;
    if (this.authorUid == s) return true;
    return false;
  }

  toJson() {
    Map<String, dynamic> map = new Map();
    map['authorName'] = this.authorName;
    map['replyDescription'] = this.replyDescription;
    map['authorUid'] = this.authorUid;
    map['postTime'] = this.postTime ?? Timestamp.now();

    return map;
  }
}
