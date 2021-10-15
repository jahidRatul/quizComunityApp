import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/app_collection/firebase_user_progress_collection.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/model/categoty_model/categoryModel.dart';
import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:critical_x_quiz/core/model/user_progress_model/category_info_model.dart';
import 'package:critical_x_quiz/core/model/user_progress_model/user_progress_model.dart';
import 'package:critical_x_quiz/core/utils/category_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MultiColorCircularPercentIndicator extends StatefulWidget {
  final List<double> taskPercent;
  final List<CategoryInfoModel> categoryInfoList;
  final List<CategoryModel> categoryList;

  MultiColorCircularPercentIndicator({
    @required this.taskPercent,
    this.categoryInfoList,
    this.categoryList,
  }) : assert(taskPercent != null, "task list required ");

  @override
  _MultiColorCircularPercentIndicatorState createState() =>
      _MultiColorCircularPercentIndicatorState();
}

class _MultiColorCircularPercentIndicatorState
    extends State<MultiColorCircularPercentIndicator> {
  List<double> taskPercentList = new List();

  Map<double, int> colorContainer = new Map();

  List<Color> catColor = new List();
  List<Color> catColor2 = new List();
  List<StoreCateData> jalaObjectList = new List();

  double completionRate = 0.0;

  calculateProgress(CategoryInfoModel model, int i) async {
    double categoryScore;
    int correctAnsLength = model?.correctAnsIDList?.length;

    var totalQuestionLength =
        await getCategoryQuestionLength(model?.categoryTitle);

    print("total question length" + totalQuestionLength.toString());
    try {
      categoryScore = (correctAnsLength / totalQuestionLength).toDouble();
    } catch (e) {
      categoryScore = 0.0;
    }
    print(categoryScore);
    if (categoryScore <= 1.0) {
      taskPercentList.add(categoryScore);

      jalaObjectList.add(StoreCateData(
        CategoryColor.getCategoryColor(i),
        model?.categoryTitle,
        0.0,
        categoryScore,
      ));
    }
    colorContainer[categoryScore] = i;

    taskPercentList?.sort((a, b) => a < b ? 1 : 0);
    // taskPercentList = taskPercentList.reversed;
    print("taskPercentList $taskPercentList");

    getColorPercent();
    completionRate = getCompletionRate().floorToDouble();
    if (isActiveContext) setState(() {});
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
    userProgressListenner?.cancel();
    isActiveContext = false;
    super.dispose();
  }

  final List<double> colorPercentList = new List();
  final List<double> returnColorFinalPercent = new List();

  @override
  void initState() {
    // TODO: implement initState
    isActiveContext = true;
    super.initState();
    // taskPercentList = widget?.taskPercent;

    //taskPercentList?.sort();
    print("widget?.categoryInfoList ${widget?.categoryInfoList?.length}");
    //  allTaskList(widget?.categoryInfoList ?? new List());
    // if (isActiveContext) setState(() {});
    listenUserProgress();
  }

  getColorPercent() {
    colorPercentList?.clear();
    for (int i = 0; i < jalaObjectList.length; i++) {
      double temp = jalaObjectList[i].singlePercentage / taskPercentList.length;
      colorPercentList.add(temp);
      colorContainer[temp] = i;
    }
    print("Color percent list out of toal 1" + "$taskPercentList");
    print("Color percent list out of toal 1" + "$colorPercentList");
    double tep = 0;
    returnColorFinalPercent?.clear();

    for (int m = 0; m < colorPercentList.length; m++) {
      tep = tep + colorPercentList[m];
      returnColorFinalPercent.add(tep);
      jalaObjectList[m].jalaPercentage = tep;
    }

    print("returnColorFinalPercent  $returnColorFinalPercent");
    print("returnColorFinalPercent  ${returnColorFinalPercent.length}");
    print("returnColorFinalPercent  ${taskPercentList.length}");
  }

  bool isActiveContext = false;

  StreamSubscription userProgressListenner;

  listenUserProgress() {
    User user = FirebaseAuth.instance.currentUser;

    userProgressListenner =
        FireBaseUserProgress.userProgressListenner(user.uid.toString())
            .listen((event) {
      if (event.data().isNullOrBlank) return;
      if (event.data().isEmpty) return;
      UserProgressModel userProgressModel =
          UserProgressModel?.fromJson(event.data());
      //  if (isActiveContext) setState(() {});

      // taskPercentList.clear();

      print("category list :  ${widget.categoryList}");

      allTaskList([
        ...Iterable.generate(
            (widget?.categoryList?.length ?? 0),
            (i) => userProgressModel
                ?.getCategoryInfoModel(widget?.categoryList[i].title)),
      ]);
    });
  }

  double userTotalProgress = 0.00000000;
  double userProgress = 0.0;
  int userAnswertLen = 0;

  allTaskList(List<CategoryInfoModel> categoryInfoList) {
    userAnswertLen = 0;
    int i = 0;
    catColor.clear();
    categoryInfoList.forEach((element) {
      if (element == null) {
        colorContainer[0.0] = i++;
        taskPercentList.add(0.0);
        return;
      }
      catColor.add(CategoryColor.getCategoryColor(i));
      calculateProgress(element, i++);
      userAnswertLen += element?.correctAnsIDList?.length ?? 0;

      //colorContainer[]
    });

    print(("catColor len $catColor"));
    allUserProgress();
  }

  Color getColor(double i) {
    /* print("taskPercentList ${taskPercentList}");
    print("task ${taskPercentList[taskPercentList.length - 1 - i]}");
    print(
        "color container ${colorContainer[taskPercentList[taskPercentList.length - 1 - i]]}");

    print("all color ${colorContainer}");
    int defaultValue =
        colorContainer[taskPercentList[taskPercentList.length - 1 - i]] ?? i;
    print('int i $i');
    print("defaultValue :: $defaultValue");*/

    print("percentage ${i}");
    // print("color  gggg ${colorContainer[i] ?? i}");
    // print("color  gggg ${colorContainer}");
    /*Color x = CategoryColor.getCategoryColor(
        colorContainer[taskPercentList[taskPercentList.length - 1 - i]] ?? i,form: "muti color");*/
    // Color x = CategoryColor.getCategoryColor(colorContainer[i] ?? i.toInt());
    Color x = CategoryColor.getCategoryColor(i.toInt() ?? 0);

    return x;
  }

  allUserProgress() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.questionAnswer)
        .get();

    if (qs.isNullOrBlank) return;
    int questionLen = qs?.docs?.length ?? 1;

    try {
      userTotalProgress = (userAnswertLen / questionLen).toDouble();
    } catch (e) {
      userTotalProgress = 0.0;
    }

    if (isActiveContext) setState(() {});
  }

  double getCompletionRate() {
    double d = 0.0;
    taskPercentList.forEach((element) {
      d += element;
    });
    try {
      d = d / (taskPercentList?.length?.toDouble() ?? 0.0);
    } catch (e) {
      d = 0.0;
    }
    if (isActiveContext) setState(() {});

    return (d * 100.0).toDouble() + 0.0;
  }

  getPercentage(double d) {
    print("reversedist : $d");
    return d;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 135,
        // color: Colors.orangeAccent,
        child: Stack(
          children: [
            if ((returnColorFinalPercent?.length ?? 0) > 0)
              ...Iterable.generate(
                (returnColorFinalPercent?.length ?? 0),
                //   3,
                (i) => Center(
                  child: CircularPercentIndicator(
                    radius: 122.0,
                    lineWidth: 8.0,
                    reverse: true,
                    animation: true,
                    // circularStrokeCap: CircularStrokeCap.round,
                    // percent: taskPercentList[i],
                    //  percent: taskPercentList[taskPercentList.length - 1 - i],
                    percent: i == 0
                        ? getPercentage(returnColorFinalPercent[
                                returnColorFinalPercent.length - 1 - i]) -
                            00.01
                        : getPercentage(returnColorFinalPercent[
                            returnColorFinalPercent.length - 1 - i]),
                    // percent: <double>[1.0, 0.7, 0.5][i],
                    // percent: taskPercentList[i],
                    backgroundColor: i == 0 ? Colors.grey : Colors.transparent,
                    /*progressColor: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],*/
                    /*progressColor: getColor(
                        taskPercentList[taskPercentList.length - 1 - i]),*/
                    //  progressColor: catColor[i],
                    progressColor: jalaObjectList[
                            (returnColorFinalPercent.length - 1 - i) %
                                jalaObjectList.length].catColor,
                  ),
                ),
              )
            else
              Center(
                child: CircularPercentIndicator(
                  radius: 122.0,
                  lineWidth: 8.0,
                  reverse: true,
                  animation: true,
                  // circularStrokeCap: CircularStrokeCap.round,
                  percent: 0.001,
                  // percent: taskPercentList[i],
                  backgroundColor: Colors.grey,
                  progressColor: Colors.grey,
                  // progressColor: getColor(0),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$completionRate%",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF0C1A35),
                        fontWeight: FontWeight.bold,
                        fontSize: 23),
                  ),
                  Text(
                    'completion \n rate',
                    // '${taskPercentList}',
                    style: TextStyle(
                        color: Color(0xFF0C1A35),
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreCateData {
  Color catColor;
  String title;
  double singlePercentage;
  double jalaPercentage;

  StoreCateData(this.catColor,
      this.title,
      this.jalaPercentage,
      this.singlePercentage,);
}
