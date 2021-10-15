import 'package:cloud_firestore/cloud_firestore.dart';

class AppUtils {
  static String timeAgo(Timestamp timestamp) {
    final birthday = DateTime.parse(timestamp.toDate().toString());

    print("time stamp ${timestamp.toDate()}");
    // print("birthday ${birthday}");
    // final birthday = DateTime(1967, 10, 12);
    final date2 = DateTime.now();
    //final difference = date2.difference(birthday).inMinutes;

    if (date2.difference(birthday).inDays > 0) {
      final difference = date2.difference(birthday).inDays;
      return "$difference days ago";
    } else if (date2.difference(birthday).inHours > 0) {
      final difference = date2.difference(birthday).inHours;
      return "$difference hours ago";
    } else {
      final difference = date2.difference(birthday).inMinutes;
      return "$difference minute ago";
    }
  }
}
