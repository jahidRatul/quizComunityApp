import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:critical_x_quiz/core/tools/flutter_toast.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/view/forum/forumScreen.dart';
import 'package:critical_x_quiz/ui/widget/button/questionNextButton.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'AllQuestions.dart';

class AdminCreateQuestion extends StatefulWidget {
  final String title;

  AdminCreateQuestion({this.title});

  @override
  _AdminCreateQuestionState createState() => _AdminCreateQuestionState();
}

final fireStoreInstance = FirebaseFirestore.instance;

class _AdminCreateQuestionState extends State<AdminCreateQuestion> {
  TextEditingController questionController = TextEditingController();
  TextEditingController optionAController = TextEditingController();
  TextEditingController optionBController = TextEditingController();
  TextEditingController optionCController = TextEditingController();
  TextEditingController optionDController = TextEditingController();
  TextEditingController optionEController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode questionNode = FocusNode();
  FocusNode aNode = FocusNode();

  FocusNode cNode = FocusNode();
  FocusNode bNode = FocusNode();
  FocusNode dNode = FocusNode();
  FocusNode eNode = FocusNode();
  FocusNode descriptionNode = FocusNode();

  allUnFocus() {
    questionNode.unfocus();
    aNode.unfocus();
    bNode.unfocus();
    cNode.unfocus();
    dNode.unfocus();
    eNode.unfocus();
    descriptionNode.unfocus();
  }

  final _formKey = GlobalKey<FormState>();

  int currentIndex = 0;
  int currentIndex2 = 0;

  final PageController controller = PageController(viewportFraction: 0.8);
  String correctAns;

  bool ansA = false;
  bool ansB = false;
  bool ansC = false;
  bool ansD = false;
  bool ansE = false;

  pickFile() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;

        final input = new File(file.path).openRead();
        final fields = await input
            .transform(utf8.decoder)
            .transform(new CsvToListConverter())
            .toList();

        DialogRouter.displayProgressDialog(context);

