import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/controller/question_screen_controller.dart';
import 'package:get/get.dart';

class QuestionScreenBindings extends Bindings {
  String category;

  QuestionScreenBindings(this.category);

  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.put(QuestionScreenController(category: category));
    Get.put(HomePageController());
  }
}
