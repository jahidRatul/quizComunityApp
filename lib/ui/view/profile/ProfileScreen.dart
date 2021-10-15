import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/controller/profile_controller.dart';
import 'package:critical_x_quiz/core/firebase/app_data.dart';
import 'package:critical_x_quiz/core/model/user/user_model.dart';
import 'package:critical_x_quiz/core/utils/Image_picker_methods.dart';
import 'package:critical_x_quiz/ui/card/non_editable_text_feild.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/widget/button/RoundedButton.dart';
import 'package:critical_x_quiz/ui/widget/button/logoutButton.dart';
import 'package:critical_x_quiz/ui/widget/textfield/TextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  static String id = "profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController stateController = Get.put(ProfileController());
  final HomePageController homeController = Get.put(HomePageController());

  StreamSubscription _userSubscription;

  File profileImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name, password, confirmPassword, initialName;

  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  FocusNode nameNode = new FocusNode();
  FocusNode emailNode = new FocusNode();
  FocusNode passwordNode = new FocusNode();
  FocusNode confirmPasswordNode = new FocusNode();

  allUnFocus() {
    nameNode.unfocus();
    emailNode.unfocus();
    passwordNode.unfocus();
    confirmPasswordNode.unfocus();
  }

  getUserData() async {
    User user = FirebaseAuth.instance.currentUser;
    if (user.uid == null) {
      return;
    }

    //DocumentSnapshot dp = await
    _userSubscription = FirebaseFirestore.instance
        .collection(AppData.usersData)
        .doc(user.uid)
        .snapshots()
        .listen((event) {
      DocumentSnapshot dp = event;
      if (dp.isNullOrBlank) return;
      UserModel userModel = UserModel?.fromDoc(dp);
      nameController.text = userModel?.fullName ?? "";
      initialName = userModel?.fullName ?? "";
      emailController.text = userModel?.email ?? "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
    getUserData();
  }

  setUserData() {
    nameController.text = homeController?.currentUserModel?.fullName ?? "";
    emailController.text = homeController?.currentUserModel?.email ?? "";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Material(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(20),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: hp(35),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(20.0, 20.0),
                          bottomRight: Radius.elliptical(20.0, 20.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("images/profilecover.png"),
                        ),
                      ),
                    ),
                  ),
                  GetX<HomePageController>(
                    builder: (controller) => Container(
                      height: hp(35),
                      width: hp(100),
                      child: Center(
                        child: Container(
                          width: wp(25),
                          height: wp(25),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            border: Border.all(color: Colors.white, width: 5.0),
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: profileImage != null
                                  ? FileImage(profileImage)
                                  : NetworkImage(controller.proImage.value ??
                                      'https://www.woolha.com/media/2020/03/eevee.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: hp(35),
                    width: wp(100),
                    child: Align(
                      alignment: Alignment(.2, 0.4),
                      child: InkWell(
                        onTap: () {
                          FlutterImagePicker.imagePickerModalSheet(
                              context: context,
                              fromCamera: () async {
                                File temp =
                                    await FlutterImagePicker.getImageCamera(
                                        context,
                                        compress: true);

                                if (temp == null) return;

                                profileImage = temp;

                                stateController
                                    .updateProfileImage(profileImage);
                                setState(() {});
                              },
                              fromGallery: () async {
                                File temp =
                                    await FlutterImagePicker.getImageGallery(
                                        context,
                                        compress: true);

                                if (temp == null) return;

                                profileImage = temp;
                                stateController
                                    .updateProfileImage(profileImage);
                                setState(() {});
                              });
                        },
                        child: Container(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                            width: wp(10),
                            height: hp(10),
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 35,
                    left: 10,
                    child: Container(
                      width: wp(100),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment(-0.15, 0),
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 10,
                    child: Container(
                      width: wp(100),
                      child: Align(
                        alignment: Alignment(-0.05, 0),
                        child: GetX<HomePageController>(
                          builder: (controller) => Container(
                            child: Text(
                              '${controller?.userName?.value ?? ""}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.lato().fontFamily,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
                width: 150.0,
                child: Divider(
                  color: Colors.transparent,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                margin: EdgeInsets.only(left: 25.0, right: 25.0),
                child: textInputField(
                  lebelText: "Name",
                  controller: nameController,
                  hintText: "Jone Doe",
                  focusNode: nameNode,
                  onFieldSubmitted: (v) {
                    nameNode.unfocus();
                  },
                  onChanged: (value) {},
                  backcolor: Color(0xFFFBFBFB),
                  obscureState: false,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                margin: EdgeInsets.only(left: 25.0, right: 25.0),
                child: NonEditAbleText(
                  lebelText: "Email",
                  controller: emailController,
                  hintText: "Jone Doe@gmail.com",
                  onChanged: (value) {},
                  backcolor: Color(0xFFFBFBFB),
                  obscureState: false,
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
                          lebelText: "Password",
                          hintText: "Enter Password",
                          controller: passwordController,
                          focusNode: passwordNode,
                          onFieldSubmitted: (v) {
                            passwordNode.unfocus();
                            confirmPasswordNode.requestFocus();
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          validator: (v) {
                            String s;
                            s = password == confirmPassword
                                ? null
                                : "Both password not match";

                            s = (password?.length ?? 6) < 6
                                ? "password is too short"
                                : null;

                            return s;
                          },
                          backcolor: Color(0xFFFBFBFB),
                          obscureState: true,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        margin: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: textInputField(
                          lebelText: "Confirm Password",
                          hintText: "Enter Confirm Password",
                          focusNode: confirmPasswordNode,
                          controller: confirmPasswordController,
                          onFieldSubmitted: (v) {
                            allUnFocus();
                          },
                          validator: (v) {
                            if (v == null) {
                              password = v;
                              return null;
                            }
                            String s;
                            s = password == confirmPassword
                                ? null
                                : "Both password not match";

                            return s;
                          },
                          onChanged: (value) {
                            confirmPassword = value;
                          },
                          backcolor: Color(0xFFFBFBFB),
                          obscureState: true,
                        ),
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(right: wp(30)),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: RoundBoarderButton(
                  backGroundColor: Color(0xFFFD5959),
                  text: "Update Profile",
                  onPress: () {
                    allUnFocus();

                    if (_formKey.currentState.validate()) {
                      stateController?.updatePassword(passwordController.text);
                    }

                    if (nameController.text != null) {
                      if (nameController.text != "") {
                        if (initialName != nameController.text)
                          stateController.profileUpdateMethod(
                              name: nameController.text.trim());
                      }
                    }
                  },
                  textColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 60.0,
                width: 150.0,
                child: Divider(
                  color: Colors.transparent,
                ),
              ),
              Center(
                child: InkWell(
                  splashColor: Colors.white,
                  hoverColor: Colors.white,
                  highlightColor: Colors.white,
                  focusColor: Colors.white,
                  onTap: () {
                    allUnFocus();

                    DialogRouter.displayDeleteDialog(
                        context: context,
                        bodyText:
                            "Do yoy really want to delete these? This process cannot be undone.",
                        titleText: "Are you sure?",
                        noPress: () {
                          DialogRouter.closeProgressDialog(context);
                        },
                        yesPress: () {
                          _userSubscription?.cancel();
                          print("delete account");
                          DialogRouter.closeProgressDialog(context);
                          stateController?.deleteAccount(context);
                        });
                  },
                  child: Container(
                    child: Text(
                      "Delete Account",
                      style: TextStyle(color: Color(0xFFB7B7B7)),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: wp(50),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: LogoutButton(
                    backGroundColor: Colors.white,
                    text: "Log Out",
                    onPress: () {
                      allUnFocus();
                      stateController.logOut();
                    },
                    textColor: Color(0xFFFD5959),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
