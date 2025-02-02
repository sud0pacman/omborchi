import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omborchi/core/custom/extensions/context_extensions.dart';
import 'package:omborchi/core/custom/formatters/thousand_formatter.dart';
import 'package:omborchi/core/custom/widgets/custom_text_field.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

class TextFieldDialog extends StatefulWidget {
  final String title;
  final TextEditingController controller1;
  final TextEditingController? controller2;
  final String title1;
  final String? title2;
  final String hint1;
  final String? hint2;
  final String? errorText1;
  final String? errorText2;
  final String positiveTitle;
  final String negativeTitle;
  final VoidCallback onTapPositive;
  final VoidCallback onNegativeTap;

  const TextFieldDialog({
    super.key,
    required this.title,
    required this.controller1,
    this.controller2,
    required this.title1,
    this.title2,
    required this.hint1,
    this.hint2,
    required this.errorText1,
    this.errorText2,
    required this.positiveTitle,
    required this.negativeTitle,
    required this.onTapPositive,
    required this.onNegativeTap,
  });

  @override
  State<TextFieldDialog> createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: bold.copyWith(fontSize: 18, color: context.textColor()),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            TextWithTextFieldSmokeWhiteWidget(
              title: widget.title1,
              hint: widget.hint1,
              controller: widget.controller1,
              errorText: widget.errorText1,
            ),
            if (widget.controller2 != null)
              const SizedBox(
                height: 24,
              ),
            if (widget.controller2 != null)
              TextWithTextFieldSmokeWhiteWidget(
                title: widget.title2!,
                hint: widget.hint2!,
                controller: widget.controller2,
                errorText: widget.errorText2,
                inputFormatters: [
                  ThousandsSeparatorInputFormatter(),
                  LengthLimitingTextInputFormatter(9),
                ],
                textInputType: TextInputType.number,
              ),
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                const Spacer(),
                TextButton(
                    onPressed: widget.onNegativeTap,
                    style: actionTextButtonStyle,
                    child: Text(
                      widget.negativeTitle,
                      style: mediumTheme.copyWith(
                          fontSize: 14, color: context.textColor()),
                    )),
                const SizedBox(
                  width: 8,
                ),
                TextButton(
                    onPressed: widget.onTapPositive,
                    style: actionTextButtonStyle,
                    child: Text(
                      widget.positiveTitle,
                      style: mediumTheme.copyWith(
                          fontSize: 14, color: context.textColor()),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
