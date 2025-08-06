import 'package:flutter/material.dart';

class BGIcons extends StatelessWidget {
  const BGIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 40,
          left: 30,
          child: Icon(
            Icons.school,
            size: 60,
            color: Colors.deepPurple.withOpacity(0.1),
          ),
        ),
        Positioned(
          top: 80,
          right: 20,
          child: Icon(
            Icons.menu_book,
            size: 50,
            color: Colors.blue.withOpacity(0.1),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 20,
          child: Icon(
            Icons.edit,
            size: 50,
            color: Colors.deepOrange.withOpacity(0.1),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 40,
          child: Icon(
            Icons.school,
            size: 70,
            color: Colors.green.withOpacity(0.1),
          ),
        ),
        Positioned(
          top: 200,
          left: 10,
          child: Icon(
            Icons.science,
            size: 60,
            color: Colors.cyan.withOpacity(0.3),
          ),
        ),
        Positioned(
          bottom: 150,
          right: 120,
          child: Icon(
            Icons.computer,
            size: 50,
            color: Colors.indigo.withOpacity(0.3),
          ),
        ),
        Positioned(
          top: 20,
          right: 150,
          child: Icon(
            Icons.lightbulb,
            size: 40,
            color: Colors.yellow.withOpacity(0.3),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 150,
          child: Icon(
            Icons.backpack,
            size: 60,
            color: Colors.teal.withOpacity(0.3),
          ),
        ),
        Positioned(
          top: 150,
          left: 120,
          child: Icon(
            Icons.library_books,
            size: 50,
            color: Colors.brown.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
