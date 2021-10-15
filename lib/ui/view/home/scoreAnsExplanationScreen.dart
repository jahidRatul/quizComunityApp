import 'dart:math';

import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/controller/score_and_explanation_screen_controller.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:critical_x_quiz/ui/widget/button/RoundedButton.dart';
import 'package:critical_x_quiz/ui/widget/customHomeNavBar.dart';
import 'package:critical_x_quiz/ui/widget/linearPercentWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ScoreAnsExplanationScreen extends StatefulWidget {
  static String id = 'scoreAnsExplanation';

  @override
  _ScoreAnsExplanationScreenState createState() =>
      _ScoreAnsExplanationScreenState();
}

class _ScoreAnsExplanationScreenState extends State<ScoreAnsExplanationScreen> {
  int currentIndex = 0;

  final controller = PageController(viewportFraction: 0.8);
  HomePageController homePageController = Get.put(HomePageController());

  bool ansA = false;
  bool ansB = false;
  bool ansC = false;
  bool ansD = false;
  bool ansE = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> willPopMethod() async {
    return await DialogRouter.displayConfirmDialog(
      context: context,
      titleText: 'Are you sure?',
      bodyText: 'Back to Home',
      yesPress: () {
        AppRouter.navToHomePage();
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 0,
                        ),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Color(0xFF141414),
                                size: 20,
                              ),
                              onPressed: () {
                                willPopMethod();
                                // Navigator.pop(context);
                              }),
                        )),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      'Answers & Explanation',
                      style: TextStyle(
                        color: Color(0xFF0C1A35),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      child: Image.asset('images/scoreimg.png'),
                      height: 300,
                      width: wp(100),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Your Score',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GetBuilder<ScoreAnsExplanationScreenController>(
                          builder: (c) => Text(
                            '${c.correctAnswerListLen}/${c.allAnswerListLen}',
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GetBuilder<ScoreAnsExplanationScreenController>(
                          builder: (c) => Text(
                            '${c?.getCategoryName()}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        GetBuilder<ScoreAnsExplanationScreenController>(
                          builder: (c) => CircularPercentIndicator(
                            radius: 122.0,
                            lineWidth: 8.0,
                            percent: c.getPercentage(),
                            progressColor: Color(0xFF25AFA2),
                            backgroundColor: Colors.white,
                            //  arcType: ArcType.FULL,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${(c.getPercentage() * 100.0).toStringAsFixed(2)}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 29),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Text(
                          '4 Tiers',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GetBuilder<ScoreAnsExplanationScreenController>(
                builder: (c) => Center(
                  child: Container(
                    width: 200,
                    height: 70,
                    child: RoundBoarderButton(
                      backGroundColor: Color(0xFFFD5959),
                      borderRadius: 30,
                      text: "Check answers",
                      onPress: () {
                        if ((c?.questionModelList?.length ?? 0) > 0) {
                          AppRouter.navToCheckAnsExplanationScreen(
                              c?.questionModelList);
                        } else {
                          Get.snackbar("Score zero", "No Answer Given",
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
                      },
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomHomeNavyBar(
          containerHeight: 260,
          selectedIndex: currentIndex,
          showElevation: true,
          itemCornerRadius: 50,
          curve: Curves.easeInBack,
          onItemSelected: (index) => setState(() {
            currentIndex = index;
            if (currentIndex == 0) {
              AppRouter.navToHomePage();
            }
          }),
          mainAxisAlignment: MainAxisAlignment.center,
          scoreWidget: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'Overall Score',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0C1A35)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 120,
                child: Container(
                  child: Obx(
                    () => GridView.builder(
                        shrinkWrap: true,

                        ///physics: NeverScrollableScrollPhysics()
                        // scrollDirection: Axis.horizontal,
                        itemCount: (homePageController?.userProgressModel?.value
                                ?.categoryInfoList?.length ??
                            0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: wp(44) / 50,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                        ),
                        itemBuilder: (BuildContext context, index) {
                          return Container(
                            //  width: MediaQuery.of(context).size.width*.5,
                            child: LinearPercentWidget(
                              title: homePageController
                                  ?.userProgressModel
                                  ?.value
                                  ?.categoryInfoList[index]
                                  .categoryTitle,
                              color: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)],
                              categoryInfoModel: homePageController
                                  ?.userProgressModel
                                  ?.value
                                  ?.categoryInfoList[index],

                              // percentNumber: 0.75,
                              //  percentText: "75%",
                            ),
                          );
                        }),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
          items: [
            BottomHomeNavyBarItem(
              icon: Icon(Icons.home),
              title: Text(
                'Home',
              ),
              activeColor: Color(0xFFFD5959),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
