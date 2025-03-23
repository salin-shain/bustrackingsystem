import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'adminhome.dart';
import 'studenthome.dart';
import 'driverhome.dart';
import 'signup.dart';

import 'package:firebase_auth/firebase_auth.dart'; // New line added
import 'services/auth_service.dart'; // New line added
import 'services/firestore_service.dart'; // New line added

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _authService = AuthService(); // New line added
  final _firestoreService = FirestoreService(); // New line added
  final TextEditingController emailController = TextEditingController(); // New line added
  final TextEditingController passwordController = TextEditingController(); // New line added

void loginUser() async {
  try {
    // New lines added: Check if email and password are empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      print("Error: Email and password cannot be empty."); // Debugging message
      return;
    }

    print("Login attempt with email: ${emailController.text}"); // Debugging message

    User? user = await _authService.signInWithEmail(
      emailController.text.trim(),
      passwordController.text,
    );

    if (user == null) {
      print("Invalid email or password. Login failed."); // Debugging message
      return;
    }

    print("User authenticated successfully: ${user.uid}"); // Debugging message

    DocumentSnapshot userData = await _firestoreService.getUser(user.uid);

    if (!userData.exists) {
      print("No matching user found in Firestore. Authentication failed."); // Debugging message
      return;
    }

    String role = userData['role'];

    if (role == "Admin") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomepage()));
    } else if (role == "Driver") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BusListScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHomepage()));
    }
  } catch (e) {
    print("Error during login: $e"); // Debugging message
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand, 
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/b10.png',
            fit: BoxFit.none,
            alignment: Alignment.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              SizedBox(height: 300),
              Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              SizedBox(height: 5),

              Row(
                children: [
                  Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 68, 68, 68)),
                  ),
                ],
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: emailController, // New line added
                decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 182, 180, 180),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    hintText: "Enter your e-mail"),
              ),
              SizedBox(height: 5),

              Row(
                children: [
                  Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 68, 68, 68)),
                  ),
                ],
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: passwordController, // New line added
                decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 182, 180, 180),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    hintText: ". . . . . . ."),
              ),

              SizedBox(height: 10),

              GestureDetector(
                onTap: loginUser, // Modified existing function call
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  SizedBox(width: 3),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Text("Register", style: TextStyle(color: Colors.deepOrange)),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }
}