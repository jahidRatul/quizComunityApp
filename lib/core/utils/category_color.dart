import 'package:flutter/material.dart';

class CategoryColor {
  static Color getCategoryColor(int i, {String form}) {
    int c = i % 30;
    print("color found int ::$form $c");
    return getColorMap()[c];
  }

  static Map<int, Color> getColorMap() {
    int i = 0;
    Map<int, Color> colormap = new Map();

    colormap[0] = Color(0xff01c5c4);
    colormap[1] = Color(0xffb8de6f);
    colormap[2] = Color(0xfff1e189);
    colormap[3] = Color(0xfff39233);
    colormap[4] = Color(0xffee6f57);
    colormap[5] = Color(0xff1f3c88);
    colormap[6] = Color(0xff070d59);
    colormap[7] = Color(0xff94b4a4);
    colormap[8] = Color(0xffd2f5e3);
    colormap[9] = Color(0xffe5c5b5);
    colormap[10] = Color(0xff7e78dc);
    colormap[11] = Color(0xff99004d);
    colormap[12] = Color(0xff008000);
    colormap[13] = Color(0xff4C4C4C);
    colormap[14] = Color(0xffff00ff);
    colormap[15] = Color(0xffff0374);
    colormap[16] = Color(0xff000000);
    colormap[17] = Color(0xff668c39);
    colormap[18] = Color(0xff990099);
    colormap[19] = Color(0xff261A15);
    colormap[20] = Color(0xffeb4c34);
    colormap[21] = Color(0xff2c1c40);
    colormap[22] = Color(0xff150f1c);
    colormap[23] = Color(0xff5581a6);
    colormap[24] = Color(0xff559e94);
    colormap[25] = Color(0xffb07d4d);
    colormap[26] = Color(0xffd9cbbf);
    colormap[27] = Color(0xff8bab74);
    colormap[28] = Color(0xff1c2914);
    colormap[29] = Color(0xffded371);
    colormap[30] = Color(0xff403c1d);
    return colormap;
  }
}
