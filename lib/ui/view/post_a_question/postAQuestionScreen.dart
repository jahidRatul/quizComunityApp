import 'dart:io';

import 'package:critical_x_quiz/core/controller/PostAQuestionScreenController.dart';
import 'package:critical_x_quiz/core/model/categoty_model/categoryModel.dart';
import 'package:critical_x_quiz/core/tools/flutter_toast.dart';
import 'package:critical_x_quiz/core/utils/Image_picker_methods.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/icons/flutter_image_add_icons.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:critical_x_quiz/ui/view/home/homeScreen.dart';
import 'package:critical_x_quiz/ui/widget/button/RoundedButton.dart';
import 'package:critical_x_quiz/ui/widget/dropDownMenuList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    hide
        DropdownButton,
        DropdownButtonFormField,
        DropdownButtonHideUnderline,
        DropdownMenuItem;
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

class PostAQuestionScreen extends StatefulWidget {
  static String id = "post";

  @override
  _PostAQuestionScreenState createState() => _PostAQuestionScreenState();
}

class _PostAQuestionScreenState extends State<PostAQuestionScreen> {
  String _value;

  String title, category, categoryImage, questionDescription;
  List<File> imageList = new List();
  final _formKey = GlobalKey<FormState>();

  FocusNode titleNode = new FocusNode();
  FocusNode questionDescriptionNode = new FocusNode();
  CategoryModel _categoryModel;

  allUnFocus() {
    titleNode.unfocus();
    questionDescriptionNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return WillPopScope(
      onWillPop: () async {
        return DialogRouter.displayConfirmDialog(
          context: context,
          titleText: 'Exit!',
          bodyText: 'Do you want to exit App',
          yesPress: () {
            AppRouter.exitApp();
          },
          noPress: () {
            AppRouter.back();
          },
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButton: Align(
          alignment: Alignment(1, .7),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () {
                allUnFocus();
                FlutterImagePicker.imagePickerModalSheet(
                    context: context,
                    fromCamera: () async {
                      File temp = await FlutterImagePicker.getImageCamera(
                          context,
                          compress: true);
                      if (temp == null) return;
                      imageList.add(temp);
                      setState(() {});
                    },
                    fromGallery: () async {
                      File temp = await FlutterImagePicker.getImageGallery(
                          context,
                          compress: true);
                      if (temp == null) return;
                      imageList.add(temp);
                      setState(() {});
                    });
              },
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 2.0)),
                child: Center(
                  child: Icon(
                    FlutterImageAdd.image_add,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Color(0xFF141414),
                            size: 20,
                          ),
                          onPressed: () {
                            Get.to(HomeScreen(), transition: Transition.fadeIn);
                          }),
                    ),
                    Text(
                      'Post a Question',
                      style: TextStyle(
                        color: Color(0xFF0C1A35),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFFE8E8E8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: GetX<PostAQuestionScreenController>(
                          builder: (controller) => Container(
                            child: (controller?.categoryModelList?.value
                                            ?.length ??
                                        0) <
                                    1
                                ? SizedBox(
                                    height: 48,
                                    child: Center(
                                      child: Text(
                                        "Category not Available",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0C1A35),
                                        ),
                                      ),
                                    ),
                                  )
                                : DropdownButtonHideUnderline(
                                    child: new Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: Colors.blue.shade200,
                                    ),
                                    child: DropdownButton<CategoryModel>(
                                        dropdownColor: Color(0xffE8E8E8),
                                        isExpanded: true,
                                        hint: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 50),
                                          child: Text(
                                            "Category",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF0C1A35),
                                            ),
                                          ),
                                        ),
                                        value: _categoryModel,
                                        icon: Icon(
                                          Icons.arrow_drop_down, // Add this
                                          color: Color(0xFF0C1A35),
                                        ),
                                        items: [
                                          ...Iterable.generate(
                                            (controller?.categoryModelList
                                                    ?.value?.length ??
                                                0),
                                            (i) => DropdownMenuItem(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: (controller
                                                                      ?.categoryModelList
                                                                      ?.value
                                                                      ?.length ??
                                                                  0) ==
                                                              (i + 1)
                                                          ? Color(0xffB7B7B7)
                                                          : Color(0xffB7B7B7)),
                                                )),
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 35,
                                                    vertical: 16),
                                                child: Text(
                                                  "${controller?.categoryModelList?.value[i].title}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF0C1A35),
                                                  ),
                                                ),
                                              ),
                                              value: controller
                                                  ?.categoryModelList?.value[i],
                                              // "${controller?.categoryModelList?.value[i].title}",
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _categoryModel = value;
                                          });
                                          print("${value.categoryImage}");
                                          category = value.title.toString();
                                          categoryImage =
                                              value.categoryImage.toString();
                                          titleNode.requestFocus();
                                        }),
                                  )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 50.0),
                      //Color(0xFFEDEDED),
                      child: TextFormField(
                        obscureText: false,
                        autofocus: false,
                        focusNode: titleNode,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        validator: (v) =>
                            v.isEmpty ? "Title can't be empty" : null,
                        onFieldSubmitted: (v) {
                          titleNode.unfocus();
                          questionDescriptionNode.requestFocus();
                        },
                        onSaved: (v) {
                          title = v;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "TITLE",
                          hintStyle: TextStyle(
                              fontSize: 12.0, color: Color(0xffB7B7B7)),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Divider(
                        height: 2,
                        color: Color(0xFF707070),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 50.0),
                            // color: Colors.red,
                            child: TextFormField(
                              obscureText: false,
                              focusNode: questionDescriptionNode,
                              validator: (v) =>
                                  v.isEmpty ? "Question can't be empty" : null,
                              onFieldSubmitted: (v) {
                                questionDescriptionNode.unfocus();
                              },
                              onSaved: (v) {
                                questionDescription = v;
                              },
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type Your Question",
                                hintStyle: TextStyle(
                                    fontSize: 12.0, color: Color(0xffB7B7B7)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: GridView.builder(
                      itemCount: imageList.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            image: DecorationImage(
                              image: FileImage(imageList[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: hp(15),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                          color: Colors.grey)
                    ]),
                  ),
                  GetBuilder<PostAQuestionScreenController>(
                    builder: (controller) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 70.0),
                      child: RoundBoarderButton(
                        onPress: () {
                          allUnFocus();
                          if (category == null) {
                            FlutterToast.showErrorToast(
                                message: "Please select a Category.",
                                context: context);
                            return;
                          }

                          if (!_formKey.currentState.validate()) return;
                          _formKey.currentState.save();

                          controller.postAQuestion(
                            context,
                            imageList: imageList,
                            category: category,
                            categoryImage: categoryImage,
                            title: title,
                            question: questionDescription,
                          );
                        },
                        backGroundColor: Color(0xFFFD5959),
                        text: "Post",
                        textColor: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
