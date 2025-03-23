import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'driverhome.dart';
import 'signup.dart';

class DriverLogin extends StatefulWidget {
  const DriverLogin({super.key});

  @override
  State<DriverLogin> createState() => _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        _showErrorDialog("Email and password cannot be empty.");
        return;
      }

      User? user = await _authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );

      if (user == null) {
        _showErrorDialog("Incorrect Email/Password.");
        return;
      }

      DocumentSnapshot<Map<String, dynamic>> userData =
          await _firestoreService.getUser(user.uid)
              as DocumentSnapshot<Map<String, dynamic>>;

      if (!userData.exists || userData.data()?['role'] != "Driver") {
        _showErrorDialog("Unauthorized login attempt.");
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BusListScreen()),
      );
    } catch (e) {
      _showErrorDialog("Error during login: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Login Failed"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.45),
                  const Text(
                    "Driver Login",
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            ),
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
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
      width: double.infinity,
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
