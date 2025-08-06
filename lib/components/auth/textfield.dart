import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    required this.inputType,
    this.inputFormatters,
    this.errorText,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.inputType,
      obscureText: _isObscured,
      inputFormatters: widget.inputFormatters,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: widget.hintText,
        errorText: widget.errorText,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Color.fromARGB(255, 64, 83, 113),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}
