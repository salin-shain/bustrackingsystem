import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ NEW CODE: Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marquee/marquee.dart';
import 'bus_details.dart';
import 'front.dart'; // ✅ NEW CODE: Import Login Page (Redirect after logout)

class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  State<BusListScreen> createState() => _BusListScreen();
}

class _BusListScreen extends State<BusListScreen> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // ✅ NEW CODE: Initialize Firebase Auth
  List<Map<String, dynamic>> busList = [];

  @override
  void initState() {
    super.initState();
    fetchBusRoutes();
  }

  // ✅ NEW CODE: Function to fetch bus routes from Firestore
  Future<void> fetchBusRoutes() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    try {
      QuerySnapshot snapshot = await _db.collection('bus_routes').get();
      setState(() {
        busList =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      });
    } catch (e) {
      print("❌ Error fetching bus routes: $e");
    }
  }

  void _showContactAdminPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Contact Admin"),
          content: Text("Please contact the admin to edit details."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // ✅ NEW CODE: Function to log out the driver
  void _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()), // Redirect to login
      );
    } catch (e) {
      print("❌ Logout failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 222, 186),
      appBar: AppBar(
        title: const Text("EduTransit", style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 222, 186),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        actions: const [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepOrange),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/b9.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Driver Name",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profile"),
              onTap: () {
                _showContactAdminPopup(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_bus),
              title: const Text("Assigned Bus"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ), // ✅ NEW CODE: Call logout function when tapped
          ],
        ),
      ),

      body: Column(
        children: [
          Container(
            height: 30,
            width: double.infinity,
            color: Colors.orange[100],
            child: Marquee(
              text:
                  "Ensuring Safe and Efficient Bus Travel for Students & Staff.",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              blankSpace: 50.0,
              velocity: 50.0,
              pauseAfterRound: const Duration(seconds: 1),
            ),
          ),

          const SizedBox(height: 10),

          // ✅ NEW CODE: Display real bus list from Firestore
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child:
                  busList.isEmpty
                      ? Center(
                        child: CircularProgressIndicator(),
                      ) // ✅ NEW CODE: Show loading
                      : ListView.builder(
                        itemCount: busList.length,
                        itemBuilder: (context, index) {
                          final bus = busList[index];
                          return Card(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(
                                bus['bus_number'], // ✅ NEW CODE: Show actual bus number
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Seating Capacity: ${bus['seating_capacity']}", // ✅ NEW CODE: Show seating capacity
                                style: TextStyle(color: Colors.white70),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BusDetailsPage(bus: bus),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
