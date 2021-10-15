import 'package:critical_x_quiz/core/model/form_post_model/form_post_model.dart';
import 'package:critical_x_quiz/core/utils/app_utils.dart';
import 'package:critical_x_quiz/ui/constant/image_name.dart';
import 'package:critical_x_quiz/ui/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

class FormPostItemCard extends StatefulWidget {
  final FormPostModel model;
  final Function onDelete;

  FormPostItemCard(
    this.model, {
    this.onDelete,
  });

  @override
  _FormPostItemCardState createState() => _FormPostItemCardState();
}

class _FormPostItemCardState extends State<FormPostItemCard> {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return GestureDetector(
      onTap: () {
        AppRouter.navToForumDiscussion(widget.model);
      },
      onLongPress: widget?.onDelete,
      child: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: GetUtils.isURL(
                                          widget?.model?.categoryImage ?? "")
                                      ? NetworkImage(
                                          widget?.model?.categoryImage)
                                      : AssetImage(
                                          '${ImageName.noImage}',
                                        ),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                //'Cardiac',
                                "${widget?.model?.category}",
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
                        // '1 hr ago',
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
                  Container(
                    width: wp(100),
                    child: Text(
                      '${widget?.model?.questionDescription}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0C1A35),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: widget.model.imageList.length > 0,
                    child: Container(
                      height:
                          90, // widget.model.imageList.length > 0 ? 90 : 0.0,
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
                              image:
                                  NetworkImage('${widget.model.imageList[i]}'),
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
                            AppRouter.navToForumDiscussion(widget.model);
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
                      )
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}
