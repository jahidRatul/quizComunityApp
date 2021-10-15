import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class ExampleItem {
  static const Pineapples = ExampleItem._('Pineapples');
  static const Watermelons = ExampleItem._('Watermelons');
  static const StarFruit = ExampleItem._('Star Fruit');
  static const StarFruit2 = ExampleItem._('Star Fruit');
  static const StarFruit3 = ExampleItem._('Star Fruit');
  static const values = [
    Pineapples,
    Watermelons,
    StarFruit,
    StarFruit2,
    StarFruit3,
  ];

  const ExampleItem._(this.text);

  final String text;
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Color(0xFFFAFAE0),
        primaryColor: Color(0xFFE9A663),
        buttonColor: Color(0xFFE9A663),
        textTheme: TextTheme(
          button: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      home: ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  ExampleItem _current;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: DropdownMenu<ExampleItem>(
          initialValue: _current,
          onSelected: (item) {
            setState(() => _current = item);
          },
          onCanceled: () {
            setState(() => _current = null);
          },
          itemBuilder: (BuildContext context) {
            return List<PopupMenuEntry<ExampleItem>>.generate(
                ExampleItem.values.length * 2 - 1, (int index) {
              if (index.isEven) {
                final item = ExampleItem.values[index ~/ 2];
                return DropdownMenuItem<ExampleItem>(
                    value: item, text: item.text);
              } else {
                return DropdownDivider();
              }
            });
          },
          child: Text(_current == null ? 'Dropdown' : _current.text),
        ),
      ),
    );
  }
}

class DropdownMenuItem<T> extends PopupMenuEntry<T> {
  const DropdownMenuItem({
    Key key,
    this.value,
    @required this.text,
  })  : assert(text != null),
        super(key: key);

  final T value;

  final String text;

  @override
  _DropdownMenuItemState<T> createState() => _DropdownMenuItemState<T>();

  @override
  double get height => 32.0;

  @override
  bool represents(T value) => this.value == value;
}

class _DropdownMenuItemState<T> extends State<DropdownMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop<T>(widget.value),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class DropdownDivider<T> extends PopupMenuEntry<T> {
  @override
  _DropdownDividerState<T> createState() => _DropdownDividerState<T>();

  @override
  double get height => 1.0;

  @override
  bool represents(T value) => false;
}

class _DropdownDividerState<T> extends State<DropdownDivider<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(height: 1.0, color: Colors.grey.shade400),
    );
  }
}

class DropdownMenu<T> extends StatefulWidget {
  const DropdownMenu({
    Key key,
    @required this.itemBuilder,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    @required this.child,
  }) : super(key: key);

  final PopupMenuItemBuilder<T> itemBuilder;
  final T initialValue;
  final PopupMenuItemSelected<T> onSelected;
  final PopupMenuCanceled onCanceled;
  final Widget child;

  @override
  _DropdownMenuState<T> createState() => _DropdownMenuState<T>();
}

class _DropdownMenuState<T> extends State<DropdownMenu<T>>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _rotation = Tween<double>(begin: 0.0, end: 180.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.elasticOut,
          reverseCurve: Curves.easeInExpo),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return RaisedButton(
          onPressed: _showPopup,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          colorBrightness: Brightness.dark,
          child: AnimatedSize(
            duration: _controller.duration ~/ 2,
            curve: Curves.fastOutSlowIn,
            vsync: this,
            child: Row(
              key: Key(widget.initialValue?.toString() ?? ''),
              mainAxisSize: constraints.hasTightWidth
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                widget.child,
                const SizedBox(width: 8.0),
                AnimatedBuilder(
                  animation: _rotation,
                  builder: (BuildContext context, Widget child) {
                    return Transform.rotate(
                      angle: radians(_rotation.value),
                      child: child,
                    );
                  },
                  child: Icon(Icons.keyboard_arrow_up, size: 28.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPopup() {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final Rect position = Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero),
          ancestor: overlay),
    );
    final buttonColor = Theme.of(context).buttonColor;
    final route = _PopupMenuRoute<T>(
      initialValue: widget.initialValue,
      items: widget.itemBuilder(context),
      position: position,
      shadow:
          BoxShadow(color: buttonColor, blurRadius: 6.0, spreadRadius: -2.0),
    );
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      return Navigator.of(context, rootNavigator: true)
          .push<T>(route)
          .then((T result) {
        if (!mounted) {
          return;
        }
        if (result == null) {
          widget.onCanceled?.call();
        } else {
          widget.onSelected?.call(result);
        }
        _controller.reverse();
      });
    });
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    this.initialValue,
    @required this.items,
    @required this.position,
    this.shadow = const BoxShadow(
        color: Colors.black26, blurRadius: 6.0, spreadRadius: -2.0),
  });

  final List<PopupMenuEntry<T>> items;
  final T initialValue;
  final Rect position;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  final BoxShadow shadow;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondary, Widget child) {
    final opacity =
        CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
    final top = Tween<double>(begin: position.top, end: position.bottom)
        .animate(opacity);
    return FadeTransition(
      opacity: opacity,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: top.value,
                left: position.left,
                width: position.width,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: position.width,
                    maxWidth: position.width,
                    minHeight: 0.0,
                    maxHeight: constraints.maxHeight - position.bottom,
                  ),
                  child: child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _PopupPanel(
      items: items,
      padding: EdgeInsets.only(top: 4.0),
      shadow: shadow,
    );
  }
}

