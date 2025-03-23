import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

import 'services/auth_service.dart'; // New line added
import 'services/firestore_service.dart'; // New line added

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _authService = AuthService(); // New line added
  final _firestoreService = FirestoreService(); // New line added

  final TextEditingController emailController = TextEditingController(); // New line added
  final TextEditingController passwordController = TextEditingController(); // New line added
  String role = "Student"; // New line added (Default role)

  void signUpUser() async { // New function added
    User? user = await _authService.registerWithEmail(
      emailController.text,
      passwordController.text,
    );

    if (user != null) {
      await _firestoreService.addUser(user.uid, emailController.text, role); // New line added
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      print("Signup Failed");
    }
  }
@override
  void initState() {
    super.initState();
    _firestoreService.checkFirestoreConnection(); // New line added (Test Firestore on startup)
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Ensures the background covers the whole screen
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/b10.png',
              fit: BoxFit.none,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                SizedBox(height: 300),
                Text(
                  "SignUp",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 5),

                Row(
                  children: [
                    Text(
                      "Email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: emailController, // New line added
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 182, 180, 180),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    hintText: "Enter your e-mail",
                    suffixIcon: Icon(Icons.mail_outline),
                  ),
                ),
                SizedBox(height: 5),

                Row(
                  children: [
                    Text(
                      "Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: passwordController, // New line added
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 182, 180, 180),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    hintText: "Enter your password",
                    suffixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),

                SizedBox(height: 5),

                // Dropdown for selecting role (New lines added)
                
                SizedBox(height: 5),
                DropdownButton<String>(
                  value: role,
                  items: ["Student", "Driver"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      role = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10),

                GestureDetector(
                  onTap: signUpUser, // New line added
                  child: Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 237, 181, 28),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Sign UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    SizedBox(width: 3),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}