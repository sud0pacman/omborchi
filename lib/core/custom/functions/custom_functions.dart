import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:omborchi/core/utils/consants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
bool isValidUrl(String input) {
  final uri = Uri.tryParse(input);
  return uri != null &&
      (uri.hasScheme && uri.hasAuthority) &&
      (uri.scheme == 'http' || uri.scheme == 'https');
}

void enableWakelock() {
  WakelockPlus.enable();
}

void disableWakelock() {
  WakelockPlus.disable();
}

String roundMoney(int amount) {
  int roundedAmount = (amount + 50) ~/ 100 * 100;
  return roundedAmount.toString();
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

String replaceSpaceWithX(String input) {
  // String ichidagi birinchi bo'shliq indeksini topamiz
  int spaceIndex = input.indexOf(' ');

  // Agar bo'shliq topilgan bo'lsa, uni " X " bilan almashtiramiz
  if (spaceIndex != -1) {
    return '${input.substring(0, spaceIndex)} X ${input.substring(spaceIndex + 1)}';
  }

  // Agar bo'shliq bo'lmasa, asl stringni qaytaramiz
  return input;
}

int removeNonDigits(String input) {
  return int.parse(input.replaceAll(RegExp(r'\D'), ''));
}

extension StringExtensions on String {
  int toIntOrZero() {
    return convertToInt(this);
  }
}

int convertToInt(String number) {
  if (number.isEmpty) {
    return 0;
  }

  String cleanedNumber = number.replaceAll(',', '');

  // Convert the cleaned string to an integer
  return int.parse(cleanedNumber);
}

Future<bool?> navigateToRoute(BuildContext context, String routeName) async {
  return await Navigator.pushNamed<bool?>(context, routeName);
}

Future<void> requestManageExternalStoragePermission() async {
  if (await Permission.manageExternalStorage.request().isGranted) {
    print('Permission granted');
  } else {
    print('Permission denied');
  }
}
