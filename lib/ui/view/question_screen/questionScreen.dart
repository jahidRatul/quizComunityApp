import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/controller/question_screen_controller.dart';
import 'package:critical_x_quiz/core/model/categoty_model/categoryModel.dart';
import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:critical_x_quiz/core/model/user_progress_model/category_info_model.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:critical_x_quiz/ui/view/admin_view/adminCreateQuestion.dart';
import 'package:critical_x_quiz/ui/view/question_screen/card/question_view.dart';
import 'package:critical_x_quiz/ui/widget/button/questionNextButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

class QuestionScreen extends StatefulWidget {
  final CategoryModel model;
  static String id = 'question';

  QuestionScreen(this.model);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentIndex = 0;
  int activePage = 0;
  int currentIndex2 = 0;
  final PageController controller = PageController(viewportFraction: 1.0);

  final PageController controller2 = PageController(viewportFraction: 1.0);

  bool ansA = false;
  bool ansB = false;
  bool ansC = false;
  bool ansD = false;
  bool ansE = false;

  List<QuestionModel> correctAnswerObjectList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> willPopMethod() async {
    return await DialogRouter.displayConfirmDialog(
      context: context,
      titleText: 'Quit Quiz!!',
      bodyText: 'Are you sure?',
      yesPress: () {
        AppRouter.back();
        AppRouter.back();
        return true;
      },
      noPress: () {
        AppRouter.back();
        return false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return WillPopScope(
      onWillPop: willPopMethod,
      child: Scaffold(
        backgroundColor: Color(0xFFFDF5F5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              willPopMethod();
              //Navigator.pop(context);
            },
            child: Container(
              width: 50,
              height: 30,
              // color: Colors.blue,
              child: Center(
                child: Container(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF141414),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: true
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 0,
                              ),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Color(0xFF141414),
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              )),
                    ),
                    Expanded(
                      flex: 14,
                      child: Text(
                        '${widget?.model?.title}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Color(0xFF0C1A35),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    /* RaisedButton(
                      onPressed: () {
                       // AppRouter.navToCheckAnsExplanationScreen();
                      },
                      child: Text('go Ans'),
                    ),*/
                    GetX<HomePageController>(
                      builder: (c) => Visibility(
                        visible: c.isAdminUser.value,
                        child: SizedBox(
                          width: 40,
                          child: RaisedButton(
                            onPressed: () {
                              AppRouter.navToEditQuestionByCategory();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => AllQuestions(),
                              //   ),
                              // );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            color: Colors.indigoAccent,
                            child: Text(
                              'Q',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GetX<HomePageController>(
                      builder: (c) => c.isAdminUser.value == false
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () {
                                  Get.off(AdminCreateQuestion(
                                    title: '${widget?.model?.title}',
                                  ));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                color: Colors.indigoAccent,
                                child: Text(
                                  '+ Question',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        floatingActionButton: GetBuilder<QuestionScreenController>(
          builder: (c) => FloatingActionButton.extended(
            onPressed: () {
              c.updateUserProgress();
              AppRouter.navToScoreAnsExplanationScreen(correctAnswerObjectList);
            },
            label: Text(
              'Submit',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        ),
        body: GetX<QuestionScreenController>(
          builder: (qc) => (qc?.questionModelList?.value?.length ?? 0) <
                  1 //&& qc?.loading.value==true
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: Text("${qc.loadingText.value}"),
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        height: 20,
                        width: wp(100),
                      ),
                      Container(
                        color: Colors.white,
                        height: 40,
                        child: PageView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          controller: controller2,
                          itemCount: 5,
                          //_questionModelList.length,
                          onPageChanged: (index) {
                            currentIndex = index;
                            //  print(currentIndex);
                            setState(() {});
                          },
                          itemBuilder: (context, i) => Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...Iterable.generate(
                                  // _questionModelList.length,
                                  5,
                                  (i) => Column(
                                    children: [
                                      Container(
                                        //   color: Colors.green,
                                        // width: 36,
                                        width: 36,
                                        child: Visibility(
                                          visible: true, // i == currentIndex,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                i == currentIndex
                                                    ? "${activePage + 1}"
                                                    : "",
                                                style: TextStyle(
                                                  color: Color(0xFFFD5959),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        //   color: Colors.green,
                                        // width: 36,
                                        width: 24,
                                        child: Visibility(
                                          visible: true,
                                          //i == (currentIndex % 6),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: i == currentIndex
                                                        ? Colors.red
                                                        : Color(0xffF1F1F1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                width: 36,
                                                height: 4,
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
                      ),
                      Expanded(
                        child: GetX<QuestionScreenController>(
                          builder: (c) => Container(
                            child: PageView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              controller: controller,
                              onPageChanged: (index) {
                                activePage = index;
                                controller2.animateToPage(index % 5,
                                    duration: Duration(microseconds: 100),
                                    curve: Cubic(0.42, 0.0, 1.0, 1.0));
                                // setState(() {});
                                print("activePage $activePage");
                              },
                              itemCount:
                                  c.questionModelList?.value?.length ?? 0,
                              itemBuilder: (context, index) => QuestionView(
                                //controller: controller,
                                model: c.questionModelList.value[index],
                                userAnswer: (userAnswerOption) {
                                  c.questionModelList.value[index].userAnswer =
                                      userAnswerOption;

                                  /// correctAnswerObjectList  contain question and answer  list  for new 2 activity
                                  /// correctAnswerObjectList not contain current question
                                  if (!correctAnswerObjectList.contains(
                                      c.questionModelList.value[index]))
                                    correctAnswerObjectList
                                        .add(c.questionModelList.value[index]);
                                  QuestionModel tempModel =
                                      c.questionModelList.value[index];

                                  /// if answer is correct
                                  if (tempModel.answer ==
                                      tempModel.getAnswer(userAnswerOption)) {
                                    if (c.userProgressModel.categoryTitleList
                                        .contains(tempModel.category)) {
                                      c.userProgressModel.categoryInfoList
                                          .forEach((element) {
                                        if (element.categoryTitle ==
                                            tempModel.category) {
                                          if (!element.correctAnsIDList
                                              .contains(tempModel.questionId)) {
                                            element.correctAnsIDList
                                                .add(tempModel.questionId);
                                            return;
                                          }
                                        }
                                      });
                                    } else {
                                      c.userProgressModel.categoryTitleList
                                          .add(tempModel.category);
                                      CategoryInfoModel m = CategoryInfoModel(
                                          categoryTitle: widget.model.title,
                                          correctAnsIDList: [
                                            '${tempModel.questionId}'
                                          ]);
                                      c.userProgressModel.categoryInfoList
                                          .add(m);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        // [currentIndex2],
        bottomNavigationBar: Container(
          height: 90,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(
                  height: 50,
                  width: 120,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                          color: Color(0xff707070).withOpacity(0.2),
                          width: .50),
                    ),
                    shadowColor: Colors.black26,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      onTap: () {
                        controller.previousPage(
                            duration: Duration(microseconds: 100),
                            curve: Cubic(0.42, 0.0, 1.0, 1.0));
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFFD5959),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GetBuilder<QuestionScreenController>(
                  builder: (c) => QuestionNextButton(
                    text: 'Next',
                    backGroundColor: Color(0xFFFD5959),
                    onPress: () {
                      /* if (c.questionModelList.value.length == activePage + 1)
                            return;*/
                      controller.nextPage(
                          duration: Duration(microseconds: 100),
                          curve: Cubic(0.42, 0.0, 1.0, 1.0));
                      print(activePage);

                      if (activePage + 1 ==
                          (c?.questionModelList?.value?.length ?? 0)) {
                        c.updateUserProgress();
                        AppRouter.navToScoreAnsExplanationScreen(
                            correctAnswerObjectList);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
