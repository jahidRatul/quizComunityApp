import 'package:critical_x_quiz/core/controller/auth_controller.dart';
import 'package:critical_x_quiz/core/tools/flutter_toast.dart';
import 'package:critical_x_quiz/ui/widget/button/RoundedButton.dart';
import 'package:critical_x_quiz/ui/widget/textfield/TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  final Function onSignInPress;

  SignUpScreen({
    this.onSignInPress,
  });

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FocusNode nameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  allUnFocus() {
    nameNode.unfocus();
    emailNode.unfocus();
    passwordNode.unfocus();
    confirmPasswordNode.unfocus();
  }

  String name, email, password, confirmPassword;
  final AuthController stateController = Get.put(AuthController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  validateInput() {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    if (password == confirmPassword) {
      stateController.signUpMethod(context,
          password: password, email: email, name: name);
    } else {
      FlutterToast.showErrorToast(
          message: "password not match", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  margin: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: textInputField(
                    lebelText: "Name",
                    hintText: "Name",
                    focusNode: nameNode,
                    onSaved: (v) {
                      name = v;
                    },
                    onFieldSubmitted: (v) {
                      nameNode.unfocus();
                      emailNode.requestFocus();
                    },
                    onChanged: (value) {},
                    backcolor: Color(0xFFFBFBFB),
                    validator: (v) {
                      return v.isEmpty ? "Please insert name " : null;
                    },
                    obscureState: false,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  margin: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: textInputField(
                    lebelText: "Email",
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
                    backcolor: Color(0xFFFBFBFB),
                    focusNode: emailNode,
                    validator: (v) {
                      return v.isEmail ? null : "Please insert a valid email.";
                    },
                    onSaved: (v) {
                      email = v;
                    },
                    onFieldSubmitted: (v) {
                      emailNode.unfocus();
                      passwordNode.requestFocus();
                    },
                    obscureState: false,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  margin: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: textInputField(
                    lebelText: "Password",
                    hintText: "Enter Password",
                    onChanged: (value) {},
                    backcolor: Color(0xFFFBFBFB),
                    validator: (v) {
                      return v.length < 5 ? "Too short" : null;
                    },
                    obscureState: true,
                    focusNode: passwordNode,
                    onSaved: (v) {
                      password = v;
                    },
                    onFieldSubmitted: (v) {
                      passwordNode.unfocus();
                      confirmPasswordNode.requestFocus();
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  margin: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: textInputField(
                    lebelText: "Confirm Password",
                    hintText: "Confirm Password",
                    onChanged: (value) {},
                    backcolor: Color(0xFFFBFBFB),
                    obscureState: true,
                    focusNode: confirmPasswordNode,
                    onSaved: (v) {
                      confirmPassword = v;
                    },
                    validator: (v) {
                      return v.length < 5 ? "Too short" : null;
                    },
                    onFieldSubmitted: (v) {
                      confirmPasswordNode.unfocus();
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: RoundBoarderButton(
              backGroundColor: Color(0xFFFD5959),
              text: "Sign Up",
              onPress: () {
                allUnFocus();
                validateInput();
                //  Navigator.pushNamed(context, ProfileScreen.id);
              },
              textColor: Colors.white,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Have an Account?",
                  style: TextStyle(color: Color(0xff707070)),
                ),
                InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  highlightColor: Colors.white,
                  hoverColor: Colors.white,
                  splashColor: Colors.white,
                  onTap: widget?.onSignInPress ?? null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
            width: 150.0,
            child: Divider(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
