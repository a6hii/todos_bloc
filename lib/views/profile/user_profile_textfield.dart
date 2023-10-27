import 'package:flutter/material.dart';

class UserProfileTextField extends StatelessWidget {
  const UserProfileTextField({
    super.key,
    required this.controller,
    required this.isEditMode,
    required this.labelText,
  });

  final TextEditingController controller;
  final bool isEditMode;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: TextField(
        controller: controller,
        enabled: isEditMode,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          fillColor: isEditMode ? Colors.white : Colors.grey[400],
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
