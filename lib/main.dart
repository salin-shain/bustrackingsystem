//main.dart
import  "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import "front.dart";
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA0Og3u7NNZ8Bw72yKRWKUx18JsgGB-Zjk",
      authDomain: "edutransit-31f04.firebaseapp.com",
      projectId: "edutransit-31f04",
      storageBucket: "edutransit-31f04.firebasestorage.app",
      messagingSenderId: "866282988634",
      appId: "1:866282988634:web:aaecf5429e8f9e26aba463",
    ),
  );
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true); // New line added
  runApp(MyApp());
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("EduTransit")),
        body: Center(child: Text("Firebase Initialized!")),
      ),
    );
  }
}
*/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}



class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "STUDENT DETAILS",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.menu),
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SLNO",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("1"),
              Text("2"),
              Text("3")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("NAME", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Rohit"),
              Text("Rehan"),
              Text("Serah")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("AGE", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("32"),
              Text("10"),
              Text("21")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("PLACE", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("MPM"),
              Text("EKM"),
              Text("TVM")
            ],
          )
        ],
      ),
    );
  }
}