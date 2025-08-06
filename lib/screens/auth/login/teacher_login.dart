import 'package:careerwill/components/auth/textfield.dart';
import 'package:careerwill/components/bgIcons.dart';
import 'package:careerwill/components/mybutton.dart';
import 'package:careerwill/provider/user_provider.dart';
import 'package:careerwill/screens/auth/login/parent_login.dart';
import 'package:careerwill/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final String role = "PARENT";

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
                    child: Image.asset(
                      'assets/images/logo.png', // replace with your asset path
                      height: 100,
                    ),
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

                  MyTextField(
                    hintText: "Email",
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  MyTextField(
                    hintText: "Password",
                    controller: passwordController,
                    obscureText: true,
                    inputType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 20),

                  userProvider.isLoading
                      ? const CircularProgressIndicator()
                      : MyButton(
                          text: "Login",
                          onPressed: () async {
                            bool success = await userProvider.login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(userProvider.message ?? "Error"),
                              ),
                            );
                            if (success) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }
                          },
                        ),
                  const SizedBox(height: 10),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ParentLogin(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login as Parent",
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
