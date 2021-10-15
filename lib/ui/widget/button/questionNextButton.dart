import 'package:flutter/material.dart';

class QuestionNextButton extends StatefulWidget {
  QuestionNextButton({
    @required this.text,
    this.onPress,
    this.backGroundColor,
    this.borderRadius = 20.0,
    this.textColor,
  });

  final text;
  final Function onPress;
  final Color backGroundColor;
  final Color textColor;
  final double borderRadius;

  @override
  _QuestionNextButtonState createState() => _QuestionNextButtonState();
}

class _QuestionNextButtonState extends State<QuestionNextButton> {
  var defaultBorderRadius = 20.0;

  final textStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 20.0, top: 15.0, bottom: 15.0),
      child: Align(
        alignment: Alignment.center,
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
          color: widget.backGroundColor != null
              ? widget.backGroundColor
              : Color(0xFF2A63D4),
          disabledColor: widget.backGroundColor != null
              ? widget.backGroundColor
              : Color(0xFF2A63D4),
          onPressed: widget.onPress,
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.text}',
                    textAlign: TextAlign.center,
                    style: textStyle.copyWith(
                        color: widget.textColor != null
                            ? widget.textColor
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0),
                  )),
            ],
          ),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius != null
                ? widget.borderRadius
                : defaultBorderRadius),
            borderSide: BorderSide(
              color: widget.backGroundColor != null
                  ? widget.backGroundColor
                  : Color(0xFF2A63D4),
              style: widget.backGroundColor != null
                  ? BorderStyle.solid
                  : BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }
}
