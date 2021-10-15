import 'package:flutter/material.dart';

class AppBottomSheet {
  static showBottomSheet(BuildContext context, {Widget child}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (builder) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          maxChildSize: 1,
          minChildSize: 0.3,
          builder: (BuildContext context, ScrollController scrollController) {
            return child;
          },
        );
      },
    );
  }
}
