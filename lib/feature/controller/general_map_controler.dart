import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeneralMapController extends GetxController {
  /// Selected location observable
  final Rxn<LatLng> selectedLocation = Rxn<LatLng>();

  /// Search bar / text field controller
  final TextEditingController locationTEController = TextEditingController();

  /// Google map controller
  GoogleMapController? mapController;

  /// Current zoom level
  final RxDouble currentZoom = 14.0.obs;

  /// Map type
  final Rx<MapType> mapType = MapType.normal.obs;

  /// Markers set
  final RxSet<Marker> markers = <Marker>{}.obs;

  /// Polylines
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  /// Circles
  final RxSet<Circle> circles = <Circle>{}.obs;

  /// Polygons
  final RxSet<Polygon> polygons = <Polygon>{}.obs;

  /// Traffic layer
  final RxBool trafficEnabled = false.obs;

  /// Buildings layer
  final RxBool buildingsEnabled = true.obs;

  /// Compass
  final RxBool compassEnabled = true.obs;

  /// Indoor maps
  final RxBool indoorViewEnabled = true.obs;

  /// Lite mode
  final RxBool liteModeEnabled = false.obs;

  /// Location enabled
  final RxBool myLocationEnabled = true.obs;

  /// Map style string (if custom style needed)
  final RxnString mapStyle = RxnString();

  /// Update map controller instance
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (mapStyle.value != null) {
      controller.setMapStyle(mapStyle.value);
    }
  }

  /// Update selected location (on tap/long press)
  void updateLocation(LatLng latLng) {
    selectedLocation.value = latLng;

    // Update text field
    locationTEController.text =
        "${latLng.latitude.toStringAsFixed(5)}, ${latLng.longitude.toStringAsFixed(5)}";

    // Add marker
    markers.value = {
      Marker(
        markerId: const MarkerId("selected"),
        position: latLng,
        infoWindow: const InfoWindow(title: "Selected Location"),
      ),
    };
  }

  /// Change zoom level
  Future<void> changeZoom(double zoom) async {
    currentZoom.value = zoom;
    await mapController?.animateCamera(CameraUpdate.zoomTo(zoom));
  }

  /// Move camera to a given location
  Future<void> moveTo(LatLng latLng, {double? zoom}) async {
    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: zoom ?? currentZoom.value),
      ),
    );
  }

  /// Toggle map type (Normal / Satellite / Hybrid / Terrain)
  void toggleMapType() {
    switch (mapType.value) {
      case MapType.normal:
        mapType.value = MapType.satellite;
        break;
      case MapType.satellite:
        mapType.value = MapType.hybrid;
        break;
      case MapType.hybrid:
        mapType.value = MapType.terrain;
        break;
      case MapType.terrain:
        mapType.value = MapType.normal;
        break;
      default:
        mapType.value = MapType.normal;
    }
  }

  /// Toggle traffic layer
  void toggleTraffic() {
    trafficEnabled.value = !trafficEnabled.value;
  }

  /// Toggle buildings
  void toggleBuildings() {
    buildingsEnabled.value = !buildingsEnabled.value;
  }

  /// Toggle indoor view
  void toggleIndoor() {
    indoorViewEnabled.value = !indoorViewEnabled.value;
  }

  /// Add polyline between two points
  void addPolyline(List<LatLng> points) {
    polylines.add(
      Polyline(
        polylineId: PolylineId("poly_${polylines.length}"),
        color: Colors.blue,
        width: 5,
        points: points,
      ),
    );
  }

  /// Add circle
  void addCircle(LatLng center, double radius) {
    circles.add(
      Circle(
        circleId: CircleId("circle_${circles.length}"),
        center: center,
        radius: radius,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );
  }

  /// Add polygon
  void addPolygon(List<LatLng> points) {
    polygons.add(
      Polygon(
        polygonId: PolygonId("polygon_${polygons.length}"),
        points: points,
        fillColor: Colors.green,
        strokeColor: Colors.green,
        strokeWidth: 2,
      ),
    );
  }
}