        for (int i = 1; i < fields.length; i++) {
          if (fields[i][7] == null || fields[i][7] == "")
            continue;
          else {
            QuestionModel qMode = new QuestionModel(
              category: "${fields[i][0]}".trim(),
              question: "${fields[i][1]}".trim(),
              option1: "${fields[i][2]}".trim(),
              option2: "${fields[i][3]}".trim(),
              option3: "${fields[i][4]}".trim(),
              option4: "${fields[i][5]}".trim(),
              option5: "${fields[i][6]}".trim(),
              answer: "${fields[i][7]}".trim(),
              description: "${fields[i][8]}".trim(),
            );
            fireStoreInstance
                .collection(FireBaseCollectionNames.questionAnswer)
                .doc(qMode.questionId)
                .set(qMode.toJson());
          }
        }
        DialogRouter.closeProgressDialog(context);
        FlutterToast.showSuccess(
            message: "Upload successful", context: context);
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: AllQuestions()));
      }
    } catch (e) {
      FlutterToast.showErrorToast(message: "Upload failed", context: context);
    }
  }

  passManualQuestion() {
    QuestionModel qMode = new QuestionModel(
      category: "${widget.title}".trim(),
      question: "${questionController.text}".trim(),
      option1: "${optionAController.text}".trim(),
      option2: "${optionBController.text}".trim(),
      option3: "${optionCController.text}".trim(),
      option4: "${optionDController.text}".trim(),
      option5: "${optionEController.text}".trim(),
      answer: "$correctAns".trim(),
      description: "${descriptionController.text}".trim(),
    );
    if (qMode.answer == null) return;
    fireStoreInstance
        .collection("questionAnswer")
        .doc(qMode.questionId)
        .set(qMode.toJson())
        .then((value) {
      // print(value.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      backgroundColor: Color(0xFFFDF5F5),

      body: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 270,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                            color: Colors.black12)
                      ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 10,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 5,
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
                              widget.title,
                              style: TextStyle(
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: () {
                                pickFile();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              color: Colors.indigoAccent,
                              child: Text(
                                '+ CSV',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                        child: PageView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          controller: controller,
                          itemCount: 6,
                          onPageChanged: (index) {
                            currentIndex = index;
                            setState(() {});
                          },
                          itemBuilder: (context, i) => Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...Iterable.generate(
                                  6,
                                  (i) => Container(
                                    //   color: Colors.green,
                                    width: 36,
                                    child: Visibility(
                                      visible: i == currentIndex,
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "${i}",
                                            style: TextStyle(
                                              color: Color(0xFFFD5959),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: controller,
                        count: 6,
                        axisDirection: Axis.horizontal,
                        effect: ExpandingDotsEffect(
                            expansionFactor: 1.2,
                            spacing: 8.0,
                            radius: 4.0,
                            dotWidth: 28.0,
                            dotHeight: 5.0,
                            paintStyle: PaintingStyle.fill,
                            dotColor: Color(0xFFF1F1F1),
                            activeDotColor: Color(0xFFFD5959)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question 1',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w900),
                              //WeightHeavy
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: questionController,
                              textInputAction: TextInputAction.next,
                              focusNode: questionNode,
                              onFieldSubmitted: (term) {
                                allUnFocus();
                                FocusScope.of(context).requestFocus(aNode);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'cannot be empty';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF0C1A35),
                                  fontWeight: FontWeight.w500),
                              //WeightHeavy
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 20),
                      padding:
                          const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: Card(
                        shape: ansA
                            ? RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color(0xffFD5959), width: 1.0),
                                borderRadius: BorderRadius.circular(15.0),
                              )
                            : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                        elevation: 10,
                        shadowColor: Colors.black26,
                        child: ListTile(
                          leading: Text(
                            "A.",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          title: TextFormField(
                            controller: optionAController,
                            textInputAction: TextInputAction.next,
                            focusNode: aNode,
                            onFieldSubmitted: (term) {
                              allUnFocus();
                              FocusScope.of(context).requestFocus(bNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'cannot be empty';
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: InkWell(
                            radius: 10,
                            onTap: () {
                              setState(() {
                                correctAns = optionAController.text;
                                ansA = true;
                                ansB = false;
                                ansC = false;
                                ansD = false;
                                ansE = false;
                              });
                            },
                            child: Container(
                                decoration: ansA
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffFD5959))
                                    : BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffF1F1F1)),
                                child: Icon(
                                  Icons.check,
                                  size: 25.0,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 20),
                      padding:
                          const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: Card(
                        shape: ansB
                            ? RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color(0xffFD5959), width: 1.0),
                                borderRadius: BorderRadius.circular(15.0),
                              )
                            : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                        elevation: 10,
                        shadowColor: Colors.black26,
                        child: ListTile(
                          leading: Text(
                            "B.",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          title: TextFormField(
                            controller: optionBController,
                            textInputAction: TextInputAction.next,
                            focusNode: bNode,
                            onFieldSubmitted: (term) {
                              allUnFocus();
                              FocusScope.of(context).requestFocus(cNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'cannot be empty';
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: InkWell(
                            radius: 10,
                            onTap: () {
                              setState(() {
                                correctAns = optionBController.text;
                                ansA = false;
                                ansB = true;
                                ansC = false;
                                ansD = false;
                                ansE = false;
                              });
                            },
                            child: Container(
                                decoration: ansB
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffFD5959))
                                    : BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffF1F1F1)),
                                child: Icon(
                                  Icons.check,
                                  size: 25.0,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 20),
                      padding:
                          const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: Card(
                        shape: ansC
                            ? RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color(0xffFD5959), width: 1.0),
                                borderRadius: BorderRadius.circular(15.0),
                              )
                            : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                        elevation: 10,
                        shadowColor: Colors.black26,
                        child: ListTile(
                          leading: Text(
                            "C.",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          title: TextFormField(
                            controller: optionCController,
                            textInputAction: TextInputAction.next,
                            focusNode: cNode,
                            onFieldSubmitted: (term) {
                              allUnFocus();
                              FocusScope.of(context).requestFocus(dNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'cannot be empty';
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: InkWell(
                            radius: 10,
                            onTap: () {
                              setState(() {
                                correctAns = optionCController.text;
                                ansA = false;
                                ansB = false;
                                ansC = true;
                                ansD = false;
                                ansE = false;
                              });
                            },
                            child: Container(
                                decoration: ansC
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffFD5959))
                                    : BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffF1F1F1)),
                                child: Icon(
                                  Icons.check,
                                  size: 25.0,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 20),
                      padding:
                          const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: Card(
                        shape: ansD
                            ? RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color(0xffFD5959), width: 1.0),
                                borderRadius: BorderRadius.circular(15.0),
                              )
                            : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                        elevation: 10,
                        shadowColor: Colors.black26,
                        child: ListTile(
                          leading: Text(
                            "D.",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          title: TextFormField(
                            controller: optionDController,
                            textInputAction: TextInputAction.next,
                            focusNode: dNode,
                            onFieldSubmitted: (term) {
                              allUnFocus();
                              FocusScope.of(context).requestFocus(eNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'cannot be empty';
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: InkWell(
                            radius: 10,
                            onTap: () {
                              setState(() {
                                correctAns = optionDController.text;
                                ansA = false;
                                ansB = false;
                                ansC = false;
                                ansD = true;
                                ansE = false;
                              });
                            },
                            child: Container(
                                decoration: ansD
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffFD5959))
                                    : BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffF1F1F1)),
                                child: Icon(
                                  Icons.check,
                                  size: 25.0,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 20),
                      padding:
                          const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: Card(
                        shape: ansE
                            ? RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Color(0xffFD5959), width: 1.0),
                                borderRadius: BorderRadius.circular(15.0),
                              )
                            : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                        elevation: 10,
                        shadowColor: Colors.black26,
                        child: ListTile(
                          leading: Text(
                            "E.",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          title: TextFormField(
                            controller: optionEController,
                            textInputAction: TextInputAction.next,
                            focusNode: eNode,
                            onFieldSubmitted: (term) {
                              allUnFocus();
                              FocusScope.of(context)
                                  .requestFocus(descriptionNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'cannot be empty';
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: InkWell(
                            radius: 10,
                            onTap: () {
                              setState(() {
                                correctAns = optionEController.text;
                                ansA = false;
                                ansB = false;
                                ansC = false;
                                ansD = false;
                                ansE = true;
                              });
                            },
                            child: Container(
                                decoration: ansE
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffFD5959))
                                    : BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffF1F1F1)),
                                child: Icon(
                                  Icons.check,
                                  size: 25.0,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 20),
                      padding:
                          const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        shadowColor: Colors.black26,
                        child: ListTile(
                          leading: Text(
                            "Description.",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                          title: TextFormField(
                            controller: descriptionController,
                            textInputAction: TextInputAction.done,
                            focusNode: descriptionNode,
                            onFieldSubmitted: (term) {
                              allUnFocus();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'cannot be empty';
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45, right: 30),
                  child: QuestionNextButton(
                    text: 'Add Question',
                    backGroundColor: Color(0xFFFD5959),
                    onPress: () {
                      if (_formKey.currentState.validate() &&
                          correctAns != null &&
                          correctAns != '') {
                        passManualQuestion();

                        optionAController.clear();
                        optionBController.clear();
                        optionCController.clear();
                        optionDController.clear();
                        optionEController.clear();
                        descriptionController.clear();
                        questionController.clear();
                        correctAns = '';

                        FlutterToast.showSuccess(
                            message: "Question Added", context: context);
                        setState(() {
                          ansA = false;
                          ansB = false;
                          ansC = false;
                          ansD = false;
                          ansE = false;
                        });
                      } else {
                        FlutterToast.showErrorToast(
                            context: context,
                            message: 'check All fields please');
                      }

                      // controller.nextPage(
                      //     duration: Duration(microseconds: 100),
                      //     curve: Cubic(0.42, 0.0, 1.0, 1.0));
                      //
                      // if (currentIndex == 5)
                      //   Navigator.pushNamed(
                      //       context, ScoreAnsExplanationScreen.id);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        Container(),
        ForumScreen(),
      ][currentIndex2],
      // bottomNavigationBar: BottomNavyBar(
      //   containerHeight: 90,
      //   selectedIndex: currentIndex2,
      //   showElevation: true,
      //   itemCornerRadius: 50,
      //   curve: Curves.easeInBack,
      //   onItemSelected: (index) => setState(() {
      //     currentIndex2 = index;
      //     if (currentIndex2 == 1) {
      //       Navigator.pushReplacementNamed(context, PostAQuestionScreen.id);
      //     }
      //     /* if (currentIndex2 == 2) {
      //       Navigator.pushReplacementNamed(context, ForumScreen.id);
      //     }*/
      //   }),
      //   items: [
      //     BottomNavyBarItem(
      //       icon: Icon(FlutterNevBarIcons.home),
      //       title: Text(
      //         'Home',
      //         // style: TextStyle(),
      //       ),
      //       activeColor: Color(0xFFFD5959),
      //       textAlign: TextAlign.center,
      //     ),
      //     BottomNavyBarItem(
      //       icon: Icon(FlutterNevBarIcons.chat),
      //       title: Text('Questions'),
      //       activeColor: Color(0xFFFD5959),
      //       textAlign: TextAlign.center,
      //     ),
      //     BottomNavyBarItem(
      //       icon: Icon(FlutterNevBarIcons.group),
      //       title: Text(
      //         'Forum ',
      //       ),
      //       activeColor: Color(0xFFFD5959),
      //       textAlign: TextAlign.center,
      //     ),
      //   ],
      // ),
    );
  }
}
