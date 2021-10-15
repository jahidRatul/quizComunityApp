import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:flutter/material.dart';

class QuestionExplanationView extends StatefulWidget {
  final QuestionModel model;

  final Function popCallBack;

  QuestionExplanationView(
    this.model, {
    this.popCallBack,
  });

  @override
  _QuestionExplanationViewState createState() =>
      _QuestionExplanationViewState();
}

class _QuestionExplanationViewState extends State<QuestionExplanationView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFDF5F5),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 190,
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
                                flex: 3,
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 20
                                        // vertical: 20,
                                        // horizontal: 0,
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
                                            widget?.popCallBack?.call();
                                            //Navigator.pop(context);
                                          }),
                                    )),
                              ),
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 18,
                                    ),
                                    Text(
                                      'Answers & Explanation',
                                      style: TextStyle(
                                        color: Color(0xFF0C1A35),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget?.model?.category ?? ""}',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900),
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
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20),
                          child: Text(
                            'Selected Answer',
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          // padding: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20),
                          child: Card(
                            shape: widget.model
                                        .getAnswer(widget.model.userAnswer) ==
                                    widget.model.answer
                                ? RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color(0xFF25AFA2), width: 1.0),
                                    borderRadius: BorderRadius.circular(15.0),
                                  )
                                : RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color(0xffFD5959), width: 1.0),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                            elevation: 10,
                            shadowColor: Colors.black26,
                            child: ListTile(
                                // leading: Text(
                                //   "A.",
                                //   style: TextStyle(
                                //       fontSize: 15,
                                //       color: Color(0xFF0C1A35),
                                //       fontWeight: FontWeight.w600),
                                // ),
                                title: Text(
                                  " ${widget.model.getAnswer(widget.model.userAnswer)}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF0C1A35),
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing: InkWell(
                                  radius: 10,
                                  onTap: () {},
                                  child: Container(
                                      decoration: widget.model.getAnswer(
                                                  widget.model.userAnswer) ==
                                              widget.model.answer
                                          ? BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF25AFA2))
                                          : BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffFD5959)),
                                      child: Icon(
                                        Icons.check,
                                        size: 25.0,
                                        color: Colors.white,
                                      )),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20),
                          child: Text(
                            'Correct Answer',
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          // padding: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color(0xFF25AFA2), width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            shadowColor: Colors.black26,
                            color: Color(0xFF25AFA2),
                            child: ListTile(
                                title: Text(
                                  '${widget?.model?.answer ?? ''}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF0C1A35),
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing: InkWell(
                                  radius: 10,
                                  onTap: () {},
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Icon(
                                        Icons.check,
                                        size: 25.0,
                                        color: Color(0xFF25AFA2),
                                      )),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20),
                          child: Text(
                            'Explanation',
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20),
                          child: Text(
                            '${widget?.model?.description ?? ''}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF0C1A35),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
