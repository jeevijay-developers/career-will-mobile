import 'package:careerwill/provider/attendance_provider.dart';
import 'package:careerwill/screens/auth/login/teacher_login.dart';
import 'package:careerwill/provider/user_provider.dart';
import 'package:careerwill/provider/home_provider.dart';
import 'package:careerwill/screens/fee/provider/fee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => FeeProvider()),
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Will',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
