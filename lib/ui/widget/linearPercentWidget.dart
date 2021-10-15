import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:critical_x_quiz/core/model/user_progress_model/category_info_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearPercentWidget extends StatefulWidget {
  final String percentText;
  final String title;
  final double percentNumber;
  final Color color;
  final CategoryInfoModel categoryInfoModel;

  LinearPercentWidget({
    this.percentText,
    this.title,
    this.percentNumber,
    this.color,
    this.categoryInfoModel,
  });

  @override
  _LinearPercentWidgetState createState() => _LinearPercentWidgetState();
}

class _LinearPercentWidgetState extends State<LinearPercentWidget> {
  User firebaseUser = FirebaseAuth.instance.currentUser;

  double progress = 0.0;

  calculateProgress() async {
    double categoryScore;
    int correctAnsLength = widget?.categoryInfoModel?.correctAnsIDList?.length;

    var totalQuestionLength = await getCategoryQuestionLength(
        widget?.categoryInfoModel?.categoryTitle);

    print(totalQuestionLength);
    categoryScore = (correctAnsLength / totalQuestionLength).toDouble();

    print(categoryScore);
    if (categoryScore <= 1.0)
      progress = categoryScore;
    else {
      progress = 1.0;
      print(" value exist :: $categoryScore ");
      print(" correctAnsLength :: $correctAnsLength ");
      print(" totalQuestionLength:: $totalQuestionLength ");
    }
    setState(() {});
  }

  Future<int> getCategoryQuestionLength(String categoryName) async {
    QuestionModel questionModel;
    int totalLength;
    List<QuestionModel> questionModelList = [];

    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.questionAnswer)
        .where('category', isEqualTo: categoryName)
        .get();
    print("category total question len: ${qs.docs.length}");

    return totalLength = qs.docs.length;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userProgress?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseUser = FirebaseAuth.instance.currentUser;
    //calculateProgress();
    if (widget?.categoryInfoModel != null) listenChange();
  }

  StreamSubscription userProgress;

  listenChange() {
    userProgress = FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.userProgress)
        .doc("${firebaseUser.uid}")
        .snapshots()
        .listen((event) {
      calculateProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 10),
              child: Text(
                "${(progress * 100.0).round()}%",
                style: TextStyle(
                    color: Color(0xFF0C1A35),
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  "${widget.title}",
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(0xFF0C1A35),
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: LinearPercentIndicator(
            width: MediaQuery.of(context).size.width * 0.44,
            animation: true,
            lineHeight: 5.0,
            animationDuration: 2000,
            percent: progress,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: widget.color,
          ),
        ),
      ],
    );
  }
}
