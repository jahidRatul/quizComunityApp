import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:get/get.dart';

class QuestionModel {
  String category;
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String option5;
  String answer;
  String description;
  String questionId;
  String userAnswer;

  QuestionModel({
    this.category,
    this.question,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.option5,
    this.answer,
    this.description,
    this.userAnswer,
  }) {
    try {
      this.questionId = this?.category.toString() +
          this?.question?.hashCode?.toString() +
          this?.description?.hashCode?.toString() +
          this?.answer?.hashCode.toString();
    } catch (e) {}
  }

  getAnswer(String answer) {
    if (answer.isNullOrBlank) return "@\$#^\$#@%^^";
    return this.toJson()['$answer'];
  }

  QuestionModel.fromJson(Map<String, dynamic> json) {
    this.category = json['category'];
    this.question = json['question'];
    this.option1 = json['option1'];
    this.option2 = json['option2'];
    this.option3 = json['option3'];
    this.option4 = json['option4'];
    this.option5 = json['option5'];
    this.answer = json['answer'];
    this.description = json['description'];
    this.questionId = json['questionId'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = new Map();
    json['category'] = this.category;
    json['question'] = this.question;
    json['option1'] = this.option1;
    json['option2'] = this.option2;
    json['option3'] = this.option3;
    json['option4'] = this.option4;
    json['option5'] = this.option5;
    json['answer'] = this.answer;
    json['description'] = this.description;
    json['questionId'] = this.questionId;
    return json;
  }

  delete() async {
    return await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.questionAnswer)
        .doc(this.questionId)
        .delete();
  }

  save() async {
    return await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.questionAnswer)
        .doc(this.questionId)
        .set(this.toJson());
  }
}
