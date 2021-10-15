import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';

class QuestionAnswerCollection {
  static Future<QuerySnapshot> getAllQuestion() async {
    return await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.questionAnswer)
        .get();
  }

  static Future<QuerySnapshot> searchQuestionByCategory(String category) async {
    return await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.questionAnswer)
        .where('category', isEqualTo: category)
        .get();
  }
}
