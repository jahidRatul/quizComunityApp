import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestDataPage extends StatefulWidget {
  @override
  _TestDataPageState createState() => _TestDataPageState();
}

class _TestDataPageState extends State<TestDataPage> {
  QuestionClass modelTest;

  List<QuestionClass> questionClassList = new List();

  fireBaseTest() {
    FirebaseFirestore.instance
        .collection("questionAnswer")
        .snapshots()
        .listen((event) {
      print("len: ${event.docs.length}");
      event.docs.forEach((element) {
        questionClassList.add(QuestionClass.fromJson(element.data()));
      });
      QuestionClass model = QuestionClass.fromJson(event.docs[1].data());
      modelTest = model;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FlatButton(
              onPressed: () {
                fireBaseTest();
              },
              child: Text("test button"),
            ),
            SizedBox(
              height: 20,
            ),
            Text("${modelTest?.toJson() ?? ""}"),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: questionClassList.length,
                  itemBuilder: (_, i) =>
                      Text("$i ${questionClassList[i]?.category}"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QuestionClass {
  String answer;
  String category;
  String description;
  String option1;
  String option2;
  String option3;
  String option4;
  String option5;
  String question;

  QuestionClass.fromJson(Map<String, dynamic> json) {
    this.answer = json['answer'];
    this.category = json['category'];
    this.description = json['description'];
    this.option1 = json['option1'];
    this.option2 = json['option2'];
    this.option3 = json['option3'];
    this.option4 = json['option4'];
    this.option5 = json['option5'];
    this.question = json['question'];
  }

  toJson() {
    Map<String, dynamic> json = new Map();
    json['answer'] = this.answer;
    json['category'] = this.category;
    json['description'] = this.description;
    json['option1'] = this.option1;
    json['option2'] = this.option2;
    json['option3'] = this.option3;
    json['option4'] = this.option4;
    json['option5'] = this.option5;
    json['question'] = this.question;

    return json;
  }

  QuestionClass({
    this.answer,
    this.category,
    this.description,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.option5,
    this.question,
  });
}
