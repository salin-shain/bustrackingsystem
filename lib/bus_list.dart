import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bus_details.dart';  // NEW CODE: Import bus details page

class BusListPage extends StatefulWidget {
  @override
  _BusListPageState createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> busRoutes = [];

  @override
  void initState() {
    super.initState();
    fetchBusRoutes();
  }

  Future<void> fetchBusRoutes() async {
    try {
      QuerySnapshot snapshot = await _db.collection('bus_routes').get();
      setState(() {
        busRoutes = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print("❌ Error fetching bus routes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bus List')),
      body: busRoutes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: busRoutes.length,
              itemBuilder: (context, index) {
                final bus = busRoutes[index];
                return Card(
                  child: ListTile(
                    title: Text(bus['bus_number']),
                    subtitle: Text("Seating Capacity: ${bus['seating_capacity']}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusDetailsPage(bus: bus),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}