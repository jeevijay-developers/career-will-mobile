import 'package:careerwill/components/bgIcons.dart';
import 'package:careerwill/components/mybutton.dart';
import 'package:careerwill/provider/user_provider.dart';
import 'package:careerwill/screens/auth/login/teacher_login.dart';
import 'package:careerwill/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _ParentLoginState();
}

class _ParentLoginState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false; // step 1

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
                    "Please Enter your OTP",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),

                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: otpController,
                    onChanged: (value) {},
                    keyboardType: TextInputType.number,
                    autoFocus: true,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.indigo,
                        ) // step 2
                      : MyButton(
                          text: "Login",
                          onPressed: () async {
                            final otp = otpController.text.trim();

                            if (otp.length != 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Enter 6-digit OTP"),
                                ),
                              );
                              return;
                            }

                            setState(() => isLoading = true); // start loader

                            final success = await userProvider.verifyParentOTP(
                              otpCode: otp,
                            );

                            if (!mounted) return;

                            setState(() => isLoading = false); // stop loader

                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    userProvider.message ??
                                        "OTP verification failed",
                                  ),
                                ),
                              );
                            }
                          },
                        ),

                  Center(
                    child: TextButton(
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
