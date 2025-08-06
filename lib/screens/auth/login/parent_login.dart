import 'package:careerwill/components/auth/textfield.dart';
import 'package:careerwill/components/bgIcons.dart';
import 'package:careerwill/components/mybutton.dart';
import 'package:careerwill/provider/user_provider.dart';
import 'package:careerwill/screens/auth/OTP/otp_screen.dart';
import 'package:careerwill/screens/auth/login/teacher_login.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentLogin extends StatefulWidget {
  const ParentLogin({super.key});

  @override
  State<ParentLogin> createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {
  final TextEditingController phoneController = TextEditingController();
  String? errorText;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(() {
      setState(() {
        errorText = null; // Clear error on input change
      });
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BGIcons(),
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset('assets/images/logo.png', height: 100),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Welcome to Career Will",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Phone Input Field
                  MyTextField(
                    hintText: "Phone",
                    controller: phoneController,
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    errorText: errorText,
                  ),
                  const SizedBox(height: 6),

                  // Digit Count
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${phoneController.text.length} / 10",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  isLoading
                      ? CircularProgressIndicator(color: Colors.indigo)
                      : MyButton(
                          text: "Login",
                          onPressed: () async {
                            final phone = phoneController.text;

                            if (phone.isEmpty || phone.length < 10) {
                              setState(() {
                                errorText =
                                    "Please enter a valid 10-digit number";
                              });
                              return;
                            }
                            setState(() => isLoading = true);

                            final success = await userProvider.parentLogin(
                              mobileNumber: int.parse(phone),
                            );

                            if (!mounted) return;

                            if (success) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OTPScreen(),
                                  ),
                                );
                              });
                            } else if (userProvider.message ==
                                "There is no student associated with this mobile number") {
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    userProvider.message ?? "Login failed",
                                  ),
                                ),
                              );
                            }
                          },
                        ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login as teacher",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
