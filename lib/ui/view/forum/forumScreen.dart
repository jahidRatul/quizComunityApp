import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/model/categoty_model/categoryModel.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:critical_x_quiz/ui/view/home/card/form_post_item_card.dart';
import 'package:critical_x_quiz/ui/widget/button/RoundedButton.dart';
import 'package:critical_x_quiz/ui/widget/quizCategoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

class ForumScreen extends StatefulWidget {
  static String id = 'forumScreen';

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  int currentIndex = 2;
  HomePageController homePageController = Get.put(HomePageController());

  bool isRecent = true;
  bool isCategory = false;

  String queryByCategory = "";

  List<CategoryModel> categoryList = new List();

  StreamSubscription categoryCollection;

  testFireBAseMethod() {
    categoryCollection = FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.categoryCollection)
        .snapshots()
        .listen((event) {
      print("Test " + event.docs.length.toString());
      categoryList.clear();
      if (event.isNullOrBlank) return;
      event.docs?.forEach((element) {
        if (element.isNullOrBlank) return;
        CategoryModel model = CategoryModel.fromJson(element.data());

        categoryList?.add(model);

        setState(() {});
      });
      categoryList.insert(
        0,
        CategoryModel(title: 'All', categoryImage: ''),
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    categoryCollection?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    testFireBAseMethod();
    super.initState();
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
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: Color(0xFF141414),
                                            size: 16,
                                          ),
                                          onPressed: () {
                                            AppRouter.navToHomePage();
                                          }),
                                    )),
                                Text(
                                  'Forum',
                                  style: TextStyle(
                                    color: Color(0xFF0C1A35),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              onTap: () {
                                AppRouter.navToProfileScreen();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    /* Text(
                                    'Jane Dow',
                                    style: TextStyle(
                                      color: Color(0xFF0C1A35),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),*/
                                    GetX<HomePageController>(
                                      builder: (controller) {
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
                                        backgroundImage: NetworkImage(controller
                                                .proImage.value ??
                                            'https://www.woolha.com/media/2020/03/eevee.png'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundBoarderButton(
                              backGroundColor: isRecent
                                  ? Color(0xFFFD5959)
                                  : Color(0xFFF1F1F1),
                              text: "Recent",
                              onPress: () {
                                setState(() {
                                  isRecent = true;
                                  isCategory = false;
                                });
                              },
                              textColor: isRecent ? Colors.white : Colors.black,
                            ),
                            RoundBoarderButton(
                              backGroundColor: isCategory
                                  ? Color(0xFFFD5959)
                                  : Color(0xFFF1F1F1),
                              text: "By category",
                              onPress: () {
                                setState(() {
                                  isRecent = false;
                                  isCategory = true;
                                });
                              },
                              textColor:
                                  isCategory ? Colors.white : Colors.black,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    children: [
                      if (isRecent)
                        Visibility(
                          visible: true,
                          child: Container(
                            child: Obx(
                              () => Container(
                                child: Column(
                                  children: [
                                    if (homePageController
                                                ?.formPostList?.value?.length ==
                                            0 ||
                                        homePageController
                                                ?.formPostList?.value?.length ==
                                            null)
                                      SizedBox(
                                        height: 200,
                                        child: Center(
                                            child: Text('No Post Found')),
                                      )
                                    else
                                      ...Iterable.generate(
                                        homePageController
                                            ?.formPostList?.value?.length,
                                        //130,
                                        (i) => FormPostItemCard(
                                          homePageController
                                              ?.formPostList?.value[i],
                                          onDelete: () {
                                            if (homePageController
                                                        .isAdminUser.value ==
                                                    true ||
                                                homePageController
                                                    ?.formPostList[i]
                                                    .isPostOwner(
                                                        homePageController
                                                            .currentUserModel
                                                            .uid
                                                            .toString()))
                                              DialogRouter.displayConfirmDialog(
                                                  context: context,
                                                  titleText: "Delete !!!",
                                                  bodyText:
                                                      "Do you want to delete this post",
                                                  noPress: () {
                                                    AppRouter.back();
                                                  },
                                                  yesPress: () {
                                                    homePageController
                                                        .onPostDeleteMethod(
                                                            homePageController
                                                                ?.formPostList
                                                                ?.value[i]);
                                                    AppRouter.back();
                                                  });
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        Visibility(
                          visible: true,
                          child: GetBuilder<HomePageController>(
                            builder: (c) => Container(
                              // height: 800,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: categoryList.length,
                                      gridDelegate:
                                          new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 1.0,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          child: QuizCategoryWidget(
                                            imgPath: categoryList[index]
                                                ?.categoryImage,
                                            title: categoryList[index]?.title,
                                            getCategoryName: (categoryName) {
                                              queryByCategory = categoryName;
                                              c.searchByCategoryMethod(
                                                  categoryName);
                                            },
                                            onTap: () {
                                              print("clicked");
                                              isRecent = true;
                                              isCategory = false;
                                              setState(() {});
                                            },
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
