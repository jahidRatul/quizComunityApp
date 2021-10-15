import 'package:critical_x_quiz/core/controller/forum_discussion_controller.dart';
import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:get/get.dart';

class FormDiscussionBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(HomePageController());
    Get.put(ForumDiscussionController());
  }
}
