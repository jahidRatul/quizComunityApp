// import 'package:critical_x_quiz/core/controller/forum_discussion_controller.dart';
// import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
// import 'package:critical_x_quiz/core/model/form_post_model/form_post_answer_model.dart';
// import 'package:critical_x_quiz/core/model/form_post_model/form_post_answer_reply.dart';
// import 'package:critical_x_quiz/core/model/form_post_model/form_post_model.dart';
// import 'package:critical_x_quiz/ui/botton_sheet/comment_inpute_view.dart';
// import 'package:critical_x_quiz/ui/router/app_router.dart';
// import 'package:critical_x_quiz/ui/view/home/card/comment_card.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AnswerReplyPage extends StatefulWidget {
//   final FormPostAnswerModel model;
//   final FormPostModel formPostModel;
//   final int index;
//
//   AnswerReplyPage(this.model, this.formPostModel, this.index);
//
//   @override
//   _AnswerReplyPageState createState() => _AnswerReplyPageState();
// }
//
// class _AnswerReplyPageState extends State<AnswerReplyPage> {
//   String comment;
//   User user = FirebaseAuth.instance.currentUser;
//   ScrollController _scrollController = new ScrollController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
//     user = FirebaseAuth.instance.currentUser;
//     widget.formPostModel.toListen(listen: (d) {
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     widget?.formPostModel?.cancel();
//     _scrollController?.dispose();
//     super.dispose();
//   }
//
//   bool _needScroll = true;
//
//   _scrollToEnd() async {
//     if (_needScroll) {
//       _needScroll = false;
//       _scrollController.animateTo(_scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 400), curve: Curves.ease);
//     }
//   }
//
//   scrollToLast() {
//     _scrollController.animateTo(_scrollController.position.maxScrollExtent,
//         duration: Duration(milliseconds: 400), curve: Curves.ease);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           child: Column(
//             children: [
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     flex: 2,
//                     child: Row(
//                       children: [
//                         Padding(
//                             padding: const EdgeInsets.symmetric(),
//                             child: Container(
//                               alignment: Alignment.centerLeft,
//                               child: IconButton(
//                                   icon: Icon(
//                                     Icons.arrow_back_ios,
//                                     color: Color(0xFF141414),
//                                     size: 16,
//                                   ),
//                                   onPressed: () {
//                                     AppRouter.back();
//                                   }),
//                             )),
//                         Text(
//                           'Forum',
//                           style: TextStyle(
//                             color: Color(0xFF0C1A35),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: InkWell(
//                       borderRadius: BorderRadius.all(Radius.circular(30)),
//                       onTap: () {
//                         AppRouter.navToProfileScreen();
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             GetX<HomePageController>(
//                               builder: (controller) {
//                                 return Text(
//                                   '${controller?.userName?.value}',
//                                   style: TextStyle(
//                                     color: Color(0xFF0C1A35),
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 13,
//                                   ),
//                                 );
//                               },
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             GetX<HomePageController>(
//                               builder: (controller) => CircleAvatar(
//                                 backgroundImage: NetworkImage(controller
//                                         .proImage.value ??
//                                     'https://www.woolha.com/media/2020/03/eevee.png'),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: ListView(
//                   // reverse: true,
//                   controller: _scrollController,
//                   children: [
//                     GetBuilder<ForumDiscussionController>(
//                       builder: (controller) => CommentCard(
//                         widget.formPostModel.answeredList[widget.index],
//                         answerIndex: widget.index,
//                         onDeletePermission: false,
//                         hideReply: false,
//                         onReplyDelete: (int replyIndex) {
//                           controller.replyDelete(
//                               widget.index, replyIndex, widget.formPostModel);
//                         },
//                         onTap: () {},
//                         formPostModel: widget.formPostModel,
//                         postUserId: widget.formPostModel.authorUid,
//                         isCorrect: (b) async {
//                           print("isCorrect");
//
//                           if (true) {
//                             await controller?.updateAnswerIsCorrect(
//                               widget.index,
//                               b,
//                               widget.formPostModel,
//                             );
//                             setState(() {});
//                           }
//                         },
//                         upPoint: (u) {
//                           controller?.updateAnswerPoint(
//                               widget.index, u, 0, widget.formPostModel);
//                           setState(() {});
//                         },
//                         downPoint: (d) {
//                           controller?.updateAnswerPoint(
//                               widget.index, 0, d, widget.formPostModel);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               GetBuilder<ForumDiscussionController>(
//                 init: ForumDiscussionController(),
//                 builder: (controller) => CommentInputView(
//                   onTap: () {
//                     scrollToLast();
//                   },
//                   onComment: (v) {
//                     comment = v;
//                   },
//                   onSend: () {
//                     if (comment != null) {
//                       FormPostAnswerReplyModel reply =
//                           new FormPostAnswerReplyModel(
//                         authorName: "${user.displayName}",
//                         authorUid: "${user.uid}",
//                         replyDescription: "$comment",
//                       );
//                       widget.formPostModel.answeredList[widget.index].replyList
//                           .add(reply);
//                       setState(() {});
//                       controller
//                           .onCommentReplySubmit(widget.formPostModel)
//                           .then((value) {
//                         comment = null;
//                         scrollToLast();
//
//                         print("comment updated");
//                       });
//
//                       comment = null;
//                     }
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
