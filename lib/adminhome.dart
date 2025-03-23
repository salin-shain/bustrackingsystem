import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ NEW CODE: Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // ✅ NEW CODE: Import Firebase Auth
import 'package:marquee/marquee.dart';
import 'bus_details.dart';
import 'front.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance; // ✅ NEW CODE: Firestore instance
  List<Map<String, dynamic>> busList = [];
  List<Map<String, dynamic>> feedbackList = []; // ✅ NEW CODE: Feedback List
  List<Map<String, dynamic>> studentList = []; 


  @override
  void initState() {
    super.initState();
    fetchBusRoutes();
    fetchFeedback();
    fetchStudents(); 

  }

  Future<void> fetchBusRoutes() async {
    try {
      QuerySnapshot snapshot = await _db.collection('bus_routes').get();
      setState(() {
        busList = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print("❌ Error fetching bus routes: $e");
    }
  }
  // ✅ NEW CODE: Fetch feedback from Firestore
  Future<void> fetchFeedback() async {
    try {
      QuerySnapshot snapshot = await _db.collection('feedback').orderBy('timestamp', descending: true).get();
      setState(() {
        feedbackList = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print("❌ Error fetching feedback: $e");
    }
  }
 Future<void> fetchStudents() async {
    try {
      QuerySnapshot snapshot = await _db.collection('students').get();
      setState(() {
        studentList = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print("❌ Error fetching students: $e");
    }
  }
  void _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
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
        title: const Text(
          "EduTransit",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 222, 186),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        // ✅ NEW CODE: Replace search icon with "Add Student" button
        actions: [
          TextButton(
            onPressed: () {
              _addStudentDialog(context); // ✅ NEW CODE: Open add student dialog
            },
            child: Text(
              "Add Student",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepOrange),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/b9.png'), 
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      _showAdminProfileDialog(context); // ✅ New function added
                    },
                    child: const Text(
                      "Welcome, Admin",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {_showAdminProfileDialog(context); }),
            ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {}),
            ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: _logout), 
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
              text: "Admin Dashboard - Manage Buses, Students, and Payments Efficiently",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              scrollAxis: Axis.horizontal,
              blankSpace: 50.0,
              velocity: 50.0,
              pauseAfterRound: const Duration(seconds: 1),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _adminOption("Bus List", Icons.directions_bus, Colors.blue, () {
                  _showBusListDialog(context);
                }),
                _adminOption("Student List", Icons.group, Colors.green, () { _showStudentListDialog(context); }),
                _adminOption("Payment List", Icons.payment, Colors.orange, () {}),
                _adminOption("Report Issues / Feedback", Icons.report, Colors.red, () { _showFeedbackDialog(context);}),
              ],
            ),
          ),
        ],
      ),
    );
  }
// ✅ NEW FUNCTION: Show Admin Profile Dialog
  void _showAdminProfileDialog(BuildContext context) {
    final User? user = _auth.currentUser; // Get logged-in admin's email

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "EDUTRANSIT ADMIN PROFILE",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_circle, size: 60, color: Colors.orange),
              SizedBox(height: 10),
              Text(
                "Admin Email:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                user?.email ?? "No Email Found",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Text(
                "MBCET CAMPUS BUS TRANSPORTATION SERVICES",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
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




// ✅ NEW CODE: Function to show student list dialog
  void _showStudentListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Student List"),
          content: studentList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: studentList.map((student) {
                    return ListTile(
                      title: Text(student['name']),
                      onTap: () {
                        _showStudentDetailsDialog(context, student);
                      },
                    );
                  }).toList(),
                ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Close")),
          ],
        );
      },
    );
  }

  // ✅ NEW CODE: Function to show student details
  void _showStudentDetailsDialog(BuildContext context, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(student['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("📧 Email: ${student['email']}"),
              Text("📞 Phone: ${student['phone']}"),
              Text("🚌 Bus Route: ${student['bus_route']}"),
              Text("📍 Boarding Point: ${student['boarding_point']}"),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Close")),
          ],
        );
      },
    );
  }

  // ✅ NEW CODE: Function to add a new student
  void _addStudentDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController busRouteController = TextEditingController();
    TextEditingController boardingPointController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Student"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
              TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
              TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone Number")),
              TextField(controller: busRouteController, decoration: InputDecoration(labelText: "Bus Route Number")),
              TextField(controller: boardingPointController, decoration: InputDecoration(labelText: "Boarding Point")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                await _db.collection('students').add({
                  'name': nameController.text,
                  'email': emailController.text,
                  'phone': phoneController.text,
                  'bus_route': busRouteController.text,
                  'boarding_point': boardingPointController.text,
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
// ✅ NEW CODE: Function to display feedback list in a dialog
  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("User Feedback"),
          content: feedbackList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: feedbackList.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbackList[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(feedback['feedback']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("User: ${feedback['userId']}"),
                              Text("Timestamp: ${feedback['timestamp'] != null ? feedback['timestamp'].toDate() : 'Unknown'}"),
                            ],
                          ),
                        ),
                      );
                    },
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
  // ✅ NEW CODE: Modified _adminOption to accept onTap function
  Widget _adminOption(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
  void _showBusListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Bus List"),
          content: busList.isEmpty
              ? Center(child: CircularProgressIndicator()) // ✅ NEW CODE: Show loading
              : Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: busList.length,
                    itemBuilder: (context, index) {
                      final bus = busList[index];
                      return ListTile(
                        title: Text(bus['bus_number']), // ✅ NEW CODE: Show actual bus number
                        subtitle: Text("Seating Capacity: ${bus['seating_capacity']}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusDetailsPage(bus: bus),
                            ),
                          );
                        },
                      );
                    },
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
}