import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutransit/buspassrenewal.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ NEW CODE: Import Firebase Auth
import 'package:marquee/marquee.dart';
import 'map_screen.dart';
import 'front.dart'; // ✅ NEW CODE: Import Login Page (Redirect after logout)

class StudentHomepage extends StatefulWidget {
  const StudentHomepage({super.key});

  @override
  State<StudentHomepage> createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // ✅ NEW CODE: Initialize Firebase Auth
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // ✅ NEW CODE: Initialize Firestore
  final TextEditingController _feedbackController =
      TextEditingController(); // ✅ NEW CODE: Controller for feedback
  String studentName = "User"; // ✅ NEW CODE: Default name

  @override
  void initState() {
    super.initState();
    _fetchStudentName(); // ✅ NEW CODE: Fetch student name
  }

  // ✅ NEW CODE: Function to fetch student name from Firestore
  Future<void> _fetchStudentName() async {
    String userEmail =
        _auth.currentUser?.email ?? "Unknown"; // Get logged-in email

    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('students')
              .where('email', isEqualTo: userEmail)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          studentName = querySnapshot.docs.first['name'] ?? "User";
        });
      }
    } catch (e) {
      print("❌ Error fetching student details: $e");
    }
  }

  // Function to show update options
  void _showUpdateOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Update Settings"),
                onTap: () {
                  Navigator.pop(context);
                  _showMessage("Contact Admin for settings update.");
                },
              ),
              ListTile(
                title: Text("Update Address"),
                onTap: () {
                  Navigator.pop(context);
                  _editAddressDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to show address editing dialog
  void _editAddressDialog() {
    TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Address"),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(hintText: "Enter new address"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentAddress = addressController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Add this variable to store the updated address
  String currentAddress = "Crystal Homes, Main Rd, Junction, Pattom, TVM";

  void _handleEditProfile() async {
    String userEmail = _auth.currentUser?.email ?? "Unknown";

    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('students')
              .where('email', isEqualTo: userEmail)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        _showMessage(
          "Cannot edit profile. Contact Administrator.\n Email : admin@gmail.com",
        );
      } else {
        _showMessage("Apply for Bus pass to set up a profile.");
      }
    } catch (e) {
      print("❌ Error checking profile: $e");
    }
  }

  // ✅ NEW CODE: Function to show message dialogs
  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showProfile() async {
    String userEmail =
        _auth.currentUser?.email ?? "Unknown"; // Get logged-in email

    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('students')
              .where('email', isEqualTo: userEmail)
              .get();

      Map<String, dynamic> studentData;

      if (querySnapshot.docs.isNotEmpty) {
        studentData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        studentData = {
          'name': 'User',
          'email': userEmail,
          'phone': 'N/A',
          'bus_route': 'N/A',
          'boarding_point': 'N/A',
        };
      }

      _showProfileDialog(studentData);
    } catch (e) {
      print("❌ Error fetching student details: $e");
    }
  }

  void _showProfileDialog(Map<String, dynamic> studentData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(studentData['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("📧 Email: ${studentData['email']}"),
              Text("📞 Phone: ${studentData['phone']}"),
              Text("🚌 Bus Route: ${studentData['bus_route']}"),
              Text("📍 Boarding Point: ${studentData['boarding_point']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBusPass() async {
    String userEmail = _auth.currentUser?.email ?? "Unknown";
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('students')
              .where('email', isEqualTo: userEmail)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> studentData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        _showBusPassDialog(studentData);
      } else {
        _showMessage("No Bus Pass found. Please apply for one.");
      }
    } catch (e) {
      print("❌ Error fetching bus pass details: $e");
    }
  }

  void _showBusPassDialog(Map<String, dynamic> studentData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("🚌 Your Bus Pass"),
          content: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange[100],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "📛 Name: ${studentData['name']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("📧 Email: ${studentData['email']}"),
                Text("📞 Phone: ${studentData['phone']}"),
                Text("🚌 Route: ${studentData['bus_route']}"),
                Text("📍 Boarding Point: ${studentData['boarding_point']}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  // ✅ NEW CODE: Function to log out the student
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

  // ✅ NEW CODE: Function to submit feedback
  void _submitFeedback() async {
    String feedbackText = _feedbackController.text.trim();
    if (feedbackText.isNotEmpty) {
      try {
        await _firestore.collection('feedback').add({
          'feedback': feedbackText,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': _auth.currentUser?.uid ?? 'Anonymous', // Stores user ID
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Feedback submitted successfully!")),
        );

        _feedbackController.clear();
        Navigator.pop(context); // Close the dialog after submission
      } catch (e) {
        print("❌ Error submitting feedback: $e");
      }
    }
  }

  // ✅ NEW CODE: Function to open feedback dialog
  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Submit Feedback"),
            content: TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                hintText: "Enter your feedback here",
              ),
              maxLines: 4,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: _submitFeedback,
                child: const Text("Submit"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayName = studentName.isNotEmpty ? studentName : "User";

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
                  Scaffold.of(context).openDrawer(); // Opens the drawer
                },
              ),
        ),
        /* actions: const [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 10),
        ],*/
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepOrange),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      'assets/b9.png',
                    ), // Profile Image
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome, $displayName",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
              ), // ✅ NEW CODE: Profile as a Button
              title: const Text("Profile"),
              onTap: _showProfile, // ✅ NEW CODE: Fetch & Show Profile
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profile"),
              onTap: _handleEditProfile,
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text("Update"),
              onTap: _showUpdateOptions,
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text("Payment"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.feedback,
              ), // ✅ Updated: Make Feedback a Button
              title: const Text("Feedback"),
              onTap: _showFeedbackDialog, // ✅ Open Feedback Dialog
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: _logout, // ✅ NEW CODE: Call logout function when tapped
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 30,
              width: double.infinity,
              color: Colors.orange[100], // Background color for visibility
              child: Marquee(
                text:
                    "Advancing Sustainable Cities and Communities through Streamlined Campus Bus Services",
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

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapScreen(busId: 1),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/bmap.png',
                          ), // Add your image
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Live Bus Tracking",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /*  Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Address",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Crystal Homes, Main Rd, Junction, Pattom, TVM",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),*/
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Address",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    currentAddress, // Updated dynamically
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Updated eBus Pass and Bus Pass Renewal Buttons
            Column(
              children: [
                Wrap(
                  spacing: 10, // Spacing between items
                  runSpacing: 10, // Spacing between rows when wrapped
                  children: [
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width > 600
                              ? 200
                              : double.infinity,
                      child: GestureDetector(
                        onTap: _showBusPass,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "eBus Pass",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width > 600
                              ? 200
                              : double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusPassRenewal(),
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Bus Pass Application/Renewal",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
