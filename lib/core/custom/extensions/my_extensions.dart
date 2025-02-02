import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

String getInitials(String fullName) {
  if (fullName.isEmpty) return '';

  List<String> names = fullName.split(' ');

  String initials =
      names.map((name) => name.isNotEmpty ? name[0].toUpperCase() : '').join();

  return initials;
}

class Util {
  static int _counter = 0;
  static final int _epochStart =
      DateTime(DateTime.now().year).millisecondsSinceEpoch;

  static int iid() {
    final int currentTime = DateTime.now().millisecondsSinceEpoch - _epochStart;
    final int uniqueCounter = _counter++;
    return currentTime * 100 + uniqueCounter % 100;
  }

  static String sid() {
    final int currentTime = DateTime.now().millisecondsSinceEpoch - _epochStart;
    final int uniqueCounter = _counter++;
    return (currentTime * 100 + uniqueCounter % 100).toString();
  }
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void changeStatusBarToDark() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
  ));
}

void changeStatusBarColor(Color color) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color,
  ));
}

void changeStatusBarToLight() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));
}

String formatDistance(double meters) {
  if (meters >= 1000) {
    double kilometers = meters / 1000;
    return '${kilometers.toStringAsFixed(1)} km';
  } else {
    return '${meters.toStringAsFixed(0)} m';
  }
}

T inject<T extends Object>() => GetIt.I.get<T>();

Future<T> injectAsync<T extends Object>() async => GetIt.I.getAsync<T>();

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
}

extension AssetExtension on String {
  String get pngIcon => 'assets/images/$this.png';

  String get svgIcon => 'assets/icons/$this.svg';
}

String separateBalance(String number) {
  if (number.length < 4) {
    return number;
  } else {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

String convertDate(String inputDate) {
  DateTime date = DateTime.parse(inputDate);
  DateFormat formatter = DateFormat('dd MMMM EEEE');
  String formattedDate = formatter.format(date);
  return formattedDate;
}

String convertDate2(String inputDate) {
  DateTime date = DateTime.parse(inputDate);
  DateFormat formatter = DateFormat('dd MMMM');
  String formattedDate = formatter.format(date);
  return formattedDate;
}

String convertDate3(String inputDate) {
  DateTime date = DateTime.parse(inputDate);
  DateFormat formatter = DateFormat('MMMM');
  String formattedDate = formatter.format(date);
  return formattedDate;
}

// Future<File> compressAndLoadImage(String imagePath) async {
//   final result = await FlutterImageCompress.compressAndGetFile(
//     imagePath,
//     '${imagePath}_compressed.jpg',
//     quality: 60,
//   );
//   return File(result!.path);
// }

class MoneyTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String old =
        oldValue.text.replaceAll(",", ".").replaceAll(RegExp(r"[^0-9.]"), "");
    String text =
        newValue.text.replaceAll(",", ".").replaceAll(RegExp(r"[^0-9.]"), "");
    text = format(text, old: old);
    TextSelection selection = TextSelection.collapsed(offset: text.length);
    return TextEditingValue(text: text, selection: selection);
  }

  static String format(String input, {String old = ""}) {
    String text = input;
    bool decimalMode = text.contains(".");

    if (text == ".") {
      text = "0";
    } else if (text.endsWith('.') && old.contains('.')) {
      text = text.substring(0, text.length - 1);
      decimalMode = false;
    } else if (!old.endsWith('.') && text.endsWith('.')) {
      decimalMode = true;
    }

    if (decimalMode && text.substring(text.indexOf('.') + 1).length > 2) {
      text = text.replaceRange(text.length - 1, text.length, "");
    }
    final value = double.tryParse(text);
    if (value != null) {
      final formatter = NumberFormat("#,##0.00", 'en_US');
      String money = formatter.format(value).replaceAll(",", " ");
      if (decimalMode) {
        money = money.replaceAll(".00", (text.endsWith('0')) ? ".0" : ".");
        final decimalPart = money.substring(money.length - 2);
        if (decimalPart[0] != '.' && decimalPart[1] == '0') {
          money = money.substring(0, money.length - 1);
        }
      } else {
        money = money.replaceAll(".00", "");
      }
      if (money.isNotEmpty) text = money;
    }
    return text;
  }
}

extension StringExtensions on String {
  bool isImageUrl() {
    return startsWith('http://') || startsWith('https://');
  }

  bool isFilePath() {
    return startsWith('/') || startsWith(RegExp(r'^[a-zA-Z]:\\'));
  }
}
