import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/constant/local_db_constant.dart';
import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/firebase/firebase_storage_method.dart';
import 'package:critical_x_quiz/core/model/categoty_model/categoryModel.dart';
import 'package:critical_x_quiz/core/tools/flutter_toast.dart';
import 'package:critical_x_quiz/core/utils/category_color.dart';
import 'package:critical_x_quiz/ui/botton_sheet/category_bottom_sheet.dart';
import 'package:critical_x_quiz/ui/card/multi_color_circular_percent_indicator.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/icons/flutter_nev_bar_icons_icons.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:critical_x_quiz/ui/view/admin_view/adminQuizCategoryWidget.dart';
import 'package:critical_x_quiz/ui/view/admin_view/allUsers.dart';
import 'package:critical_x_quiz/ui/view/forum/forumScreen.dart';
import 'package:critical_x_quiz/ui/widget/customBottomNavBar.dart';
import 'package:critical_x_quiz/ui/widget/linearPercentWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home';

  final int initialIndex;

  HomeScreen({
    this.initialIndex = 0,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // GetStorage authDB = GetStorage(DBConstant.authDb);
  final authDB = GetStorage();

  int currentIndex = 0;

  HomePageController homePageController = Get.put(HomePageController());

  @override
  void dispose() {
    // TODO: implement dispose
    isActiveState = false;
    categoryCollectionListen?.cancel();
    super.dispose();
    // categoryController.dispose();
  }

  bool isAdmin = false;

  bool isActiveState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isActiveState = true;
    testFireBAseMethod();
    //calculateProgress();

    isAdmin = authDB.read(DBConstant.admin) ?? false;

    print("b= $isAdmin");
    currentIndex = widget.initialIndex;
  }

  List<CategoryModel> categoryList = new List();

  StreamSubscription categoryCollectionListen;

  testFireBAseMethod() {
    print("home testFireBAseMethod");

    categoryCollectionListen = FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.categoryCollection)
        .snapshots()
        .listen((event) {
      print("Test " + event.docs.length.toString());
      categoryList.clear();
      if (event.isNullOrBlank) return;

      event?.docs?.forEach((element) {
        if (element.isNullOrBlank) return;
        CategoryModel model = CategoryModel.fromJson(element?.data());

        if (isActiveState)
          setState(() {
            categoryList?.add(model);
          });
        print("Category list :--- ${categoryList.length}");
      });

      // setState(() {});
    });
  }

  TextEditingController categoryController = TextEditingController();
  File _image;

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
        backgroundColor: Color(0xFFFDF5F5),
        body: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                              color: Colors.black12)
                        ]),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  bottom: 20.0,
                                  right: 20.0,
                                  top: 20.0),
                              child: Text(
                                'Critical',
                                style: TextStyle(
                                  color: Color(0xFF0C1A35),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                visible: homePageController.isAdminUser.value,
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AllUsers(),
                                      ),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Colors.indigoAccent,
                                  child: Text(
                                    'Users',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                AppRouter.navToProfileScreen();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    GetX<HomePageController>(
                                      builder: (controller) {
                                        //  print("count 1 rebuild");
                                        return Text(
                                          '${controller.userName.value}',
                                          style: TextStyle(
                                            color: Color(0xFF0C1A35),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GetX<HomePageController>(
                                      builder: (controller) => CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          controller.proImage.value ??
                                              'https://www.woolha.com/media/2020/03/eevee.png',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Summary',
                          style: TextStyle(
                              color: Color(0xFF0C1A35),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MultiColorCircularPercentIndicator(
                          categoryList: categoryList,

                          /* categoryInfoList: [
                                ...Iterable.generate(
                                  (categoryList?.length ?? 0),
                                  (i) => controller?.userProgressModel2
                                      ?.getCategoryInfoModel(
                                          categoryList[i]?.title),
                                ),
                              ],*/
                          taskPercent: [],
                        ),
                        /*  GetBuilder<HomePageController>(
                          builder: (controller) {
                            print("check list  ${(categoryList?.length ?? 0)}");
                            print(
                                "check list  ${(controller?.userProgressModel2?.categoryInfoList?.length)}");
                            return MultiColorCircularPercentIndicator(
                              categoryList:
                                  categoryList.map((e) => e.title).toList(),
                             */ /* categoryInfoList: [
                                ...Iterable.generate(
                                  (categoryList?.length ?? 0),
                                  (i) => controller?.userProgressModel2
                                      ?.getCategoryInfoModel(
                                          categoryList[i]?.title),
                                ),
                              ],*/ /*
                              taskPercent: [],
                            );
                          },
                        ),*/
                        SizedBox(
                          height: 15,
                        ),
                        GetBuilder<HomePageController>(
                          builder: (c) => GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  /* (homePageController?.userProgressModel
                                      ?.value?.categoryInfoList?.length ??
                                  0)*/
                                  (categoryList?.length ?? 0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: wp(44) / 50,
                                crossAxisSpacing: 0.0,
                                mainAxisSpacing: 0.0,
                              ),
                              itemBuilder: (BuildContext context, index) {
                                return Container(
                                  child: LinearPercentWidget(
                                    title: categoryList[index].title,
                                    color:
                                        CategoryColor.getCategoryColor(index),
                                    categoryInfoModel: homePageController
                                        ?.userProgressModel?.value
                                        ?.getCategoryInfoModel(
                                            categoryList[index].title),

                                    // percentNumber: 0.75,
                                    //  percentText: "75%",
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => homePageController.isAdminUser.value == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Quiz Categories',
                                  style: TextStyle(
                                      color: Color(0xFF0C1A35),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: RaisedButton(
                                  color: Colors.indigo,
                                  onPressed: () {
                                    CategoryBottomSheet.showCategoryBottomSheet(
                                      context,
                                      categoryController: categoryController,
                                      image: _image,
                                      submitButton: () async {
                                        if (categoryController
                                            .text.isNotEmpty) {
                                          EasyLoading.show(
                                            status: 'loading...',
                                          );

                                          String url;
                                          if (_image != null)
                                            url = await FireBaseFileStorage
                                                .uploadImage(
                                              imageFile: _image,
                                              dirName: "CategoryImage/",
                                            );
                                          CategoryModel model = CategoryModel(
                                              title: categoryController.text
                                                  .trim(),
                                              categoryImage: url);

                                          await FirebaseFirestore.instance
                                              .collection(
                                                  FireBaseCollectionNames
                                                      .categoryCollection)
                                              .doc(model.title)
                                              .set(model.toJson());

                                          EasyLoading.dismiss();
                                          FlutterToast.showSuccess(
                                              message: "Category Added",
                                              context: context);

                                          categoryController.clear();
                                          _image = null;

                                          setState(() {});

                                          Navigator.pop(context);
                                          AppRouter.navToHomePage();
                                        }
                                      },
                                      addImage: (image) {
                                        _image = image;
                                      },
                                    );
                                  },
                                  child: Text(
                                    '+ Category ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Quiz Categories',
                              style: TextStyle(
                                  color: Color(0xFF0C1A35),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                  ),
                  Container(
                    // height: 800,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: categoryList.length,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 11 / 13,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: AdminQuizCategoryWidget(
                                  categoryList[index],
                                  imgPath:
                                      categoryList[index]?.categoryImage ?? '',
                                  title: categoryList[index]?.title,
                                  onTap: () {
                                    if (isActiveState) setState(() {});
                                  },
                                  onDelete: () async {
                                    if (homePageController.isAdminUser.value ==
                                        true)
                                      await DialogRouter.displayConfirmDialog(
                                          context: context,
                                          bodyText:
                                              "Do you want to delete this Category??",
                                          titleText: "Delete Category",
                                          noPress: () {
                                            AppRouter.back();
                                          },
                                          yesPress: () {
                                            CategoryModel m =
                                                categoryList[index];
                                            categoryList.removeAt(index);
                                            m.delete();
                                            AppRouter.back();
                                            AppRouter.navToHomePage();
                                          });
                                    setState(() {});
                                  },
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),

          /// please don't delete Container
          Container(),
          ForumScreen(),
        ][currentIndex],
        bottomNavigationBar: BottomNavyBar(
          containerHeight: 90,
          selectedIndex: currentIndex,
          showElevation: true,
          itemCornerRadius: 50,
          curve: Curves.easeInBack,
          onItemSelected: (index) => setState(() {
            currentIndex = index;
            if (currentIndex == 1) {
              AppRouter.navToPostAQuestion();
            }
            /* if (currentIndex == 2) {
              Navigator.pushReplacementNamed(context, ForumScreen.id);
            }*/
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(FlutterNevBarIcons.home),
              title: Text(
                'Home',
                // style: TextStyle(),
              ),
              activeColor: Color(0xFFFD5959),
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(FlutterNevBarIcons.chat),
              title: Text('Questions'),
              activeColor: Color(0xFFFD5959),
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(FlutterNevBarIcons.group),
              title: Text(
                'Forum ',
              ),
              activeColor: Color(0xFFFD5959),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
