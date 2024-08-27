import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapsScreen extends StatelessWidget {
  final GeoPoint? location;

  const MapsScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
            bounds: LatLngBounds.fromPoints([
              if (location == null)
                LatLng(-5.2052182, 119.4963806)
              else
                LatLng(location!.latitude, location!.longitude),
            ]),
            maxZoom: 18),
        nonRotatedChildren: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          if (location != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(location!.latitude, location!.longitude),
                  builder: (ctx) => const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
