import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

class CommentInputView extends StatefulWidget {
  final Function(String v) onComment;
  final Function() onSend;
  final Function() onTap;
  final double height;
  final Function() replyComment;
  final Function() visibleCommentPost;

  CommentInputView({
    this.replyComment,
    this.height,
    this.onComment,
    this.onSend,
    this.onTap,
    this.visibleCommentPost,
  });

  @override
  _CommentInputViewState createState() => _CommentInputViewState();
}

class _CommentInputViewState extends State<CommentInputView> {
  FocusNode commentNode = FocusNode();

  allUnFocus() {
    commentNode?.unfocus();
  }

  TextEditingController commentController = new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xff0C1A35)),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(
        width: wp(100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              child: Center(
                child: IconButton(
                    onPressed: () {
                      widget.replyComment();
                      widget.visibleCommentPost();
                    },
                    icon: Icon(
                      Icons.cancel,
                      size: 20,
                    )),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                height: widget?.height,
                child: Center(
                  child: TextFormField(
                    onTap: widget.onTap,
                    onChanged: (v) {
                      widget?.onComment?.call(v);
                    },
                    focusNode: commentNode,
                    controller: commentController,
                    onFieldSubmitted: (v) {
                      allUnFocus();
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write a Comment",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                allUnFocus();
                commentController.clear();
                widget?.onSend?.call();
              },
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 40,
                width: 50,
                decoration: BoxDecoration(
                  // color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                    child: Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff25AFA2),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
