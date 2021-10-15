import 'package:critical_x_quiz/core/controller/auth_controller.dart';
import 'package:critical_x_quiz/ui/widget/button/RoundedButton.dart';
import 'package:critical_x_quiz/ui/widget/textfield/TextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:validators/validators.dart' as validator;

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  AuthController stateController = AuthController();

  String email;
  FocusNode emailNode = FocusNode();

  allUnFocus() {
    emailNode.unfocus();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  validatorInput(BuildContext context) {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    stateController.retrievePasswordMethod(context, email);
  }

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
              height: 258,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("images/cover1.png"),
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment(-0.9, -0.7),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
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
            SizedBox(
              height: 10.0,
              width: 150.0,
              child: Divider(
                color: Colors.transparent,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    margin: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: textInputField(
                      lebelText: "Email",
                      hintText: "Jone Doe@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {},
                      backcolor: Color(0xFFFBFBFB),

                      onSaved: (v) {
                        email = v;
                      },
                      focusNode: emailNode,

                      onFieldSubmitted: (v) {
                        emailNode.unfocus();
                      },

                      validator: (v) {
                        return validator.isEmail(v)
                            ? null
                            : "please insert a valid email ";
                      },
                      //  obscureState: false,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: RoundBoarderButton(
                backGroundColor: Color(0xFFFD5959),
                text: "Retrieve password",
                onPress: () {
                  allUnFocus();
                  validatorInput(context);
                  // Navigator.pushNamed(context, HomeScreen.id);
                },
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
