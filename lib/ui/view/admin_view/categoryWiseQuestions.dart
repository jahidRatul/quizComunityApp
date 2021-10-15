import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/model/categoty_model/categoryModel.dart';
import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:flutter/material.dart';

class CategoryWiseQuestions extends StatefulWidget {
  final CategoryModel model;

  CategoryWiseQuestions({this.model});

  @override
  _CategoryWiseQuestionsState createState() => _CategoryWiseQuestionsState();
}

class _CategoryWiseQuestionsState extends State<CategoryWiseQuestions> {
  List<QuestionModel> questionList = new List<QuestionModel>();
  StreamSubscription listen;

  List<QuestionModel> searchedList = new List<QuestionModel>();
  TextEditingController searchController = new TextEditingController();

  search(String pattern) {
    searchedList = questionList
        .where((element) =>
            element.question.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
    setState(() {});
  }

  getQuestion() {
    listen = FirebaseFirestore.instance
        .collection('questionAnswer')
        .where('category', isEqualTo: widget.model.title)
        .snapshots()
        .listen((event) {
      questionList.clear();
      event.docs.forEach((element) {
        QuestionModel questionModel = QuestionModel.fromJson(element.data());
        questionList.add(questionModel);
        searchedList = questionList;

        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    listen?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    getQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.model.title),
        leading: BackButton(
          onPressed: () {
            // AppRouter.back();
            AppRouter.back();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: questionList.length <= 0
                    ? SizedBox(
                        height: 400,
                        child: Center(
                          child: Text(
                            'No Question Available',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: searchController,
                                onChanged: (v) {
                                  search(v);
                                },
                                decoration: InputDecoration(
                                  hintText: "Search",
                                ),
                                style: TextStyle(fontSize: 18),
                              ),
                              width: MediaQuery.of(context).size.width * .75,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  search(searchController.text);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: searchedList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        AppRouter.navToEditQuestion(searchedList[index]);
                        searchController.clear();
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: ListTile(
                          title: Center(
                              child: Text(
                            searchedList[index].category,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          subtitle: Center(
                              child: Text(
                            searchedList[index].question,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
