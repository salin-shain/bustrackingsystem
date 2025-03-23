import 'package:flutter/material.dart';

class BusDetailsPage extends StatelessWidget {
  final Map<String, dynamic> bus;

  BusDetailsPage({required this.bus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bus['bus_number'])),
      body: ListView.builder(
        itemCount: bus['stops'].length,
        itemBuilder: (context, index) {
          final stop = bus['stops'][index];
          return ListTile(
            title: Text(stop['place']),
            subtitle: Text("Time: ${stop['time']}"),
          );
        },
      ),
    );
  }
}