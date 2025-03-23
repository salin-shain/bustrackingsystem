import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'adminhome.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String adminUID = "ZFc3cqVbX4gTMjteTzoR3MSuLA93";

  void loginUser() async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text("Empty Fields"),
                content: Text("Email and Password cannot be empty."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
        );
        return;
      }

      User? user = await _authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );

      if (user == null || user.uid != adminUID) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text("Login Failed"),
                content: Text("Incorrect Email/Password."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomepage()),
      );
    } catch (e) {
      print("Error during login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/b10.png',
              fit: BoxFit.fitHeight,
              alignment: Alignment.center,
            ),
          ),
          Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.45),

                  const Text(
                    "Admin Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("Email"),
                  const SizedBox(height: 5),
                  _buildTextField(emailController, "Enter your e-mail", false),
                  const SizedBox(height: 15),
                  _buildLabel("Password"),
                  const SizedBox(height: 5),
                  _buildTextField(passwordController, "********", true),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: loginUser,
                    child: Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 68, 68, 68),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    bool obscure,
  ) {
    return SizedBox(
      width: double.infinity, // Ensures it aligns with the label
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 182, 180, 180),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
