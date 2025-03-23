import 'package:flutter/material.dart';

import 'adminlogin.dart';
import 'driverlogin.dart';
import 'studentlogin.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/b9.png',
              fit:
                  BoxFit
                      .fitHeight, // Changed from none to cover for better scaling
              alignment: Alignment.topCenter,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.55),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Track your bus",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(244, 53, 100, 230),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Get live location!",
                    style: TextStyle(color: Color.fromARGB(255, 235, 121, 29)),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildButton("Student", const StudentLogin()),
                      _buildButton("Driver", const DriverLogin()),
                      _buildButton("Administrator", const AdminLogin()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        height: 40,
        width: 140,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 239, 150, 67),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
