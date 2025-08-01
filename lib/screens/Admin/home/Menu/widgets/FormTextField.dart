import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final TextEditingController? controller;
  final String? initialValue;
  final Function(String)? onChanged;

  const FormTextField({
    super.key,
    required this.hint,
    this.icon,
    this.controller,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
