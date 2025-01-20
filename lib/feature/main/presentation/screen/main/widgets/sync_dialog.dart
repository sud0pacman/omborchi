import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

class SyncWarningDialog extends StatefulWidget {
  final String title;
  final String message;
  final String positiveText;
  final String negativeText;
  final VoidCallback onNegativeTap;
  final Function(List<String>)
      onPositiveTap; // Modified to pass selected tables
  final List<String> tables; // List of dynamic tables

  const SyncWarningDialog({
    super.key,
    required this.title,
    required this.message,
    required this.positiveText,
    required this.negativeText,
    required this.onNegativeTap,
    required this.onPositiveTap,
    required this.tables,
  });

  @override
  State<SyncWarningDialog> createState() => _SyncWarningDialogState();
}

class _SyncWarningDialogState extends State<SyncWarningDialog> {
  final List<String> _selectedTables = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.message,
              style: medium.copyWith(fontSize: 15),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),
            // Dynamic List of Tables with Checkboxes
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: widget.onNegativeTap,
                  style: actionTextButtonStyle,
                  child: Text(
                    widget.negativeText,
                    style: mediumTheme.copyWith(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget
                        .onPositiveTap(_selectedTables); // Pass selected tables
                  },
                  style: actionTextButtonStyle,
                  child: Text(
                    widget.positiveText,
                    style: mediumTheme.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
