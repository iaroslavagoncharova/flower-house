import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CheckoutMap extends StatelessWidget {
  final LatLng mapCenter;
  final MapController mapController;
  final Marker marker;

  const CheckoutMap({
    super.key,
    required this.mapCenter,
    required this.mapController,
    required this.marker,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(initialCenter: mapCenter, initialZoom: 15),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.iaroslava.flutter_flower_shop',
          ),
          MarkerLayer(markers: [marker]),
        ],
      ),
    );
  }
}
