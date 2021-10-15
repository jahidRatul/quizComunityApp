import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/firebase/firebase_storage_method.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_model.dart';

class ForumPostCollection {
  static getAllDataListener() {
    return FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.formPostCollection)
        .snapshots();
  }

  static Future updateForumPostData(FormPostModel model) {
    return FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.formPostCollection)
        .doc(model.postId)
        .update(model.toJson());
  }

  static Future forumPostDataDelete(FormPostModel model) async {
    model?.imageList?.forEach((element) {
      FireBaseFileStorage.deleteFile(element.toString());
    });
    return await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.formPostCollection)
        .doc(model.postId)
        .delete();
  }
}
