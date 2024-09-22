import 'package:flutter/widgets.dart';

void closeDialog(BuildContext context, {dynamic arg}) {
  Navigator.of(context, rootNavigator: true).pop(arg);
}

void closeScreen(BuildContext context, {dynamic arg}) {
  Navigator.of(context).pop(arg);
}