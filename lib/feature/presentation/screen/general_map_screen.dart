import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/feature/controller/general_map_controler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeneralMapScreen extends StatelessWidget {
  GeneralMapScreen({super.key});
  final controller = Get.put(GeneralMapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Stack(
                children: [
                  Obx(
                    () => GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target:
                            controller.selectedLocation.value ??
                            const LatLng(23.8103, 90.4125),
                        zoom: controller.currentZoom.value,
                        tilt: 30,
                        bearing: 0,
                      ),
                      mapType: controller.mapType.value,
                      markers: controller.markers.value,
                      polylines: controller.polylines.value,
                      circles: controller.circles.value,
                      polygons: controller.polygons.value,
                      trafficEnabled: controller.trafficEnabled.value,
                      buildingsEnabled: controller.buildingsEnabled.value,
                      indoorViewEnabled: controller.indoorViewEnabled.value,
                      compassEnabled: controller.compassEnabled.value,
                      myLocationEnabled: controller.myLocationEnabled.value,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>{
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                      onTap: controller.updateLocation,
                      onLongPress: (pos) {
                        controller.updateLocation(pos);
                        Get.snackbar(
                          "Location Selected",
                          "${pos.latitude}, ${pos.longitude}",
                        );
                      },
                      onCameraMove: (position) {
                        debugPrint("Camera moving: ${position.target}");
                      },
                      onCameraIdle: () {
                        debugPrint("Camera idle");
                      },
                      onMapCreated: controller.onMapCreated,
                    ),
                  ),

                  Positioned(
                    bottom: 16.h,
                    right: 16.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMapButton(
                          icon: Icons.layers,
                          onTap: controller.toggleMapType,
                          tooltip: "Change Map Type",
                        ),
                        SizedBox(height: 8.h),
                        _buildMapButton(
                          icon: Icons.traffic,
                          onTap: controller.toggleTraffic,
                          tooltip: "Toggle Traffic",
                        ),
                        SizedBox(height: 8.h),
                        _buildMapButton(
                          icon: Icons.add,
                          onTap: () => controller.changeZoom(
                            controller.currentZoom.value + 1,
                          ),
                          tooltip: "Zoom In",
                        ),
                        SizedBox(height: 8.h),
                        _buildMapButton(
                          icon: Icons.remove,
                          onTap: () => controller.changeZoom(
                            controller.currentZoom.value - 1,
                          ),
                          tooltip: "Zoom Out",
                        ),
                        SizedBox(height: 8.h),
                        _buildMapButton(
                          icon: Icons.my_location,
                          onTap: () {
                            if (controller.selectedLocation.value != null) {
                              controller.moveTo(
                                controller.selectedLocation.value!,
                              );
                            }
                          },
                          tooltip: "Go to Selected",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      heroTag: icon.codePoint,
      mini: true,
      onPressed: onTap,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}
