import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critical_x_quiz/core/firebase/fire_base_collection_name.dart';
import 'package:critical_x_quiz/core/model/user/user_model.dart';
import 'package:critical_x_quiz/core/tools/flutter_toast.dart';
import 'package:flutter/material.dart';

List<String> items = ['print', 'hello', 'world'];

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List<UserModel> userModelList = [];

  StreamSubscription userListen;

  getUsers() {
    userListen = FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.usersData)
        .snapshots()
        .listen((event) {
      print("test data" + event.docs.length.toString());
      userModelList.clear();
      event.docs.forEach((element) {
        UserModel model = UserModel.fromJson(element.data());
        userModelList.add(model);
        setState(() {});
      });
    });
  }

  Future updateDataToFireStore(UserModel m) async {
    return await FirebaseFirestore.instance
        .collection(FireBaseCollectionNames.usersData)
        .doc(m.uid)
        .update(m.toJson());
  }

  @override
  void initState() {
    // TODO: implement initState
    getUsers();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userListen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('All Users'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Total users: ${userModelList.length}",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: userModelList.length,
                    itemBuilder: (context, i) {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: ListTile(
                          title: Center(
                              child: Text(
                            userModelList[i].fullName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          subtitle: Center(
                            child: Text(
                              userModelList[i].email,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              if (userModelList[i].admin == false) {
                                userModelList[i].bannedUser =
                                    !userModelList[i].bannedUser;
                                updateDataToFireStore(userModelList[i]);
                                setState(() {});
                              } else {
                                FlutterToast.showErrorToast(
                                    context: context, message: "Admin user");
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              height: 30,
                              width: 80,
                              child: userModelList[i].admin
                                  ? Center(
                                child: Text(
                                  'Admin',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )
                                  : Center(
                                child: Text(
                                  userModelList[i].bannedUser
                                      ? 'UnBan'
                                      : 'Ban',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
