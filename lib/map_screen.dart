import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// New line added
import 'services/firestore_service.dart'; // New line added

class MapScreen extends StatefulWidget {
  final int busId;

  const MapScreen({required this.busId, Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _busLocation = LatLng(8.5457, 76.9419); // Default

  @override
  void initState() {
    super.initState();
    FirestoreService().getBusLocation(widget.busId.toString()).listen((snapshot) { // New line added
      if (snapshot.exists) { // New line added
        double lat = snapshot['latitude']; // New line added
        double lng = snapshot['longitude']; // New line added
        setState(() { _busLocation = LatLng(lat, lng); }); // New line added
      } // New line added
    }); // New line added
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bus ${widget.busId} Location')),
      body: FlutterMap(
        options: MapOptions(center: _busLocation, zoom: 13.0),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _busLocation,
                width: 80.0,
                height: 80.0,
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}