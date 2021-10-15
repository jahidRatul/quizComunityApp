import 'package:critical_x_quiz/core/firebase/app_collection/firebase_user_progress_collection.dart';

class UserInitialDB {
  static initial(String uid) {
    FireBaseUserProgress.initCollection(uid);
  }
}
