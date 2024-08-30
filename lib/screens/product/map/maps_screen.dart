import 'package:admin_qurban_mart/controllers/maps_controller.dart';
import 'package:admin_qurban_mart/values/navigate_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mapsController = Get.put(MapsController());
    final latLng = mapsController.latLng.value;

    return Obx(
      () => FlutterMap(
        options: MapOptions(
            onTap: (tapPosition, point) {
              mapsController.setLatlng(point);
              navigatePop(context);
              // page.changePage(tambahProductScreenRoute);
            },
            bounds: LatLngBounds.fromPoints([
              mapsController.latLng.value == null
                  ? LatLng(-5.2052182, 119.4963806)
                  : latLng!,
            ]),
            maxZoom: 18),
        nonRotatedChildren: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          if (mapsController.latLng.value != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: latLng!,
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
