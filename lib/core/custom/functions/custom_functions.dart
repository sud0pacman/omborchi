import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:omborchi/core/utils/consants.dart';

void closeDialog(BuildContext context, {dynamic arg}) {
  Navigator.of(context, rootNavigator: true).pop(arg);
}

void closeScreen(BuildContext context, {dynamic arg}) {
  Navigator.of(context).pop(arg);
}

Future<void> setUpdateTime(DateTime now) async {
  final box = Hive.box(ExpenseFields.myBox);
  return await box.put(
    LastUpdates.type,
    now.toUtc().toIso8601String(),
  );
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
