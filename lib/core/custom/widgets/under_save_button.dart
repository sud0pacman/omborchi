import 'package:flutter/material.dart';
import 'package:omborchi/core/custom/widgets/primary_button.dart';

class UnderSaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const UnderSaveButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        elevation: 0,
        child: Container(
          height: 108,
          alignment: const Alignment(0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            color: Colors.white,  // Ensure background color is white or as needed
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Light shadow
                blurRadius: 10,   // Blur effect
                spreadRadius: 5,  // Spread of the shadow
                offset: const Offset(0, -5), // Position of shadow (move upwards)
              ),
            ],
          ),
          child: PrimaryButton(
            title: title,
            height: 48,
            width: double.infinity,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
