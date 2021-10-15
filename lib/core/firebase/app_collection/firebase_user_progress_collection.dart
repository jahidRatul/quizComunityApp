import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/model/user_progress_model/user_progress_model.dart';

class FireBaseUserProgress {
  static initCollection(String uid) {
    UserProgressModel model = new UserProgressModel(
      categoryTitleList: [],
      progressId: "$uid",
      categoryInfoList: [],
    );
    return FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.userProgress)
        .doc(uid)
        .set(model.toJson());
  }

  static deleteCollection(String uid) {
    return FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.userProgress)
        .doc(uid)
        .delete();
  }

  static Future<DocumentSnapshot> getUserProgressModel(String uid) async {
    return await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.userProgress)
        .doc(uid)
        .get();
  }

  static updateUserProgress(UserProgressModel model) async {
    return await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.userProgress)
        .doc(model.progressId)
        .update(model.toJson());
  }

  static Stream<DocumentSnapshot> userProgressListenner(String uid) {
    return FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.userProgress)
        .doc(uid)
        .snapshots();
  }
}
