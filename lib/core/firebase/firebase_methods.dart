import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/firebase_storage_method.dart';
import 'package:critical_x_quiz/core/initial_db_method/registration_initial_db.dart';
import 'package:critical_x_quiz/core/model/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app_data.dart';
import 'app_methods.dart';
import 'firebase_message.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class FirebaseMethods implements AppMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<String> logInUser({String email, String password}) async {
    User user;

    try {
      user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      print("User email ::::::::");
      print(user.email);
      //ConstantData.uid = user.uid;
    } catch (e) {
      print('login -----');
      print(e.runtimeType);

      if (e is FirebaseAuthException) {
        print('login -----');
        return fireBaseErrorMessageMethod(e);
      }

      if (e is PlatformException) {
        print("FireBase Error Code ::::::::::::::: ");
        print(e.code);
        print('login -----');

        if (e.code == 'ERROR_INVALID_EMAIL') {
          return errorMSG(
              "We didn’t find any account with this mail, Please Signup  ");
        }
        if (e.code == 'ERROR_USER_NOT_FOUND') {
          return errorMSG(
              "We didn’t find any account with this mail, Please Signup  ");
        }

        if (e.code == 'ERROR_WRONG_PASSWORD') {
          return errorMSG(
              "Your password is wrong, please give the correct one ");
        }
      }
      print(e);
      return errorMSG(e.toString());
    }

    return user == null ? errorMSG("Error") : successfulMSG();
  }

  Future<bool> complete() async {
    return true;
  }

  Future<bool> notComplete() async {
    return false;
  }

  Future<String> successfulMSG() async {
    return AppData.successful;
  }

  Future<String> errorMSG(String e) async {
    return e;
  }

  @override
  Future<bool> logOutUser() async {
    await auth.signOut();
    return complete();
  }

  Future getFirebaseCurrentUser() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    return firebaseUser;
  }

  Future<DocumentSnapshot> getUserInfo(String userId) async {
    return await firestore.collection(AppData.usersData).doc(userId).get();
  }

  Future<String> firebaseResetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return AppData.successful;
    } catch (e) {
      if (e is PlatformException) {
        print("FireBase Error Code ::::::::::::::: ");
        print(e.code);

        if (e.code == 'ERROR_INVALID_EMAIL') {
          return errorMSG("We didn’t find any account with this mail. ");
        }
        if (e.code == 'ERROR_USER_NOT_FOUND') {
          return errorMSG("We didn’t find any account with this mail. ");
        }

        return e.toString();
      }
      print("FireBase ResetPassword Execption ::::::::::::::: ");
      print(e);
      return e.toString();
    }
  }

  void insertDataToFireStore(String collectionName, Map data) {
    FirebaseFirestore.instance.collection(collectionName).doc().set(data);
  }

  Future updateDataToFireStore(
      String collectionName, String document, Map data) async {
    return await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(document)
        .update(data);
  }

  @override
  Future<String> createUserAccount({
    String email,
    String password,
    String name,
  }) async {
    User user;
    try {
      user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      await user.updateProfile(
        displayName: name,
      );

      return saveUser(
        user,
        userId: user?.uid,
        password: password,
        name: name,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('login -----');
        return fireBaseErrorMessageMethod(e);
      }

      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          print("succcess fully tested error:::::::::::");
          return errorMSG("Email is already in used");
        }
      }
      print(e.details);
      return errorMSG(e.details);
    }
  }

  Future<String> saveUser(
    User user, {

    /// only for development purpose
    /// todo must be remove before production.
    String password,
    String name,
    String userId,
  }) async {
    try {
      await firestore.collection(AppData.usersData).doc(user.uid).set({
        'email': user?.email ?? "",
        'uid': user?.uid ?? '',
        'fullName': user?.displayName ?? '$name',
        'password': password ?? null,
        'UserID': userId ?? null,
        'proPic': null,
        'admin': false,
        'bannedUser': false,
      });

      UserInitialDB.initial(user?.uid ?? '');

      return AppData.successful;
    } catch (e) {
      return AppData.error;
    }
  }

  /// firebase auth error message
  ///todo implement any custom message here
  ///
  String fireBaseErrorMessageMethod(FirebaseAuthException e) {
    String errorType;
    if (Platform.isAndroid) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = FireBaseMessage.userNotFound;
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = FireBaseMessage.passwordNotValid;
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = FireBaseMessage.networkError;
          break;
        // ...
        default:
          errorType = e.message;
          print('Case ${e.message} is not yet implemented');
      }
    } else if (Platform.isIOS) {
      switch (e.code) {
        case 'Error 17011':
          errorType = FireBaseMessage.userNotFound;
          break;
        case 'Error 17009':
          errorType = FireBaseMessage.passwordNotValid;
          break;
        case 'Error 17020':
          errorType = FireBaseMessage.networkError;
          break;
        // ...
        default:
          errorType = e.message;
          print('Case ${e.message} is not yet implemented');
      }
    }
    //print('The error is $errorType');
    errorType = e.message;
    return errorType;
  }

  Future<bool> deleteUser() async {
    try {
      User user = FirebaseAuth.instance.currentUser;

      if (GetUtils.isURL(user.photoURL)) {
        FireBaseFileStorage.deleteFile(user.photoURL);
      }
      DocumentSnapshot dp =
          await firestore.collection(AppData.usersData).doc(user.uid).get();
      UserModel model = new UserModel.fromDoc(dp);
      model?.delete();
      await user?.delete();
      return complete();
    } catch (e, t) {
      print(t);
      return notComplete();
    }
  }
}
