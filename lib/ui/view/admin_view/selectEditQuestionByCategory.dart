import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/model/categoty_model/categoryModel.dart';
import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:critical_x_quiz/ui/widget/quizCategoryWidgetQuestions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import 'allQuestions.dart';

class SelectEditQuestionByCategory extends StatefulWidget {
  static String id = 'forumScreen';

  @override
  _SelectEditQuestionByCategoryState createState() =>
      _SelectEditQuestionByCategoryState();
}

class _SelectEditQuestionByCategoryState
    extends State<SelectEditQuestionByCategory> {
  String queryByCategory = "";

  List<CategoryModel> categoryList = new List();

  StreamSubscription categoryCollection;

  testFireBAseMethod() {
    categoryCollection = FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.categoryCollection)
        .snapshots()
        .listen((event) {
      print("Test " + event.docs.length.toString());
      categoryList.clear();
      if (event.isNullOrBlank) return;
      event.docs?.forEach((element) {
        if (element.isNullOrBlank) return;
        CategoryModel model = CategoryModel.fromJson(element.data());

        categoryList?.add(model);

        setState(() {});
      });
      categoryList.insert(
        0,
        CategoryModel(title: 'All', categoryImage: ''),
      );
    });
  }

  List<QuestionModel> questionList = new List<QuestionModel>();

  getQuestion() async {
    QuerySnapshot qt =
        await FirebaseFirestore.instance.collection('questionAnswer').get();

    qt.docs.forEach((element) {
      QuestionModel model = QuestionModel.fromJson(element.data());
      questionList.add(model);
    });
    resetScreen();
    print("question list " + questionList.length.toString());
  }

  int getCategoryLength(String q) {
    if (q.toLowerCase() == "all".toLowerCase())
      return questionList?.length ?? 0;
    return questionList
            ?.where((element) =>
                element?.category?.toLowerCase() == q?.toLowerCase())
            ?.toList()
            ?.length ??
        0;
  }

  @override
  void dispose() {
    isActiveState = false;
    // TODO: implement dispose
    categoryCollection?.cancel();
    super.dispose();
  }

  bool isActiveState = false;

  resetScreen() {
    if (isActiveState) setState(() {});
  }

  @override
  void initState() {
    isActiveState = true;
    testFireBAseMethod();
    super.initState();
    getQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Question by Category'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(0.0),
                  children: [
                    Visibility(
                      visible: true,
                      child: GetBuilder<HomePageController>(
                        builder: (c) => Container(
                          // height: 800,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: categoryList.length,
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.94,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      child: QuizCategoryWidgetQuestions(
                                        imgPath:
                                            categoryList[index]?.categoryImage,
                                        title: categoryList[index]?.title,
                                        questionLength: getCategoryLength(
                                            "${categoryList[index]?.title}"),
                                        getCategoryName: (categoryName) {
                                          queryByCategory = categoryName;
                                          c.searchByCategoryMethod(
                                              categoryName);
                                        },
                                        onTap: () {
                                          print("clicked");
                                          if (index == 0) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AllQuestions(),
                                              ),
                                            );
                                          } else {
                                            AppRouter
                                                .navToCategoryWiseQuestions(
                                                    categoryList[index]);
                                          }

                                          setState(() {});
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
