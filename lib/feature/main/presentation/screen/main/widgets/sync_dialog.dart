import 'package:flutter/material.dart';
import 'package:omborchi/core/theme/colors.dart';
import 'package:omborchi/core/theme/style_res.dart';

class SyncWarningDialog extends StatefulWidget {
  final String title;
  final String message;
  final String positiveText;
  final String negativeText;
  final VoidCallback onNegativeTap;
  final Function(List<String>) onPositiveTap; // Modified to pass selected tables
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
            Text(
              "Sinxronlanadigan jadvallarni tanlang:",
              style: medium.copyWith(fontSize: 16),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            // Dynamic List of Tables with Checkboxes
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.tables.length,
              itemBuilder: (context, index) {
                final table = widget.tables[index];
                return ListTile(
                  title: Text(
                    table,
                    style: regular.copyWith(fontSize: 15),
                  ),
                  leading: Checkbox(
                    checkColor: AppColors.white,
                    activeColor: AppColors.midnightBlue,
                    fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      // Change the fill color based on the state
                      if (states.contains(MaterialState.selected)) {
                        return AppColors.primary; // Fill color when selected
                      }
                      return Colors.transparent; // Default fill color
                    }),
                    value: _selectedTables.contains(table),
                    onChanged: (bool? isChecked) {
                      setState(() {
                        if (isChecked == true) {
                          _selectedTables.add(table);
                        } else {
                          _selectedTables.remove(table);
                        }
                      });
                    },
                  ),
                );

              },
            ),
            const SizedBox(height: 24),
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
                    widget.onPositiveTap(_selectedTables); // Pass selected tables
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
