import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/controller/score_and_explanation_screen_controller.dart';
import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:get/get.dart';

class ScoreAndExplanationBindings extends Bindings {
  List<QuestionModel> questionModelList;

  ScoreAndExplanationBindings(this.questionModelList);

  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.put(ScoreAnsExplanationScreenController(this.questionModelList));
    Get.put(HomePageController());
  }
}
