import 'package:flutter/material.dart';
import 'package:flutter_map/core/common/custom_text.dart';
import 'package:flutter_map/feature/controller/route_map_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRouteSecreen extends StatelessWidget {
  MapRouteSecreen({super.key});
  final controller = Get.put(RouteMapController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateRouteIfBothSelected();
    });
    return Scaffold(
      appBar: AppBar(title: CustomText(text: "Map Route")),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Obx(() {
            return Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapToolbarEnabled: false,
                onMapCreated: (GoogleMapController googleMapController) {
                  controller.mapController = googleMapController;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    controller.fromLat.value,
                    controller.fromLng.value,
                  ),
                  zoom: 12.0,
                ),
                polylines: Set<Polyline>.of(controller.polylines),
                markers: Set<Marker>.of(controller.markers),
              ),
            );
          }),
        ],
      ),
    );
  }
}
