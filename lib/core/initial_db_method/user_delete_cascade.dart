import 'package:critical_x_quiz/core/firebase/app_collection/firebase_user_progress_collection.dart';

class UserDeleteCascade {
  static userDeleteCascade(String uid) {
    FireBaseUserProgress.deleteCollection(uid);
  }
}
