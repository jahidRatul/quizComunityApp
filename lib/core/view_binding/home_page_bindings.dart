import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:get/get.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    print("home page binging **");
    //Get.lazyPut<HomePageController>(() => HomePageController());
    // Get.lazyPut<HomePageController>(() => HomePageController());

    Get.put(HomePageController());
  }
}
