import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/huly_theme.dart';

class HulyInput extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool autocorrect;
  final TextAlign textAlign;
  final TextStyle? style;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  const HulyInput({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.autocorrect = true,
    this.textAlign = TextAlign.start,
    this.style,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.inputFormatters,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: hulyInputDecoration(label, hint),
      obscureText: obscureText,
      keyboardType: keyboardType,
      autocorrect: autocorrect,
      textAlign: textAlign,
      style: style ?? const TextStyle(color: HulyColors.contentText),
      maxLines: maxLines,
      minLines: minLines,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
