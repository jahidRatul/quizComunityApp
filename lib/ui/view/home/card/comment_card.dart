import 'package:critical_x_quiz/core/controller/forum_discussion_controller.dart';
import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_answer_model.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_answer_reply.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_model.dart';
import 'package:critical_x_quiz/ui/botton_sheet/comment_inpute_view.dart';
import 'package:critical_x_quiz/ui/dialog/dialog_router.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final FormPostAnswerModel model;
  final int answerIndex;

  final Function(int p) upPoint;
  final Function(int p) downPoint;
  final Function(bool b) isCorrect;
  final Function onTap;
  final String postUserId;
  final bool hideReply;
  final FormPostModel formPostModel;
  final bool onDeletePermission;
  final Function onDelete;
  final Function(int i) onReplyDelete;
  final Function commentPostHide;
  final Function commentPostVisible;

  CommentCard(this.model,
      {this.isCorrect,
      this.answerIndex,
      this.downPoint,
      this.upPoint,
      this.postUserId,
      this.onTap,
      this.formPostModel,
      this.onDeletePermission = true,
      this.hideReply = true,
      this.onReplyDelete,
      this.onDelete,
      this.commentPostHide,
      this.commentPostVisible});

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  String comment;
  FormPostModel formPostModel;

  User user = FirebaseAuth.instance.currentUser;
  bool hideReply = false;
  bool replyComment = false;

  HomePageController homePageController = Get.put(HomePageController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hideReply = widget.hideReply;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          InkWell(
            // onTap: widget?.onTap,
            onLongPress: widget?.onDelete == null
                ? null
                : () {
                    if (homePageController.isAdminUser.value == true ||
                        widget.formPostModel.isPostOwner(homePageController
                            .currentUserModel.uid
                            .toString()) ||
                        widget.formPostModel.answeredList[widget.answerIndex]
                            .isAnswerOwner(
                                homePageController.currentUserModel.uid)) {
                      if (widget.onDeletePermission == true)
                        DialogRouter.displayConfirmDialog(
                            titleText: "Delete!!!",
                            bodyText: "Do you want to delete the answer?",
                            context: context,
                            noPress: () {
                              AppRouter.back();
                            },
                            yesPress: () {
                              widget?.onDelete?.call();
                              AppRouter.back();
                            });
                    }
                  },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget?.model?.authorName ?? ""}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C1A35),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Container(
                        height: 20,
                        width: 85,
                        child: RaisedButton(
                          color: (widget?.model?.isCorrect ?? false) == true
                              ? Color(0xFF25AFA2)
                              : Colors.grey,
                          onPressed: () {
                            if (widget?.postUserId == user?.uid.toString() ||
                                homePageController.isAdminUser.value == true) {
                              widget?.model?.isCorrect =
                                  !(widget?.model?.isCorrect ?? false);
                              widget?.isCorrect
                                  ?.call((widget?.model?.isCorrect ?? false));

                              setState(() {});
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/correct_icon.png",
                                color: Colors.white,
                                height: 12,
                                width: 12,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Correct',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(widget?.model?.postTime?.microsecondsSinceEpoch ?? 1000))}" +
                      " at " +
                      "${DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(widget?.model?.postTime?.microsecondsSinceEpoch ?? 1000))}",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFB3B3B3),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${widget?.model?.answerDescription ?? ""}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF0C1A35),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 1),
            child: Row(
              children: [
                InkWell(
                  splashColor: Colors.white,
                  hoverColor: Colors.white,
                  highlightColor: Colors.white,
                  focusColor: Colors.white,
                  onTap: () {
                    replyComment = true;
                    widget.commentPostHide();

                    setState(() {});
                  },
                  child: Text(
                    'Reply',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFFB7B7B7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  splashColor: Colors.white,
                  hoverColor: Colors.white,
                  highlightColor: Colors.white,
                  focusColor: Colors.white,
                  onTap: () {
                    if (!(widget?.model?.pointUserId?.contains(user.uid) ??
                        true)) widget?.model?.upPoints++;
                    int tempPoint = widget?.model?.upPoints ?? 0;

                    setState(() {});
                    widget?.upPoint?.call(tempPoint);
                  },
                  child: Image.asset(
                    "images/thumbs_up.png",
                    height: 18,
                    width: 18,
                    color: Color(0xFF25AFA2),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (!(widget?.model?.pointUserId?.contains(user.uid) ??
                        true)) widget?.model?.upPoints++;
                    int tempPoint = widget?.model?.upPoints ?? 0;

                    setState(() {});
                    widget?.upPoint?.call(tempPoint);
                  },
                  child: SizedBox(
                    width: 5,
                  ),
                ),
                InkWell(
                  splashColor: Colors.white,
                  hoverColor: Colors.white,
                  highlightColor: Colors.white,
                  focusColor: Colors.white,
                  onTap: () {
                    if (!(widget?.model?.pointUserId?.contains(user.uid) ??
                        true)) widget?.model?.upPoints++;
                    int tempPoint = widget?.model?.upPoints ?? 0;

                    setState(() {});
                    widget?.upPoint?.call(tempPoint);
                  },
                  child: Text(
                    "${widget?.model?.getTotalLike() ?? 0}",
                    style: TextStyle(fontSize: 10, color: Color(0xffF8AC40)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),

                ////---dislike
                InkWell(
                  onTap: () {
                    if (!(widget?.model?.pointUserId?.contains(user.uid) ??
                        true)) widget?.model?.downPoints++;
                    int tempPoint = widget?.model?.downPoints ?? 0;

                    setState(() {});
                    widget?.downPoint?.call(tempPoint);
                  },
                  child: Image.asset(
                    "images/thumbs_down.png",
                    height: 18,
                    width: 18,
                    color: Color(0xffFD5959),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (!(widget?.model?.pointUserId?.contains(user.uid) ??
                        true)) widget?.model?.downPoints++;
                    int tempPoint = widget?.model?.downPoints ?? 0;

                    setState(() {});
                    widget?.downPoint?.call(tempPoint);
                  },
                  child: SizedBox(
                    width: 5,
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (!(widget?.model?.pointUserId?.contains(user.uid) ??
                        true)) widget?.model?.downPoints++;
                    int tempPoint = widget?.model?.downPoints ?? 0;

                    setState(() {});
                    widget?.downPoint?.call(tempPoint);
                  },
                  child: Text(
                    "${widget?.model?.getTotalDisLike() ?? 0}",
                    style: TextStyle(fontSize: 10, color: Color(0xffF8AC40)),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 20,
          ),

          ...Iterable.generate(
            widget?.model?.replyList?.length,
            (i) => InkWell(
              onLongPress: () {
                if (homePageController.isAdminUser.value == true ||
                    widget.formPostModel.isPostOwner(
                        homePageController.currentUserModel.uid.toString()) ||
                    widget.formPostModel.answeredList[widget.answerIndex]
                        .isAnswerOwner(homePageController.currentUserModel.uid
                            .toString()) ||
                    widget.model.replyList[i].isAnswerReplyOwner(
                        homePageController.currentUserModel.uid.toString())) {
                  DialogRouter.displayConfirmDialog(
                      titleText: "Delete!!!",
                      bodyText: "Do you want to delete the reply?",
                      context: context,
                      noPress: () {
                        AppRouter.back();
                      },
                      yesPress: () {
                        print("tttt  test");
                        widget?.onReplyDelete?.call(i);
                        AppRouter.back();
                      });
                }
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 0, top: 0, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 18,
                                  width: 3,
                                  color: Color(0xff25AFA2),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${widget?.model?.replyList[i]?.authorName}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0C1A35),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(widget?.model?.replyList[i]?.postTime?.microsecondsSinceEpoch ?? 1000))}" +
                                  " at " +
                                  "${DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(widget?.model?.replyList[i]?.postTime?.microsecondsSinceEpoch ?? 1000))}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFFB3B3B3),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 9),
                          child: Text(
                            "${widget?.model?.replyList[i]?.replyDescription}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF0C1A35),
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 20.0, top: 8),
                        //     child: Text(
                        //       'Reply',
                        //       style: TextStyle(
                        //         fontSize: 8,
                        //         fontWeight: FontWeight.w600,
                        //         color: Color(0xff25AFA2),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: replyComment,
            child: GetBuilder<ForumDiscussionController>(
              init: ForumDiscussionController(),
              builder: (controller) => CommentInputView(
                replyComment: () {
                  replyComment = false;

                  setState(() {});
                },
                height: 30,
                onComment: (v) {
                  comment = v;
                },
                visibleCommentPost: () {
                  widget.commentPostVisible();
                },
                onSend: () {
                  if (comment != null) {
                    FormPostAnswerReplyModel reply =
                        new FormPostAnswerReplyModel(
                      authorName: "${user.displayName}",
                      authorUid: "${user.uid}",
                      replyDescription: "$comment",
                    );
                    widget.formPostModel.answeredList[widget.answerIndex]
                        .replyList
                        .add(reply);
                    setState(() {});
                    controller
                        .onCommentReplySubmit(widget.formPostModel)
                        .then((value) {
                      comment = null;

                      print("comment updated");
                    });

                    comment = null;
                  }
                },
              ),
            ),
          ),

          ////////////////////////////////////////
          // SizedBox(
          //   height: 50,
          // ),
          // InkWell(
          //   onTap: widget?.onTap,
          //   onLongPress: widget?.onDelete == null
          //       ? null
          //       : () {
          //           if (homePageController.isAdminUser.value == true ||
          //               widget.formPostModel.isPostOwner(homePageController
          //                   .currentUserModel.uid
          //                   .toString()) ||
          //               widget.formPostModel.answeredList[widget.answerIndex]
          //                   .isAnswerOwner(
          //                       homePageController.currentUserModel.uid)) {
          //             if (widget.onDeletePermission == true)
          //               DialogRouter.displayConfirmDialog(
          //                   titleText: "Delete!!!",
          //                   bodyText: "Do you want to delete the answer?",
          //                   context: context,
          //                   noPress: () {
          //                     AppRouter.back();
          //                   },
          //                   yesPress: () {
          //                     widget?.onDelete?.call();
          //                     AppRouter.back();
          //                   });
          //           }
          //         },
          //   child: Row(
          //     children: [
          //       Container(
          //         child: Column(
          //           children: [
          //             InkWell(
          //               onTap: () {
          //                 if (!(widget?.model?.pointUserId
          //                         ?.contains(user.uid) ??
          //                     true)) widget?.model?.point++;
          //                 int tempPoint = widget?.model?.point ?? 0;
          //
          //                 setState(() {});
          //                 widget?.upPoint?.call(tempPoint);
          //               },
          //               child: Icon(
          //                 Icons.arrow_drop_up,
          //                 size: 30,
          //               ),
          //             ),
          //             Text(
          //               "${widget?.model?.point ?? 0}",
          //               style: TextStyle(fontSize: 10.0),
          //             ),
          //             InkWell(
          //               onTap: () {
          //                 if (!(widget?.model?.pointUserId
          //                         ?.contains(user.uid) ??
          //                     true)) widget?.model?.point--;
          //                 int tempPoint = widget?.model?.point ?? 0;
          //
          //                 setState(() {});
          //                 widget?.downPoint?.call(tempPoint);
          //               },
          //               child: Icon(
          //                 Icons.arrow_drop_down,
          //                 size: 30,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Expanded(
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 20, vertical: 15),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Text(
          //                     "${widget?.model?.authorName ?? ""}",
          //                     style: TextStyle(
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.bold,
          //                       color: Color(0xFF0C1A35),
          //                     ),
          //                   ),
          //                   //   Icon(Icons.arrow_drop_down),
          //                 ],
          //               ),
          //               Text(
          //                 '${widget?.model?.answerDescription ?? ""}',
          //                 style: TextStyle(
          //                   fontSize: 15,
          //                   color: Color(0xFF0C1A35),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Visibility(
          //             visible: true,
          //             child: InkWell(
          //               onTap: () {
          //                 if (widget?.postUserId == user?.uid.toString() ||
          //                     homePageController.isAdminUser.value == true) {
          //                   widget?.model?.isCorrect =
          //                       !(widget?.model?.isCorrect ?? false);
          //                   widget?.isCorrect
          //                       ?.call((widget?.model?.isCorrect ?? false));
          //
          //                   setState(() {});
          //                 }
          //               },
          //               child: Container(
          //                 child: Icon(
          //                   CorrectIcon.correct_image,
          //                   size: 20.0,
          //                   color: (widget?.model?.isCorrect ?? false) == true
          //                       ? Colors.green
          //                       : Colors.grey,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 5,
          //           ),
          //           InkWell(
          //             onTap: () {
          //               hideReply = !hideReply;
          //               setState(() {});
          //             },
          //             child: Icon(
          //               hideReply
          //                   ? Icons.keyboard_arrow_down
          //                   : Icons.keyboard_arrow_up,
          //               size: 30,
          //               color: Colors.black,
          //             ),
          //           ),
          //         ],
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: false // widget.model.replyList.length > 0
          //       ? const EdgeInsets.only(left: 40.0)
          //       : const EdgeInsets.only(left: 0.0),
          //   child: Divider(
          //     thickness: 2,
          //   ),
          // ),
          // if (hideReply == false)
          //   ...Iterable.generate(
          //     widget?.model?.replyList?.length,
          //     (i) => InkWell(
          //       onLongPress: () {
          //         if (homePageController.isAdminUser.value == true ||
          //             widget.formPostModel.isPostOwner(
          //                 homePageController.currentUserModel.uid.toString()) ||
          //             widget.formPostModel.answeredList[widget.answerIndex]
          //                 .isAnswerOwner(homePageController.currentUserModel.uid
          //                     .toString()) ||
          //             widget.model.replyList[i].isAnswerReplyOwner(
          //                 homePageController.currentUserModel.uid.toString())) {
          //           DialogRouter.displayConfirmDialog(
          //               titleText: "Delete!!!",
          //               bodyText: "Do you want to delete the reply?",
          //               context: context,
          //               noPress: () {
          //                 AppRouter.back();
          //               },
          //               yesPress: () {
          //                 print("tttt  test");
          //                 widget?.onReplyDelete?.call(i);
          //                 AppRouter.back();
          //               });
          //         }
          //       },
          //       child: Column(
          //         children: [
          //           Container(
          //             padding: const EdgeInsets.only(
          //                 left: 40, right: 20, top: 0, bottom: 15),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Text(
          //                       "${widget?.model?.replyList[i]?.authorName}",
          //                       style: TextStyle(
          //                         fontSize: 14,
          //                         fontWeight: FontWeight.bold,
          //                         color: Color(0xFF0C1A35),
          //                       ),
          //                     ),
          //                     InkWell(
          //                       onTap: () {
          //                         hideReply = true;
          //                         setState(() {});
          //                       },
          //                       child: Icon(Icons.arrow_drop_up),
          //                     ),
          //                   ],
          //                 ),
          //                 Text(
          //                   "${widget?.model?.replyList[i]?.replyDescription}",
          //                   style: TextStyle(
          //                     fontSize: 13,
          //                     color: Color(0xFF0C1A35),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 40.0),
          //             child: Divider(
          //               thickness: 2,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
