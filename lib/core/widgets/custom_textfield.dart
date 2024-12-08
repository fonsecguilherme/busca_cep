import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onEditingComplete;
  final int? maxCharacters;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextfield(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.onEditingComplete,
      this.maxCharacters,
      this.keyboardType,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxCharacters,
      controller: controller,
      inputFormatters: inputFormatters,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 2.0,
          ),
        ),
        filled: true,
        hintStyle: const TextStyle(color: Colors.grey),
        hintText: hintText,
      ),
    );
  }
}
