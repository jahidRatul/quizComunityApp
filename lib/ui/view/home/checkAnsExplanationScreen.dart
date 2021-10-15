import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:critical_x_quiz/ui/view/question_explanation/card/questionExplanationView.dart';
import 'package:critical_x_quiz/ui/widget/button/questionNextButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

class CheckAnsExplanationScreen extends StatefulWidget {
  static String id = 'checkAnsExplanation';
  final List<QuestionModel> questionList;

  CheckAnsExplanationScreen(this.questionList);

  @override
  _CheckAnsExplanationScreenState createState() =>
      _CheckAnsExplanationScreenState();
}

class _CheckAnsExplanationScreenState extends State<CheckAnsExplanationScreen> {
  List<QuestionModel> questionList = [];

  int currentIndex = 0;

  PageController _pageController = new PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    questionList.clear();
    questionList = widget?.questionList ?? new List();
  }

  Future<bool> willPopMethod() async {
    return await DialogRouter.displayConfirmDialog(
      context: context,
      titleText: 'Explanation Finished!',
      bodyText: 'Back to Home',
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
        // backgroundColor: Color(0xFFFDF5F5),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: questionList.length,
              onPageChanged: (v) {
                currentIndex = v;
              },
              itemBuilder: (_, i) => QuestionExplanationView(
                questionList[i],
                popCallBack: () {
                  willPopMethod();
                },
              ),
            ),
          ),
        ),
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
                        _pageController.previousPage(
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
                child: QuestionNextButton(
                  text: 'Next',
                  backGroundColor: Color(0xFFFD5959),
                  onPress: () {
                    _pageController.nextPage(
                        duration: Duration(microseconds: 100),
                        curve: Cubic(0.42, 0.0, 1.0, 1.0));
                    if (currentIndex + 1 == questionList.length) {
                      // Get.back();
                      DialogRouter.displayConfirmDialog(
                        context: context,
                        titleText: 'Explanation Finished!',
                        bodyText: 'Back to Home',
                        yesPress: () {
                          AppRouter.navToHomePage();
                        },
                        noPress: () {
                          AppRouter.back();
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
