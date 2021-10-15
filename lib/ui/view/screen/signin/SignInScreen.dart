import 'package:critical_x_quiz/core/controller/auth_controller.dart';
import 'package:critical_x_quiz/ui/view/forget_password/forget_password.dart';
import 'package:critical_x_quiz/ui/widget/button/RoundedButton.dart';
import 'package:critical_x_quiz/ui/widget/textfield/TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:validators/validators.dart' as validator;

class SignInScreen extends StatefulWidget {
  final Function onSignUpPress;

  SignInScreen({
    this.onSignUpPress,
  });

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthController stateController = Get.put(AuthController());

  String email, password;

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  allUnFocus() {
    emailNode.unfocus();
    passwordNode.unfocus();
  }

  validatorInput(BuildContext context) {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    stateController.loginMethod(context, email, password);
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
                    lebelText: "Email",
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
                    backcolor: Color(0xFFFBFBFB),

                    onSaved: (v) {
                      email = v;
                    },
                    focusNode: emailNode,
                    onFieldSubmitted: (v) {
                      emailNode.unfocus();
                      passwordNode.requestFocus();
                    },

                    validator: (v) {
                      return validator.isEmail(v)
                          ? null
                          : "please insert a valid email ";
                    },
                    //  obscureState: false,
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
                    obscureState: true,
                    keyboardType: TextInputType.text,
                    onSaved: (v) {
                      password = v;
                    },
                    focusNode: passwordNode,
                    onFieldSubmitted: (v) {
                      passwordNode.unfocus();
                    },
                    validator: (v) {
                      return v.length < 5 ? "Password is too short" : null;
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
              text: "Log In",
              onPress: () {
                allUnFocus();
                validatorInput(context);
                // Navigator.pushNamed(context, HomeScreen.id);
              },
              textColor: Colors.white,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Color(0xff707070),
                  ),
                ),
                InkWell(
                  splashColor: Colors.white,
                  hoverColor: Colors.white,
                  highlightColor: Colors.white,
                  focusColor: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  onTap: widget?.onSignUpPress ?? null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
            width: 150.0,
            child: Divider(
              color: Colors.transparent,
            ),
          ),
          InkWell(
            splashColor: Colors.white,
            hoverColor: Colors.white,
            highlightColor: Colors.white,
            focusColor: Colors.white,
            onTap: () {
              //   Get.to(ForgetPasswordPage(),transition: Transition.fadeIn);
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: ForgetPasswordPage()));
            },
            child: Container(
              child: Text(
                "Retrieve password",
                style: TextStyle(color: Colors.red),
              ),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text("Don't have an account?"),
              //     Text(
              //       "Sign up",
              //       style: TextStyle(color: Colors.red),
              //     )
              //   ],
              // ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
