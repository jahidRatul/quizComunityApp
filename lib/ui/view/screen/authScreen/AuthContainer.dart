import 'package:critical_x_quiz/core/controller/auth_controller.dart';
import 'package:critical_x_quiz/ui/view/screen/signin/SignInScreen.dart';
import 'package:critical_x_quiz/ui/view/screen/signup/SignUpScreen.dart';
import 'package:critical_x_quiz/ui/widget/button/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

bool routingstate = false;
Color backgroundcolorLogIn = Color(0xFFFD5959);
Color textcolorLogIn = Colors.white;
Color backgroundcolorSignUp = Color(0xFFEFEFEF);
Color textColorSignUp = Colors.black;

class AuthContainer extends StatefulWidget {
  static String id = 'Auth';

  @override
  _AuthContainerState createState() => _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> {
  AuthController stateController = AuthController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: hp(35),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("images/cover1.png"),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
              width: 150.0,
              child: Divider(
                color: Colors.transparent,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RoundBoarderButton(
                    backGroundColor: backgroundcolorLogIn,
                    text: "Log In",
                    onPress: () {
                      setState(() {
                        routingstate = false;
                        backgroundcolorSignUp = Color(0xFFEFEFEF);
                        backgroundcolorLogIn = Color(0xFFFD5959);
                        textcolorLogIn = Colors.white;
                        textColorSignUp = Colors.black;
                      });
                    },
                    textColor: textcolorLogIn,
                  ),
                  RoundBoarderButton(
                    backGroundColor: backgroundcolorSignUp,
                    text: "Sign Up",
                    onPress: () {
                      setState(() {
                        routingstate = true;
                        backgroundcolorLogIn = Color(0xFFEFEFEF);
                        backgroundcolorSignUp = Color(0xFFFD5959);
                        textcolorLogIn = Colors.black;
                        textColorSignUp = Colors.white;
                      });
                    },
                    textColor: textColorSignUp,
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
            Container(
              child: routingstate
                  ? SignUpScreen(
                      onSignInPress: () {
                        setState(() {
                          routingstate = false;
                          backgroundcolorSignUp = Color(0xFFEFEFEF);
                          backgroundcolorLogIn = Color(0xFFFD5959);
                          textcolorLogIn = Colors.white;
                          textColorSignUp = Colors.black;
                        });
                      },
                    )
                  : SignInScreen(
                      onSignUpPress: () {
                        setState(() {
                          routingstate = true;
                          backgroundcolorLogIn = Color(0xFFEFEFEF);
                          backgroundcolorSignUp = Color(0xFFFD5959);
                          textcolorLogIn = Colors.black;
                          textColorSignUp = Colors.white;
                        });
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
