import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';

// Text Styles
const TextStyle pregular = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "nunitoregular",
);

const TextStyle pmedium = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "nunitomedium",
);

const TextStyle psemibold = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "nunitosemibold",
);

const TextStyle pbold = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "nunitobold",
);

const TextStyle plight = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "nunitolight",
);

const TextStyle semiBoldWhite = TextStyle(
  color: AppColors.white,
  fontFamily: "nunitosemibold",
  fontSize: 23,
);

const TextStyle semiBold = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "nunitomedium",
  fontSize: 20,
);

const TextStyle semiBoldTheme = TextStyle(
  color: AppColors.primary,
  fontFamily: "nunitosemibold",
  fontSize: 18,
);

const TextStyle mediumWhite = TextStyle(
  color: AppColors.white,
  fontFamily: "nunitomedium",
  fontSize: 20,
);

const TextStyle medium = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "nunitomedium",
  fontSize: 20,
);

const TextStyle mediumTheme = TextStyle(
  color: AppColors.primary,
  fontFamily: "nunitomedium",
  fontSize: 20,
);

const TextStyle boldWhite = TextStyle(
  color: AppColors.white,
  fontFamily: "nunitobold",
  fontSize: 16,
);

const TextStyle boldTheme = TextStyle(
  color: AppColors.primary,
  fontFamily: "nunitobold",
  fontSize: 23,
);

const TextStyle blackWhite = TextStyle(
  color: AppColors.white,
  fontFamily: "nunitobold", // Assuming no specific black weight in Nunito
  fontSize: 22,
);

const TextStyle regularWhite = TextStyle(
  color: AppColors.white,
  fontFamily: "nunitoregular",
  fontSize: 16,
);

const TextStyle bold = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "nunitobold",
  fontSize: 16,
);

const TextStyle regular = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "nunitoregular",
  fontSize: 16,
);

const TextStyle regularEmpress = TextStyle(
  color: AppColors.steelGrey,
  fontFamily: "nunitoregular",
  fontSize: 16,
);

const TextStyle regularTheme = TextStyle(
  color: AppColors.primary,
  fontFamily: "nunitoregular",
  fontSize: 16,
);

const TextStyle lightWhite = TextStyle(
  color: AppColors.white,
  fontFamily: "nunitolight",
  fontSize: 14,
);

const TextStyle light = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: "nunitolight",
  fontSize: 16,
);

const TextStyle thinWhite = TextStyle(
  color: AppColors.white,
  fontFamily: "nunitolight", // Assuming thin weight is not separately defined
  fontSize: 14,
);

const TextStyle kBlackButtonTextStyle = TextStyle(
  color: AppColors.midnightBlue,
  fontFamily: 'nunitoregular',
  fontSize: 14,
);

const TextStyle kThemeButtonTextStyle = TextStyle(
  color: AppColors.white,
  fontFamily: 'nunitoregular',
  fontSize: 18,
);

// Button Styles
ButtonStyle kButtonWhiteStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.white),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  overlayColor: WidgetStatePropertyAll(Colors.grey.withAlpha(40)),
);

ButtonStyle kButtonBackgroundStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.background),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  overlayColor: WidgetStatePropertyAll(Colors.grey.withAlpha(40)),
);

ButtonStyle kButtonTransparentStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.transparent),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  overlayColor: WidgetStatePropertyAll(Colors.grey.withAlpha(40)),
);

ButtonStyle kButtonThemeStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  overlayColor: WidgetStatePropertyAll(Colors.grey.withAlpha(40)),
);

ButtonStyle kButtonShadowThemeStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
  shadowColor: const WidgetStatePropertyAll(AppColors.primary),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  overlayColor: WidgetStatePropertyAll(Colors.grey.withAlpha(40)),
  elevation: const WidgetStatePropertyAll(5), // Adjust elevation as needed
);
