import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String text;
  final void Function()? onPressed;

  const MyButton({super.key, required this.text, required this.onPressed});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      height: height / 18,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.blue),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // 👈 adjust this value
            ),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
