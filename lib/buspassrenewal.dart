import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusPassRenewal extends StatefulWidget {
  const BusPassRenewal({super.key});

  @override
  State<BusPassRenewal> createState() => _BusPassRenewalState();
}

class _BusPassRenewalState extends State<BusPassRenewal> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController routeController = TextEditingController();
  TextEditingController boardingPointController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  TextEditingController branchController = TextEditingController();

  bool isLoading = true;
  bool hasBusPass = false;

  @override
  void initState() {
    super.initState();
    _showBusPass();
  }

  Future<void> _showBusPass() async {
    String userEmail = _auth.currentUser?.email ?? "Unknown";
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('students').where('email', isEqualTo: userEmail).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> studentData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          nameController.text = studentData['name'] ?? 'N/A';
          emailController.text = studentData['email'] ?? 'N/A';
          phoneController.text = studentData['phone'] ?? 'N/A';
          routeController.text = studentData['bus_route'] ?? 'N/A';
          boardingPointController.text = studentData['boarding_point'] ?? 'N/A';
          semesterController.text = studentData['semester'] ?? '';
          branchController.text = studentData['branch'] ?? '';
          hasBusPass = true;
          isLoading = false;
        });
      } else {
        setState(() {
          hasBusPass = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error fetching bus pass details: $e");
      setState(() => isLoading = false);
    }
  }

  void _submitBusPassRenewal() async {
    if (!hasBusPass) return;

    String userEmail = _auth.currentUser?.email ?? "Unknown";

    try {
      await _firestore.collection('BusPassRenewals').add({
        "name": nameController.text,
        "phone": phoneController.text,
        "email": userEmail,
        "bus_route": routeController.text,
        "boarding_point": boardingPointController.text,
        "semester": semesterController.text,
        "branch": branchController.text,
        "status": "Pending", // Default status for admin approval
        "timestamp": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bus Pass Renewal Request Submitted Successfully!")),
      );
    } catch (e) {
      print("❌ Error submitting renewal request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit request. Try again!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Pass Renewal")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasBusPass
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildTextField("Name", nameController),
                      _buildTextField("Phone", phoneController),
                      _buildTextField("Email", emailController),
                      _buildTextField("Route", routeController),
                      _buildTextField("Boarding Point", boardingPointController),
                      _buildTextField("Semester", semesterController, enabled: true),
                      _buildTextField("Branch", branchController, enabled: true),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitBusPassRenewal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text(
                    "No Bus Pass found. Please apply for one.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
