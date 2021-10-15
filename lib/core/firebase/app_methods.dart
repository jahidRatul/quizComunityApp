import 'dart:async';

abstract class AppMethods {
  Future<String> logInUser({String email, String password});

  Future<String> createUserAccount({
    String email,
    String password,
  });

  Future<bool> logOutUser();
}
