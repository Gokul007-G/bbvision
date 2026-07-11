import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData prefixIcon;
  final Widget? surfixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final int maxline;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChange;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    required this.prefixIcon,
    this.surfixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.maxline = 1,
    this.validator,
    this.onChange,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onTap: onTap,
        readOnly: readOnly,
        maxLines: maxline,
        onChanged: onChange,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          labelText: label,
          suffixIcon: surfixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
