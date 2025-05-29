import 'package:flutter/material.dart';
import 'package:eight_news/views/utils/helper.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool readOnly;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;

  const CustomFormField({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
    this.suffixIcon,
    required this.keyboardType,
    required this.textInputAction,
    required this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      cursorColor: cPrimary,
      cursorErrorColor: cError,
      style: subtitle2.copyWith(color: Colors.white), // warna teks input
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF2A2A2A), // warna background input
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cPrimary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cError),
        ),
        hintText: hintText,
        hintStyle: subtitle2.copyWith(color: Colors.white70), // warna hint
        errorStyle: caption.copyWith(color: cError),
        errorMaxLines: 2,
        suffixIcon: suffixIcon,
        suffixIconColor: cPrimary,
      ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      readOnly: readOnly,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
