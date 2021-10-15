import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_answer_model.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_answer_reply.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_model.dart';
import 'package:critical_x_quiz/core/model/user_progress_model/category_info_model.dart';
import 'package:critical_x_quiz/core/model/user_progress_model/user_progress_model.dart';
import 'package:flutter/material.dart';

class TestFormPostPage extends StatefulWidget {
  @override
  _TestFormPostPageState createState() => _TestFormPostPageState();
}

class _TestFormPostPageState extends State<TestFormPostPage> {
  FormPostModel m;

  testFireBAseMethod() {
    FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.formPostCollection)
        .snapshots()
        .listen((event) {
      print(event.runtimeType);
      print(event.docs.first.data()['answeredList']);
      print(event.docs.first.data()['answeredList'].runtimeType);

      FormPostModel model = FormPostModel.fromJson(event.docs.first.data());
      m = model;
      print(model.toJson());

      setState(() {});
    });
  }

  testUpload() {
    print("ttt");
    FormPostModel model = FormPostModel(
      title: "title",
      authorUid: "authorUid",
      authName: "authName",
      isAnswered: false,
      postTime: Timestamp.now(),
      category: "category",
      questionDescription: "questionDescription",
      imageList: [],
      answeredList: [
        FormPostAnswerModel(
          authorUid: "authorUid2",
          answerId: 2,
          answerDescription: "answerDescription",
          authorName: "authorName",
          isCorrect: false,
          upPoints: 6,
          downPoints: 8,
          replyList: [
            FormPostAnswerReplyModel(
                authorName: "authorName",
                authorUid: "authorName",
                replyDescription: "replyDescription"),
          ],
        )
      ],
    );
    FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.formPostCollection)
        .doc(model.postId)
        .set(model.toJson());
  }

  userProgress() {
    UserProgressModel model = new UserProgressModel(
      categoryTitleList: ['1'],
      progressId: "222",
      categoryInfoList: [
        CategoryInfoModel(
            categoryTitle: "category", correctAnsIDList: ['1', '2']),
        CategoryInfoModel(
            categoryTitle: "category2", correctAnsIDList: ['4', '5']),
      ],
    );

    print(model.toJson());

    FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.userProgress)
        .doc(model.progressId)
        .set(model.toJson());
  }

  getUserProgress() {
    FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.userProgress)
        .doc("222")
        .snapshots()
        .listen((event) {
      UserProgressModel model = UserProgressModel.fromJson(event.data());
      _model = model;
      setState(() {});
    });
  }

  UserProgressModel _model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // userProgress();
  }

  String testString = "";

  testDb() async {
    try {
      DocumentSnapshot dp = await FirebaseFirestore.instance
          .collection(FireBaseCollectionNames.categoryCollection)
          .doc("fgf")
          .get();
      print("data :: ${dp.data()}");
      //testString = dp.data()['title'] ?? "no data";
      setState(() {});
    } catch (e) {
      print("error  ::" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              FlatButton(
                onPressed: () {
                  // getUserProgress();
                  testDb();
                },
                child: Text("test button"),
              ),
              Text("${testString.toLowerCase()}"),
            ],
          ),
        ),
      ),
    );
  }
}
