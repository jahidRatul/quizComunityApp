import 'package:cloud_firestore/cloud_firestore.dart';

import '../fire_base_collection_name.dart';

class CategoryCollection {
  static Stream getAllCategoryListener() {
    return FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.categoryCollection)
        .snapshots();
  }

  static getCategory(String title) async {
    return await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.categoryCollection)
        .doc(title)
        .get();
  }
}
