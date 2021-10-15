import 'package:cloud_firestore/cloud_firestore.dart';

import 'form_post_answer_reply.dart';

class FormPostAnswerModel {
  Timestamp postTime = Timestamp.now();

  String authorUid;
  String authorName;
  String answerDescription;
  int upPoints;
  int downPoints;
  int answerId;
  bool isCorrect;
  List<String> pointUserId = new List<String>();
  List<String> likePointUserId = new List<String>();
  List<String> dislikePointUserId = new List<String>();

  List<FormPostAnswerReplyModel> replyList = new List();

  FormPostAnswerReplyModel getReplyAt(int index) {
    if (this.replyList == null) return null;
    if (this.replyList.length > index) return null;
    try {
      return this.replyList[index];
    } catch (e) {
      return null;
    }
  }

  int getTotalLike() {
    if (likePointUserId == null) return 0;
    return (this.likePointUserId?.length ?? 0);
  }

  int getTotalDisLike() {
    if (dislikePointUserId == null) return 0;
    return (this.dislikePointUserId?.length ?? 0);
  }

  FormPostAnswerModel({
    this.postTime,
    this.authorUid,
    this.authorName,
    this.answerDescription,
    this.upPoints,
    this.downPoints,
    this.isCorrect,
    this.replyList,
    this.answerId,
    this.pointUserId,
  }) {
    this.pointUserId = this.pointUserId ?? new List<String>();
    this.replyList = this.replyList ?? new List<FormPostAnswerReplyModel>();
  }

  FormPostAnswerModel.fromJson(Map<String, dynamic> map) {
    this.authorUid = map['authorUid'];
    this.authorName = map['authorName'];
    this.answerDescription = map['answerDescription'];
    this.upPoints = map['upPoint'];
    this.downPoints = map['downPoints'];
    this.answerId = map['answerId'];
    this.isCorrect = map['isCorrect'];
    this.postTime = map['postTime'];

    this.replyList = new List<FormPostAnswerReplyModel>();
    if (map['replyList'] != null) {
      map['replyList'].forEach((e) {
        replyList.add(FormPostAnswerReplyModel.fromJson(e));
      });
    }

    this.pointUserId = new List<String>();
    if (map['pointUserId'] != null) {
      map['pointUserId'].forEach((e) {
        this.pointUserId.add(e);
      });
    }

    this.likePointUserId = new List<String>();
    if (map['likePointUserId'] != null) {
      map['likePointUserId'].forEach((e) {
        this.likePointUserId.add(e);
      });
    }

    this.dislikePointUserId = new List<String>();
    if (map['dislikePointUserId'] != null) {
      map['dislikePointUserId'].forEach((e) {
        this.dislikePointUserId.add(e);
      });
    }
  }

  bool isAnswerOwner(String s) {
    bool b = false;
    if (this.authorUid == s) return true;
    return false;
  }

  toJson() {
    Map<String, dynamic> map = new Map();
    map['postTime'] = this.postTime ?? Timestamp.now();

    map['authorUid'] = this.authorUid;
    map['authorName'] = this.authorName;
    map['answerDescription'] = this.answerDescription;
    map['upPoint'] = this.upPoints;
    map['downPoints'] = this.downPoints;
    map['isCorrect'] = this.isCorrect;
    map['answerId'] = this.answerId;
    map['replyList'] = this.replyList == null
        ? new List<FormPostAnswerReplyModel>()
        : this.replyList.map((e) => e.toJson()).toList();

    map['pointUserId'] = this.pointUserId == null
        ? new List<String>()
        : this.pointUserId?.map((e) => e.toString())?.toList();

    map['dislikePointUserId'] = this.dislikePointUserId == null
        ? new List<String>()
        : this.dislikePointUserId?.map((e) => e.toString())?.toList();

    map['likePointUserId'] = this.likePointUserId == null
        ? new List<String>()
        : this.likePointUserId?.map((e) => e.toString())?.toList();

    return map;
  }
}
