import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

class QuestionView extends StatefulWidget {
  final PageController controller;
  final QuestionModel model;
  final Function(String) userAnswer;

  QuestionView({
    this.controller,
    this.model,
    this.userAnswer,
  });

  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  int currentIndex = 0;
  int currentIndex2 = 0;

  // final PageController controller = PageController(viewportFraction: 0.8);

  bool ansA = false;
  bool ansB = false;
  bool ansC = false;
  bool ansD = false;
  bool ansE = false;

  List<bool> answerList = [...Iterable.generate(5, (i) => false)];

  answerListClear() {
    for (int i = 0; i < 5; i++) {
      answerList[i] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 255,
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
                  Container(
                    color: Colors.white,
                    height: 1,
                    width: wp(100),
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
                          '${widget?.model?.category}',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w900),
                          //WeightHeavy
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${widget?.model?.question}',
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
                ...Iterable.generate(
                  5,
                  (i) => Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 20),
                    padding:
                        const EdgeInsets.only(top: 15, left: 20, right: 20),
                    child: Card(
                      shape: '${widget?.model?.toJson()['option${i + 1}']}' ==
                              "${'${widget?.model?.getAnswer(widget?.model?.userAnswer)}'}"
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
                      child: InkWell(
                        onTap: () {
                          widget?.userAnswer?.call('option${i + 1}');
                          setState(() {
                            answerListClear();
                            answerList[i] = true;
                          });
                        },
                        child: ListTile(
                            leading: Text(
                              "${String.fromCharCode(65 + i)}.",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF0C1A35),
                                  fontWeight: FontWeight.w600),
                            ),
                            title: Text(
                              '${widget?.model?.toJson()['option${i + 1}']}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF0C1A35),
                                  fontWeight: FontWeight.w600),
                            ),
                            trailing: Container(
                                decoration:
                                    '${widget?.model?.toJson()['option${i + 1}']}' ==
                                            "${'${widget?.model?.getAnswer(widget?.model?.userAnswer)}'}"
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
                                ))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
