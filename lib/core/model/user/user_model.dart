import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/app_data.dart';
import 'package:critical_x_quiz/core/firebase/firebase_storage_method.dart';
import 'package:critical_x_quiz/core/initial_db_method/user_delete_cascade.dart';
import 'package:get/get.dart';

class UserModel {
  String userID;

  bool admin;
  bool bannedUser;

  String email;

  String fullName;

  String proPic;

  String uid;
  String password;

  UserModel({
    this.userID,
    this.admin,
    this.bannedUser,
    this.email,
    this.fullName,
    this.proPic,
    this.uid,
    this.password,
  });

  UserModel.fromDoc(DocumentSnapshot dp) {
    try {
      this.uid = dp?.get('uid');
      this.proPic = dp?.get('proPic');
      this.fullName = dp?.get('fullName');
      this.email = dp?.get('email');
      this.admin = dp?.get('admin');
      this.userID = dp?.get('UserID');
      this.bannedUser = dp?.get('bannedUser');
      this.password = dp?.get('password');
    } catch (e) {}
  }

  UserModel.fromJson(Map<String, dynamic> dp) {
    this.uid = dp['uid'];
    this.proPic = dp['proPic'];
    this.fullName = dp['fullName'];
    this.email = dp['email'];
    this.admin = dp['admin'];
    this.userID = dp['userID'];
    this.bannedUser = dp['bannedUser'];
    this.password = dp['password'];
  }

  toJson() {
    Map<String, dynamic> json = new Map();
    json['uid'] = this.uid;
    json['bannedUser'] = this.bannedUser;
    json['userID'] = this.userID;
    json['email'] = this.email;
    json['fullName'] = this.fullName;
    json['admin'] = this.admin;
    json['proPic'] = this.proPic;
    json['password'] = this.password;
    return json;
  }

  delete() async {
    try {
      if (GetUtils.isURL(this.proPic)) {
        FireBaseFileStorage.deleteFile(this.proPic);
      }
    } catch (e) {}
    try {
      UserDeleteCascade.userDeleteCascade(this.uid);
      return await FirebaseFirestore.instance
          .collection(AppData.usersData)
          .doc(this.uid)
          .delete();
    } catch (e) {}
  }
}
