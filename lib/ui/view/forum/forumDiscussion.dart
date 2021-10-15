import 'package:critical_x_quiz/core/controller/forum_discussion_controller.dart';
import 'package:critical_x_quiz/core/controller/home_page_controller.dart';
import 'package:critical_x_quiz/core/model/form_post_model/form_post_model.dart';
import 'package:critical_x_quiz/core/utils/app_utils.dart';
import 'package:critical_x_quiz/ui/botton_sheet/comment_input_view_post.dart';
import 'package:critical_x_quiz/ui/constant/image_name.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:critical_x_quiz/ui/view/home/card/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

class ForumDiscussion extends StatefulWidget {
  static String id = 'forumDiscussion';
  final FormPostModel model;

  ForumDiscussion(this.model);

  @override
  _ForumDiscussionState createState() => _ForumDiscussionState();
}

class _ForumDiscussionState extends State<ForumDiscussion> {
  int currentIndex = 2;
  int _value;
  bool revers = false;
  bool postComment = true;
  String comment;
  ScrollController _scrollController = new ScrollController();
  FormPostModel m;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    isActiveState = true;

    widget?.model?.toListen(listen: (d) {
      if (isActiveState) setState(() {});
    });

    /* m = widget.model.copy();
    m.toListen(listen: (d) {
      setState(() {});
    });*/
  }

  bool isLengthNull() {
    if ((widget?.model?.answeredList?.length ?? 0) == 0) {
      postComment = true;
      return true;
    }

    return postComment;
  }

  bool isActiveState = false;

  @override
  void dispose() {
    // TODO: implement dispose
    isActiveState = false;
    m?.cancel();
    widget?.model?.cancel();
    _scrollController?.dispose();

    super.dispose();
  }

  bool _needScroll = true;

  _scrollToEnd() async {
    if (_needScroll) {
      _needScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 400), curve: Curves.ease);
    }
  }

  scrollToLast() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // reverse: true,
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
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
                                      AppRouter.back();
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
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        onTap: () {
                          AppRouter.navToProfileScreen();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GetX<HomePageController>(
                                builder: (controller) {
                                  return Text(
                                    '${controller?.userName?.value}',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: GetUtils.isURL(
                                        widget?.model?.categoryImage ?? "")
                                    ? NetworkImage(widget?.model?.categoryImage)
                                    : AssetImage('${ImageName.noImage}'),
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget?.model?.category}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0C1A35),
                                    ),
                                  ),
                                  Text(
                                    'posted by ${widget?.model?.authName}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0C1A35),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Text(
                            '${AppUtils.timeAgo(widget.model.postTime)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0C1A35),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${widget?.model?.questionDescription}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF0C1A35),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible: (widget?.model?.imageList?.length ?? 0) > 0,
                        child: Container(
                          height: 90,
                          // widget.model.imageList.length > 0 ? 90 : 0.0,
                          //  width: 90,
                          child: ListView.builder(
                            itemCount: widget?.model?.imageList?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, i) => Container(
                              height: 90,
                              width: 90,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      '${widget?.model?.imageList[i]}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                "images/talkIcon.png",
                                height: 25,
                                width: 25,
                                color: Color(0xFFB7B7B7),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${widget?.model?.answeredList?.length ?? 0}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB7B7B7),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                            width: 140,
                            child: RaisedButton(
                              onPressed: () {
                                // AppRouter.navToForumDiscussion(widget.model);
                              },
                              color: widget?.model?.isAnswered == true
                                  ? Color(0xFF00C0B3)
                                  : Color(0xFFFD5959),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Text(
                                widget?.model?.isAnswered == true
                                    ? "Answered"
                                    : "Not answered",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color(0xFFE8E8E8),
                  height: 2,
                  width: wp(100),
                  /*  child: Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Container(
                                  //color: Colors.red,
                                  height: 25,
                                  child: RoundBoarderButtonPro(
                                    padding: EdgeInsets.all(0.0),
                                    textColor: Colors.white,
                                    text: "Reply",
                                    onPress: () {
                                      AppBottomSheet.showBottomSheet(context,
                                          child: CommentInputView());
                                    },
                                    textFontSize: 10,
                                    borderRadius: 25.0,
                                    backGroundColor: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),*/
                ),
                ListView(
                  controller: _scrollController,
                  // reverse: revers,
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...Iterable.generate(
                              (widget?.model?.answeredList?.length ?? 0),
                              (i) => GetBuilder<ForumDiscussionController>(
                                  init: ForumDiscussionController(),
                                  builder: (controller) {
                                    return CommentCard(
                                      widget.model.answeredList[i],
                                      answerIndex: i,
                                      hideReply: i != 0,
                                      formPostModel: widget.model,
                                      onDelete: () {
                                        controller.answerDelete(
                                            i, widget.model);
                                      },
                                      commentPostHide: () {
                                        postComment = false;

                                        setState(() {});
                                      },
                                      commentPostVisible: () {
                                        postComment = true;

                                        setState(() {});
                                      },
                                      onReplyDelete: (int replyIndex) {
                                        print("method called");
                                        controller.replyDelete(
                                            i, replyIndex, widget.model);
                                      },
                                      // onTap: () async {
                                      //   await AppRouter.navToAnswerReply(
                                      //       widget.model.answeredList[i],
                                      //       widget.model,
                                      //       i);
                                      //   setState(() {});
                                      // },
                                      postUserId: widget.model.authorUid,
                                      isCorrect: (b) async {
                                        print("form dis ");
                                        controller?.updateAnswerIsCorrect(
                                            i, b, widget.model);
                                      },
                                      upPoint: (u) {
                                        controller?.updateAnswerLike(
                                            i, widget.model);
                                      },
                                      downPoint: (d) {
                                        controller?.updateAnswerDisLike(
                                            i, widget.model);
                                      },
                                    );
                                  })),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: isLengthNull(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GetBuilder<ForumDiscussionController>(
                      init: ForumDiscussionController(),
                      builder: (controller) => CommentInputViewPost(
                        height: 50,
                        onTap: () {
                          //  scrollToLast();
                        },
                        onComment: (v) {
                          comment = v;
                        },
                        onSend: () {
                          if (comment != null) {
                            controller
                                .onCommentSubmit(comment, widget.model)
                                .then((value) {
                              //  revers = true;
                              comment = null;
                              scrollToLast();

                              print("comment updated");
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
