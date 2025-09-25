import 'package:flutter/material.dart';
import 'package:flutter_map/core/common/custom_text.dart';
import 'package:flutter_map/feature/controller/general_map_controler.dart';
import 'package:flutter_map/feature/controller/route_map_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:permission_handler/permission_handler.dart';

class MapRouteSecreen extends StatefulWidget {
  const MapRouteSecreen({super.key});

  @override
  State<MapRouteSecreen> createState() => _MapRouteSecreenState();
}

class _MapRouteSecreenState extends State<MapRouteSecreen> {
  final controller = Get.put(GeneralMapController());
  final routeController = Get.put(RouteMapController());

  final FocusNode fromFocusNode = FocusNode();
  final FocusNode toFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Request location permission on screen load
  }

  @override
  void dispose() {
    fromFocusNode.dispose();
    toFocusNode.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      // Permission granted, enable myLocation
      routeController.isLocationPermissionGranted.value = true;
    } else {
      // Permission denied, disable myLocation
      routeController.isLocationPermissionGranted.value = false;
    }
  }

  Future<void> _updateRouteIfBothSelected() async {
    if (routeController.fromLat.value != 0.0 &&
        routeController.fromLng.value != 0.0 &&
        routeController.toLat.value != 0.0 &&
        routeController.toLng.value != 0.0) {
      await routeController.updateRouteIfBothSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const CustomText(text: "Maps Route")),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          GooglePlaceAutoCompleteTextField(
            focusNode: fromFocusNode,
            isCrossBtnShown: false,
            textEditingController: routeController.fromLocationController,
            googleAPIKey: "AIzaSyDcgl3_mitHZfqWavWiJ1fFU-zprCxv4iI",
            debounceTime: 500,
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) async {
              routeController.fromLat.value = double.parse(prediction.lat!);
              routeController.fromLng.value = double.parse(prediction.lng!);
              routeController.fromLocationController.text = prediction.description ?? "";
              fromFocusNode.unfocus(); // Clear focus to dismiss suggestions
              await _updateRouteIfBothSelected(); // Draw polyline first
              routeController.addMarkers(); // Then update markers
            },
            itemClick: (Prediction prediction) {
              routeController.fromLocationController.text = prediction.description ?? "";
              fromFocusNode.unfocus(); // Clear focus to dismiss suggestions
            },
            boxDecoration: const BoxDecoration(color: Colors.transparent),
            itemBuilder: (context, index, Prediction prediction) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      prediction.description ?? "Unknown location",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      prediction.structuredFormatting?.secondaryText ?? "",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    onTap: () {
                      routeController.fromLocationController.text = prediction.description ?? "";
                      fromFocusNode.unfocus(); // Clear focus to dismiss suggestions
                    },
                  ),
                ),
              );
            },
            inputDecoration: InputDecoration(
              hintText: "Enter starting point",
              hintStyle: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff636F85),
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xff636F85)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Color(0xff636F85)),
                onPressed: () {
                  routeController.fromLocationController.clear();
                  Future.delayed(const Duration(milliseconds: 50), () {
                    fromFocusNode.requestFocus();
                  });
                },
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xffF1F1F1),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 1.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          GooglePlaceAutoCompleteTextField(
            focusNode: toFocusNode,
            isCrossBtnShown: false,
            textEditingController: routeController.toLocationController,
            googleAPIKey: "AIzaSyDcgl3_mitHZfqWavWiJ1fFU-zprCxv4iI",
            debounceTime: 500,
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) async {
              routeController.toLat.value = double.parse(prediction.lat!);
              routeController.toLng.value = double.parse(prediction.lng!);
              routeController.toLocationController.text = prediction.description ?? "";
              toFocusNode.unfocus(); // Clear focus to dismiss suggestions
              await _updateRouteIfBothSelected(); // Draw polyline first
              routeController.addMarkers(); // Then update markers
            },
            itemClick: (Prediction prediction) {
              routeController.toLocationController.text = prediction.description ?? "";
              toFocusNode.unfocus(); // Clear focus to dismiss suggestions
            },
            boxDecoration: const BoxDecoration(color: Colors.transparent),
            itemBuilder: (context, index, Prediction prediction) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      prediction.description ?? "Unknown location",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      prediction.structuredFormatting?.secondaryText ?? "",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    onTap: () {
                      routeController.toLocationController.text = prediction.description ?? "";
                      toFocusNode.unfocus(); // Clear focus to dismiss suggestions
                    },
                  ),
                ),
              );
            },
            inputDecoration: InputDecoration(
              hintText: "Enter destination",
              hintStyle: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff636F85),
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xff636F85)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Color(0xff636F85)),
                onPressed: () {
                  routeController.toLocationController.clear();
                  Future.delayed(const Duration(milliseconds: 50), () {
                    toFocusNode.requestFocus();
                  });
                },
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xffF1F1F1),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 1.5,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.selectedLocation.value ?? const LatLng(23.8103, 90.4125),
                  zoom: controller.currentZoom.value,
                ),
                polylines: routeController.polylines,
                markers: routeController.markers,
                myLocationEnabled: routeController.isLocationPermissionGranted.value,
                myLocationButtonEnabled: routeController.isLocationPermissionGranted.value,
                onMapCreated: (mapCtrl) {
                  routeController.mapController = mapCtrl;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}