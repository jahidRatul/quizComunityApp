import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/app_collection/firebase_user_progress_collection.dart';
import 'package:critical_x_quiz/core/firebase/app_collection/question_answer_collection.dart';
import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:critical_x_quiz/core/model/user_progress_model/user_progress_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class QuestionScreenController extends GetxController {
  QuestionScreenController({this.category});

  String category;

  @override
  void onInit() {
    // TODO: implement onInit
    getQuestionByCategory(category);
    pullUserUserProgressFromFireBase();
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getAllQuestion() async {
    QuerySnapshot snap = await QuestionAnswerCollection.getAllQuestion();
    questionModelList.clear();
    snap.docs.forEach((element) {
      QuestionModel m = QuestionModel.fromJson(element.data());
      questionModelList.value.add(m);
    });
  }

  getQuestionByCategory(String category) async {
    QuerySnapshot snap =
        await QuestionAnswerCollection.searchQuestionByCategory(category);
    questionModelList.clear();
    loadingText.value = "No Question Available";
    snap.docs.forEach((element) {
      QuestionModel m = QuestionModel.fromJson(element.data());
      questionModelList.value.add(m);
      loadingText.value = "";
    });
  }

  setUserProgressModel() {
    User user = FirebaseAuth.instance.currentUser;
    userProgressModel = new UserProgressModel(
      progressId: user.uid.toString(),
      categoryInfoList: new List(),
      categoryTitleList: new List(),
    );
  }

  pullUserUserProgressFromFireBase() async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot dp =
        await FireBaseUserProgress.getUserProgressModel(user.uid.toString());
    userProgressModel = UserProgressModel.fromJson(dp.data());
    loading.value = false;
  }

  updateUserProgress() {
    FireBaseUserProgress.updateUserProgress(userProgressModel);
  }

  RxBool loading = true.obs;
  RxString loadingText = "loading".obs;
  UserProgressModel userProgressModel;

  RxList<QuestionModel> questionModelList = new RxList<QuestionModel>();
}
