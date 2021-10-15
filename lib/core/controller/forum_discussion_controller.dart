import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/firebase/app_collection/form_post_collection.dart';
import 'package:critical_x_quiz/core/firebase/app_data.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_answer_model.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_model.dart';
import 'package:critical_x_quiz/core/model/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ForumDiscussionController extends GetxController {
  HomePageController homePageController = Get.put(HomePageController());

  Future onCommentSubmit(String comment, FormPostModel model) async {
    User user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot dp = await FirebaseFirestore.instance
        .collection(AppData.usersData)
        .doc(user.uid)
        .get();
    UserModel userModel = UserModel.fromDoc(dp);

    FormPostAnswerModel answer = FormPostAnswerModel(
      postTime: Timestamp.now(),
      authorUid: user.uid,
      authorName: userModel.fullName,
      answerDescription: comment,
      isCorrect: false,
      pointUserId: new List<String>(),
      answerId: 1,
      replyList: [],
      upPoints: 0,
      downPoints: 0,
    );

    model?.answeredList?.add(answer);
    return ForumPostCollection.updateForumPostData(model);
  }

  Future onCommentReplySubmit(FormPostModel model) async {
    return ForumPostCollection.updateForumPostData(model);
  }

  Future updateAnswerLike(int index, FormPostModel model) {
    User user = FirebaseAuth.instance.currentUser;
    if (index >= model.answeredList.length) {
      return null;
    }

    if ((model?.answeredList[index]?.likePointUserId
            ?.contains(user.uid.toString())) ??
        false) {
      model.answeredList[index].likePointUserId?.remove(user.uid.toString());

      // Get.snackbar("Can't Give Like", "you Already liked the post");
      return null;
    } else {
      if ((model?.answeredList[index]?.dislikePointUserId
              ?.contains(user.uid.toString())) ??
          false) {
        model.answeredList[index].dislikePointUserId
            ?.remove(user.uid.toString());
      }

      model.answeredList[index].likePointUserId?.add(user.uid.toString());

      return ForumPostCollection.updateForumPostData(model);
    }
  }

  Future updateAnswerDisLike(int index, FormPostModel model) {
    User user = FirebaseAuth.instance.currentUser;
    if (index >= model.answeredList.length) {
      return null;
    }

    if ((model?.answeredList[index]?.dislikePointUserId
            ?.contains(user.uid.toString())) ??
        false) {
      model.answeredList[index].dislikePointUserId?.remove(user.uid.toString());
      // Get.snackbar("Can't Give DisLike", "you Already Dislike this answer");
      return null;
    } else {
      if ((model?.answeredList[index]?.likePointUserId
              ?.contains(user.uid.toString())) ??
          false) {
        model.answeredList[index].likePointUserId?.remove(user.uid.toString());
      }

      model.answeredList[index].dislikePointUserId?.add(user.uid.toString());
      // model.answeredList[index].upPoints = upPoints;
      // model.answeredList[index].downPoints = downPoints;
      return ForumPostCollection.updateForumPostData(model);
    }
  }

  Future updateAnswerIsCorrect(int index, bool isCorrect, FormPostModel model) {
    User user = FirebaseAuth.instance.currentUser;
    if (model?.authorUid?.toString() == user?.uid?.toString() ||
        homePageController.isAdminUser.value == true) {
      print(" answer update ");

      model?.setCorrectAns(index, isCorrect);
      model?.isAnswered = model?.getIsThereAnyCorrectAns();

      // model.answeredList[index]?.isCorrect = isCorrect;
      return ForumPostCollection.updateForumPostData(model);
    } else {
      print(" answer update  false");
      return null;
    }
  }

  answerDelete(int index, FormPostModel model) {
    if (homePageController.isAdminUser.value == true ||
        model.authorUid == homePageController.currentUserModel.uid ||
        model.answerAt(index).authorUid ==
            homePageController.currentUserModel.uid) {
      if ((model?.answeredList?.length ?? 0) < index)
        return;
      else {
        model.answeredList.removeAt(index);
        model.isAnswered = model.getIsThereAnyCorrectAns();
        return ForumPostCollection.updateForumPostData(model);
      }
    } else {
      /* if ((model?.answeredList?.length ?? 0) < index)
        return;
      else {
        model.answeredList.removeAt(index);
        model.isAnswered = model.getIsThereAnyCorrectAns();
        return ForumPostCollection.updateForumPostData(model);
      }*/

      return;
    }
  }

  replyDelete(int index, int replyIndex, FormPostModel model) {
    /*if (homePageController.isAdminUser.value == true ||
        model.isPostOwner(homePageController.currentUserModel.uid) ||
        (model
                .answerAt(index)
                ?.isAnswerOwner(homePageController.currentUserModel.uid) ??
            false) ||
        (model
                .answerAt(index)
                .getReplyAt(replyIndex)
                ?.isAnswerReplyOwner(homePageController.currentUserModel.uid) ??
            false)) {

    }*/

    if ((model?.answeredList?.length ?? 0) < index)
      return;
    else {
      if ((model.answeredList[index]?.replyList?.length ?? 0) < replyIndex) {
        return;
      } else {
        model.answeredList[index]?.replyList?.removeAt(replyIndex);
        return ForumPostCollection.updateForumPostData(model);
      }
    }
  }
}
