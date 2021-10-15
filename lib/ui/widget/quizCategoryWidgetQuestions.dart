import 'package:critical_x_quiz/ui/constant/image_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

class QuizCategoryWidgetQuestions extends StatelessWidget {
  final String title;
  final String imgPath;
  final Function onTap;
  final Function(String categoryName) getCategoryName;
  final int questionLength;

  QuizCategoryWidgetQuestions(
      {this.title,
      this.imgPath,
      this.onTap,
      this.getCategoryName,
      this.questionLength});

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;

    return GestureDetector(
      onTap: () {
        onTap?.call();
        getCategoryName?.call(title);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: GetUtils.isURL(imgPath)
                        ? NetworkImage(imgPath)
                        : AssetImage(ImageName.noImage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Text(
              "$title",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: Color(0xFF0C1A35),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              " (${questionLength?.toString() ?? 0})",
              style: TextStyle(
                  color: Color(0xFF0C1A35),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
