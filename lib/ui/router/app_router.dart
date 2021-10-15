import 'dart:io';

import 'package:critical_x_quiz/core/model/categoty_model/categoryModel.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_model.dart';
import 'package:critical_x_quiz/core/model/questionModel/question_model.dart';
import 'package:critical_x_quiz/core/view_binding/forumDiscussionBindings.dart';
import 'package:critical_x_quiz/core/view_binding/home_page_bindings.dart';
import 'package:critical_x_quiz/core/view_binding/post_a_question_bindings.dart';
import 'package:critical_x_quiz/core/view_binding/profile_page_binding.dart';
import 'package:critical_x_quiz/core/view_binding/question_screen_binding.dart';
import 'package:critical_x_quiz/core/view_binding/score_and_explanation_screen_bindings.dart';
import 'package:critical_x_quiz/ui/view/admin_view/categoryWiseQuestions.dart';
import 'package:critical_x_quiz/ui/view/admin_view/edit_question.dart';
import 'package:critical_x_quiz/ui/view/admin_view/selectEditQuestionByCategory.dart';
import 'package:critical_x_quiz/ui/view/forum/forumDiscussion.dart';
import 'package:critical_x_quiz/ui/view/home/checkAnsExplanationScreen.dart';
import 'package:critical_x_quiz/ui/view/home/homeScreen.dart';
import 'package:critical_x_quiz/ui/view/home/scoreAnsExplanationScreen.dart';
import 'package:critical_x_quiz/ui/view/post_a_question/postAQuestionScreen.dart';
import 'package:critical_x_quiz/ui/view/profile/ProfileScreen.dart';
import 'package:critical_x_quiz/ui/view/question_screen/questionScreen.dart';
import 'package:critical_x_quiz/ui/view/screen/authScreen/AuthContainer.dart';
import 'package:get/get.dart';

class AppRouter {
  static back({dynamic result}) {
    return Get.back(result: result);
  }

  static exitApp() {
    exit(0);
  }

  static navToAuthController() {
    return Get.off(AuthContainer());
  }

  static navToHomePage({int initialIndex = 0}) {
    return Get.offAll(
      HomeScreen(initialIndex: initialIndex),
      transition: Transition.fadeIn,
      binding: HomePageBinding(),
    );
  }

  static navToPostAQuestion() {
    return Get.offAll(
      PostAQuestionScreen(),
      transition: Transition.fadeIn,
      binding: PostAQuestionBindings(),
    );
  }

  static navToForumDiscussion(FormPostModel model) {
    return Get.to(
      ForumDiscussion(model),
      transition: Transition.fadeIn,
      binding: FormDiscussionBindings(),
    );
  }

  // static Future navToAnswerReply(
  //     FormPostAnswerModel model, FormPostModel formPostModel, int index) async {
  //   return await Get.to(
  //     AnswerReplyPage(model, formPostModel, index),
  //     transition: Transition.fadeIn,
  //     binding: FormDiscussionBindings(),
  //   );
  // }

  static navToProfileScreen() {
    return Get.to(
      ProfileScreen(),
      transition: Transition.fadeIn,
      binding: ProfileScreenBinding(),
    );
  }

  static navToQuestionScreen(CategoryModel model) async {
    return await Get.to(
      QuestionScreen(model),
      transition: Transition.fadeIn,
      binding: QuestionScreenBindings(model.title),
    );
  }

  static navToScoreAnsExplanationScreen(List<QuestionModel> questionModelList) {
    return Get.off(
      ScoreAnsExplanationScreen(),
      transition: Transition.fadeIn,
      binding: ScoreAndExplanationBindings(questionModelList),
    );
  }

  static navToCheckAnsExplanationScreen(List<QuestionModel> questionList) {
    return Get.off(
      CheckAnsExplanationScreen(questionList),
      transition: Transition.fadeIn,
      //  binding: QuestionScreenBindings(),
    );
  }

  static navToEditQuestion(QuestionModel questionModel) {
    return Get.to(
      EditQuestion(
        questionModel: questionModel,
      ),
      transition: Transition.fadeIn,
    );
  }

  static navToEditQuestionByCategory() {
    return Get.to(
      SelectEditQuestionByCategory(),
      transition: Transition.fadeIn,
    );
  }

  static navToCategoryWiseQuestions(CategoryModel model) {
    return Get.to(
      CategoryWiseQuestions(
        model: model,
      ),
      transition: Transition.fadeIn,
    );
  }
}
