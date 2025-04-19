import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';

// Text Styles
const TextStyle pregular = TextStyle(
  fontFamily: "nunitoregular",
);

const TextStyle pmedium = TextStyle(
  fontFamily: "nunitomedium",
);

const TextStyle psemibold = TextStyle(
  fontFamily: "nunitosemibold",
);

const TextStyle pbold = TextStyle(
  fontFamily: "nunitobold",
);

const TextStyle plight = TextStyle(
  fontFamily: "nunitolight",
);

const TextStyle semiBoldWhite = TextStyle(
  fontFamily: "nunitosemibold",
  fontSize: 23,
);

const TextStyle semiBold = TextStyle(
  fontFamily: "nunitomedium",
  fontSize: 20,
);

const TextStyle semiBoldTheme = TextStyle(
  fontFamily: "nunitosemibold",
  fontSize: 18,
);

const TextStyle mediumWhite = TextStyle(
  fontFamily: "nunitomedium",
  fontSize: 20,
);

const TextStyle medium = TextStyle(
  fontFamily: "nunitomedium",
  fontSize: 20,
);

const TextStyle mediumTheme = TextStyle(
  fontFamily: "nunitomedium",
  fontSize: 20,
);

const TextStyle boldWhite = TextStyle(
  fontFamily: "nunitobold",
  fontSize: 16,
);

const TextStyle boldTheme = TextStyle(
  fontFamily: "nunitobold",
  fontSize: 23,
);

const TextStyle blackWhite = TextStyle(
  fontFamily: "nunitobold", // Assuming no specific black weight in Nunito
  fontSize: 22,
);

const TextStyle regularWhite = TextStyle(
  fontFamily: "nunitoregular",
  fontSize: 16,
);

const TextStyle bold = TextStyle(
  fontFamily: "nunitobold",
  fontSize: 16,
);

const TextStyle regular = TextStyle(
  fontFamily: "nunitoregular",
  fontSize: 16,
);

const TextStyle regularEmpress = TextStyle(
  color: AppColors.steelGrey,
  fontFamily: "nunitoregular",
  fontSize: 16,
);

const TextStyle regularTheme = TextStyle(
  fontFamily: "nunitoregular",
  fontSize: 16,
);

const TextStyle lightWhite = TextStyle(
  fontFamily: "nunitolight",
  fontSize: 14,
);

const TextStyle light = TextStyle(
  fontFamily: "nunitolight",
  fontSize: 16,
);

const TextStyle thinWhite = TextStyle(
  fontFamily: "nunitolight", // Assuming thin weight is not separately defined
  fontSize: 14,
);

const TextStyle kBlackButtonTextStyle = TextStyle(
  fontFamily: 'nunitoregular',
  fontSize: 14,
);

const TextStyle kThemeButtonTextStyle = TextStyle(
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
  overlayColor: WidgetStatePropertyAll(AppColors.overlay),
);

ButtonStyle kButtonBackgroundStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.background),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
  ),
  overlayColor: WidgetStatePropertyAll(AppColors.overlay),
);

ButtonStyle kButtonTransparentStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.transparent),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  overlayColor: WidgetStatePropertyAll(AppColors.overlay),
);

ButtonStyle kButtonThemeStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  overlayColor: WidgetStatePropertyAll(AppColors.overlay),
);

ButtonStyle kButtonShadowThemeStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
  shadowColor: const WidgetStatePropertyAll(AppColors.primary),
  shape: const WidgetStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
  overlayColor: WidgetStatePropertyAll(AppColors.overlay),
  elevation: const WidgetStatePropertyAll(5), // Adjust elevation as needed
);

ButtonStyle actionTextButtonStyle = ButtonStyle(
  backgroundColor: const WidgetStatePropertyAll(AppColors.transparent),
  overlayColor: WidgetStatePropertyAll(AppColors.overlay),
);
