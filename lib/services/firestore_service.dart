import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
// Debugging: Check Firestore connection
  Future<void> checkFirestoreConnection() async { // New function added
    try {
      await _db.collection('test').doc('connection_check').set({'status': 'connected'});
      print("Firestore is connected successfully.");
    } catch (e) {
      print("Firestore connection failed: $e");
    }
  }
Future<void> addBusRouteKL01AI7119() async {
    Map<String, dynamic> busRoute = {
      "bus_number": "KL 01 AI 7119",
      "seating_capacity": 49,
      "stops": [
        {"place": "Neramankara", "time": "7:40 am"},
        {"place": "Pravachabhalam", "time": "7:45 am"},
        {"place": "Nemom", "time": "7:48 am"},
        {"place": "Vellayani", "time": "8:00 am"},
        {"place": "Karackamandapam", "time": "8:05 am"},
        {"place": "Pappanamcode", "time": "8:07 am"},
        {"place": "Kaimanam", "time": "8:10 am"},
        {"place": "Maruthoor Kadavu", "time": "8:13 am"},
        {"place": "Kalady", "time": "8:15 am"},
        {"place": "Bund Road", "time": "8:18 am"},
        {"place": "PRS", "time": "8:20 am"},
        {"place": "Thycaud", "time": "8:25 am"},
        {"place": "Kawdiar Jn.", "time": "8:30 am"},
        {"place": "Kuravankonam", "time": "8:33 am"},
        {"place": "Pattom", "time": "8:35 am"},
        {"place": "LIC", "time": "8:38 am"},
        {"place": "Kesavadasapuram", "time": "8:40 am"},
        {"place": "College", "time": "8:50 am"},
      ],
    };

    try {
      await _db.collection('bus_routes').doc(busRoute['bus_number']).set(busRoute);
      print("✅ KL 01 AI 7119 bus route data added successfully!");
    } catch (e) {
      print("❌ Error adding bus route KL 01 AI 7119: $e");
    }
  }
Future<List<Map<String, dynamic>>> getBusRoutes() async {
    try {
      QuerySnapshot snapshot = await _db.collection('bus_routes').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("❌ Error fetching bus routes: $e");
      return [];
    }
  }

Future<List<Map<String, dynamic>>> getFeedback() async {
  try {
    QuerySnapshot snapshot = await _db
        .collection('feedback')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return {
        'feedback': data['feedback'] ?? "No feedback provided",
        'userId': data['userId'] ?? "Unknown User",
        'timestamp': data.containsKey('timestamp') && data['timestamp'] != null
            ? data['timestamp']
            : null,
      };
    }).toList();
  } catch (e) {
    print("❌ Error fetching feedback: $e");
    return [];
  }
}






  // Add new user (called during signup)
  Future<void> addUser(String uid, String email, String role) async {
    try {
      await _db.collection('users').doc(uid).set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("User successfully stored in Firestore."); // Debugging message
    } catch (e) {
      print("Failed to store user: $e");
    }
  }

  // Fetch user details
  Future<DocumentSnapshot> getUser(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  // Add new bus details
  Future<void> addBus(String busId, String route, String driverId) async {
    await _db.collection('buses').doc(busId).set({
      'route': route,
      'driverId': driverId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Fetch all buses
  Stream<QuerySnapshot> getBuses() {
    return _db.collection('buses').snapshots();
  }

  // Update bus location
  Future<void> updateBusLocation(String busId, double lat, double lng) async {
    await _db.collection('buses').doc(busId).update({
      'latitude': lat,
      'longitude': lng,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Get real-time bus location updates
  Stream<DocumentSnapshot> getBusLocation(String busId) {
    return _db.collection('buses').doc(busId).snapshots();
  }
    // ✅ New function to add feedback
  Future<void> addFeedback(String feedbackText, String userId) async {
    try {
      await _db.collection('feedback').add({
        'feedback': feedbackText,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
      });
      print("✅ Feedback successfully added to Firestore!");
    } catch (e) {
      print("❌ Error adding feedback: $e");
    }
  }

}