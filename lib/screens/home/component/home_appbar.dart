import 'package:flutter/material.dart';

AppBar buildHomeAppBar(String username) {
  return AppBar(
    elevation: 0,
    title: Text(
      "Hi, $username",
      style: const TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}
