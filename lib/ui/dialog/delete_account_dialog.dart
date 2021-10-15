import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatelessWidget {
  final String bodyText;
  final String titleText;
  final Function yesPress;
  final Function noPress;

  DeleteAccountDialog({
    this.bodyText,
    this.titleText,
    this.noPress,
    this.yesPress,
  });

  final textStyle = TextStyle(
    // fontFamily: FontName.rubikBold,
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black.withAlpha(200),
      child: Center(
        child: new Container(
          padding: const EdgeInsets.all(30.0),
          child: new GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          'images/deleteAccount.png',
                          height: 60,
                          width: 80,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "${titleText ?? "444"}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "$bodyText",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: RoundBoarderButtonPro(
                                onPress: noPress,
                                height: 5,

                                text: "Cancel",
                                //text: LangKey.No.tr(),
                                textColor: Colors.green,
                                backGroundColor: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: RoundBoarderButtonPro(
                                height: 5,
                                text: "Delete",
                                backGroundColor: Colors.red,
                                // text: LangKey.Yes.tr(),
                                onPress: yesPress,
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                        SizedBox()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoundBoarderButtonPro extends StatefulWidget {
  RoundBoarderButtonPro({
    @required this.text,
    this.onPress,
    this.backGroundColor,
    this.borderRadius = 5.0,
    this.textColor,
    this.height,
    this.padding,
    this.textFontSize,
  });

  final text;
  final Function onPress;
  final Color backGroundColor;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double textFontSize;
  final EdgeInsets padding;

  @override
  _RoundBoarderButtonState createState() => _RoundBoarderButtonState();
}

class _RoundBoarderButtonState extends State<RoundBoarderButtonPro> {
  var defaultBorderRadius = 5;

  final textStyle = TextStyle(
    // fontFamily: FontName.rubikBold,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FlatButton(
        padding: widget.padding ?? EdgeInsets.symmetric(vertical: 0),
        color: widget.backGroundColor != null
            ? widget.backGroundColor
            : Color(0xff027D3F),
        disabledColor: widget.backGroundColor != null
            ? widget.backGroundColor
            : Color(0xff027D3F),
        onPressed: widget.onPress,
        child: Align(
            alignment: Alignment.center,
            child: Text(
              '${widget.text}',
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                color:
                    widget.textColor != null ? widget.textColor : Colors.white,
                fontSize: widget?.textFontSize ?? 14.0,
              ),
            )),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius != null
              ? widget.borderRadius
              : defaultBorderRadius),
          borderSide: BorderSide(
            color: widget.backGroundColor != null
                ? widget.backGroundColor
                : Color(0xff027D3F),
            style: widget.backGroundColor != null
                ? BorderStyle.solid
                : BorderStyle.none,
          ),
        ),
      ),
    );
  }
}
