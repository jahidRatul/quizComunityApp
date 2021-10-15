import 'package:critical_x_quiz/core/controller/PostAQuestionScreenController.dart';
import 'package:get/get.dart';

class PostAQuestionBindings extends Bindings {
  @override
  void dependencies() {
    print("home page binging **");
    //Get.lazyPut<HomePageController>(() => HomePageController());
    // Get.lazyPut<HomePageController>(() => HomePageController());

    Get.put(PostAQuestionScreenController());
  }
}
