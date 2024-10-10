import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';
import 'package:omborchi/core/utils/consants.dart';

class TextWithTextFieldSmokeWhiteWidget extends StatefulWidget {
  final String? title;
  final String? hint;
  final String? errorText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value)? onChanged;
  final BoxConstraints? constraints;
  final int? maxLines;

  const TextWithTextFieldSmokeWhiteWidget(
      {super.key,
      this.title,
      this.hint,
      this.errorText,
      this.isPassword = false,
      this.controller,
      this.textInputType = TextInputType.text,
      this.inputFormatters,
      this.onChanged,
      this.constraints,
      this.maxLines});

  @override
  State<TextWithTextFieldSmokeWhiteWidget> createState() =>
      _TextWithTextFieldSmokeWhiteWidgetState();
}

class _TextWithTextFieldSmokeWhiteWidgetState
    extends State<TextWithTextFieldSmokeWhiteWidget> {
  bool isShowPassword = false;

  @override
  void initState() {
    isShowPassword = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primary,
          selectionColor: AppColors.primary.withAlpha(40),
          selectionHandleColor: AppColors.primary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Text(
              widget.title!,
              style: boldTheme.copyWith(
                color: AppColors.steelGrey,
                fontSize: 12,
              ),
            ),
          if (widget.title != null)
            const SizedBox(
              height: 8,
            ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              border: Border.all(
                color: AppColors.paleBlue,
                width: 1,
              ),
            ),
            alignment: Alignment.centerLeft,
            height: widget.constraints == null ? 56 : null,
            constraints: widget.constraints,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
                controller: widget.controller,
                inputFormatters: widget.inputFormatters,
                onChanged: widget.onChanged,
                maxLines: widget.maxLines,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  border: InputBorder.none,
                  hintStyle: regularEmpress,
                  suffixIcon: widget.isPassword == false
                      ? null
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              isShowPassword = !isShowPassword;
                            });
                          },
                          icon: isShowPassword == true
                              ? SvgPicture.asset(
                                  AssetRes.icEyeShowed,
                                  width: 24,
                                  height: 24,
                                )
                              : SvgPicture.asset(
                                  AssetRes.icEyeHidden,
                                  width: 24,
                                  height: 24,
                                )),
                ),
                cursorColor: AppColors.primary,
                style: medium.copyWith(
                  fontSize: 15,
                ),
                keyboardType: widget.textInputType,
                textCapitalization: TextCapitalization.sentences,
                obscureText: isShowPassword,
                enableSuggestions: isShowPassword,
                autocorrect: isShowPassword),
          ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.errorText!,
                style: mediumTheme.copyWith(overflow: TextOverflow.ellipsis,
                    fontSize: 14, color: AppColors.red, height: 1),
              ),
            ),
        ],
      ),
    );
  }
}