/// Popup panel of list items
class _PopupPanel<T> extends StatelessWidget {
  const _PopupPanel({
    Key key,
    @required this.items,
    this.pointerPosition = 0.9,
    this.pointerSize = 8.0,
    this.padding,
    this.shadow = const BoxShadow(
        color: Colors.black26, blurRadius: 6.0, spreadRadius: -2.0),
  })  : assert(padding != null),
        super(key: key);

  final List<PopupMenuEntry<T>> items;
  final double pointerPosition;
  final double pointerSize;
  final EdgeInsets padding;
  final BoxShadow shadow;

  @override
  Widget build(BuildContext context) {
    final border = _PopupPanelBorder(
      side: BorderSide(color: Colors.grey.shade300, width: 1.0),
      borderRadius: BorderRadius.circular(2.0),
      pointerPosition: pointerPosition,
      pointerSize: pointerSize,
      color: Colors.white,
      shadow: shadow,
    );
    return Padding(
      padding: padding + EdgeInsets.only(top: pointerSize, bottom: pointerSize),
      child: Container(
        decoration: BoxDecoration(border: border),
        child: Material(
          type: MaterialType.transparency,
          child: ListView(
            primary: false,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: items,
          ),
        ),
      ),
    );
  }
}

/// Custom popup panel border with pointer positioned along the top edge.
class _PopupPanelBorder extends BoxBorder {
  const _PopupPanelBorder({
    this.side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.pointerPosition = 0.9,
    this.pointerSize = 8.0,
    this.color,
    this.shadow,
  })  : assert(side != null),
        assert(borderRadius != null);

  /// The style of this border.
  final BorderSide side;

  @override
  BorderSide get top => side;

  @override
  BorderSide get bottom => side;

  @override
  bool get isUniform => true;

  /// The radii for each corner.
  final BorderRadiusGeometry borderRadius;

  /// The fraction across the top edge the pointer should align to.
  final double pointerPosition;

  /// The size of the pointer in logical pixels.
  final double pointerSize;

  final Color color;

  final BoxShadow shadow;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) {
    return _PopupPanelBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect.deflate(side.width), textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    final radius = borderRadius.resolve(textDirection);
    final roundedRect = radius.toRRect(rect);
    final pointerRect = roundedRect.middleRect.inflate(-pointerSize);
    final pointerPos = pointerRect.left +
        (pointerRect.width * pointerPosition.clamp(0.0, 1.0));
    return Path.combine(
      PathOperation.union,
      Path()..addRRect(roundedRect),
      Path()
        ..moveTo(pointerPos, rect.top - pointerSize)
        ..lineTo(pointerPos + pointerSize, rect.top)
        ..lineTo(pointerPos - pointerSize, rect.top)
        ..close(),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection textDirection,
      BoxShape shape = BoxShape.rectangle,
      BorderRadius borderRadius}) {
    final path = getOuterPath(rect, textDirection: textDirection);
    if (shadow != null) {
      final scale = 1.0 + shadow.spreadRadius / 100;
      final center = rect.center;
      final m = Matrix4.translationValues(center.dx, center.dy, 0.0)
        ..scale(scale, scale)
        ..translate(-center.dx, -center.dy);
      canvas.drawPath(path.transform(m.storage), shadow.toPaint());
    }
    if (color != null) {
      canvas.drawPath(path, Paint()..color = color);
    }
    if (side.style == BorderStyle.solid) {
      canvas.drawPath(path, side.toPaint());
    }
  }
}
