import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String bodyText;
  final String titleText;
  final Function yesPress;
  final Function noPress;

  ConfirmDialog({
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
                    height: 200,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "${titleText ?? "444"}",
                              style: textStyle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "$bodyText",
                          style: textStyle,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: RoundBoarderButtonPro(
                                onPress: noPress,

                                text: "No",
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
                                text: "Yes",
                                backGroundColor: Colors.red,
                                // text: LangKey.Yes.tr(),
                                onPress: yesPress,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        )
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
    this.borderRadius = 10.0,
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
  var defaultBorderRadius = 10.0;

  final textStyle = TextStyle(
    // fontFamily: FontName.rubikBold,
    fontWeight: FontWeight.normal,
    fontSize: 20.0,
  );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FlatButton(
        padding: widget.padding ?? EdgeInsets.symmetric(vertical: 10),
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
                fontSize: widget?.textFontSize ?? 18.0,
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
