import 'package:flutter/material.dart';

class Utils {
  Future<void> showSheet(BuildContext context, WidgetBuilder builder) =>
      showModalBottomSheet(
        useRootNavigator: true,
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        context: context,
        builder: builder,
      );
}
