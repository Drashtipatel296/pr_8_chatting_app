import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldSection extends StatelessWidget {
  const TextFieldSection({
    super.key,
    required this.labelText,
    required this.textInputType, required this.controller,
  });

  final String labelText;
  final TextInputType textInputType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.poppins(
            color: const Color(0xff24786D),
            fontWeight: FontWeight.w500,
          ),
        ),
        TextField(
          controller: controller,
          cursorColor: const Color(0xff24786D),
          keyboardType: textInputType,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}