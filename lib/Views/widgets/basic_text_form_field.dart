import 'package:flutter/material.dart';

class BasicTextFormField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? controller; // Dodano obsługę controller
  final String? Function(String?)? validator; // Opcjonalny walidator

  const BasicTextFormField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.controller, // Przyjmuje controller jako argument
    this.validator, // Przyjmuje opcjonalny walidator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Przypisanie controller
      validator: validator, // Obsługa walidatora
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.purple,
          size: 40.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.purple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.purple, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }
}
