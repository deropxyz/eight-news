import 'package:flutter/material.dart';
import '../utils/helper.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cLinear,
          padding: const EdgeInsets.symmetric(vertical: 13),
          side: BorderSide(color: cLinear),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: cLinear),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: subtitle1.copyWith(color: cPrimary, fontWeight: semibold),
        ),
      ),
    );
  }
}
