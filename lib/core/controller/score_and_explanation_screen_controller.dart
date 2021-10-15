import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:get/state_manager.dart';

class ScoreAnsExplanationScreenController extends GetxController {
  ScoreAnsExplanationScreenController(List<QuestionModel> questionList) {
    this.questionModelList = questionList;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    print("user answer List" + "${questionModelList?.length}");
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  get allAnswerListLen => questionModelList?.length ?? 0;

  String getCategoryName() {
    try {
      return questionModelList[0].category.toString();
    } catch (e) {
      return "";
    }
  }

  double getPercentage() {
    try {
      return (correctAnswerListLen / allAnswerListLen);
    } catch (e) {
      return 0.0;
    }
  }

  get correctAnswerListLen =>
      questionModelList
          ?.where((element) =>
              element.getAnswer(element?.userAnswer) == element?.answer)
          ?.toList()
          ?.length ??
      0;
  List<QuestionModel> questionModelList = new List<QuestionModel>();
}
