import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteMapController extends GetxController {
  final fromLocationController = TextEditingController();
  final toLocationController = TextEditingController();

  var fromLat = 0.0.obs;
  var fromLng = 0.0.obs;
  var toLat = 0.0.obs;
  var toLng = 0.0.obs;
  var polylines = <Polyline>{}.obs;
  var markers = <Marker>{}.obs;
  var isLocationLoading = false.obs;
  var isLocationPermissionGranted = false.obs;
  GoogleMapController? mapController;

  @override
  void onClose() {
    fromLocationController.dispose();
    toLocationController.dispose();
    mapController?.dispose();
    super.onClose();
  }

  Future<void> updateRouteIfBothSelected() async {
    if (fromLat.value != 0.0 &&
        fromLng.value != 0.0 &&
        toLat.value != 0.0 &&
        toLng.value != 0.0) {
      isLocationLoading.value = true;
      await getRoute(
        LatLng(fromLat.value, fromLng.value),
        LatLng(toLat.value, toLng.value),
      );
      addMarkers();
      if (mapController != null) {
        final bounds = _computeBounds(
          LatLng(fromLat.value, fromLng.value),
          LatLng(toLat.value, toLng.value),
        );
        await mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );
      }
      isLocationLoading.value = false;
    }
  }

  void addMarkers() {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("from"),
        position: LatLng(fromLat.value, fromLng.value),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: "From"),
      ),
    );
    markers.add(
      Marker(
        markerId: const MarkerId("to"),
        position: LatLng(toLat.value, toLng.value),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: "To"),
      ),
    );
  }

  Future<void> getRoute(LatLng origin, LatLng destination) async {
    polylines.clear();
    final String apiKey = 'AIzaSyDcgl3_mitHZfqWavWiJ1fFU-zprCxv4iI';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['routes'].isNotEmpty) {
          final String encodedPolyline = data['routes'][0]['overview_polyline']['points'];
          List<LatLng> polyPoints = _decodePolyline(encodedPolyline);
          _showRoute(polyPoints);
        } else {
          print('No routes found in API response');
        }
      } else {
        print('Failed to fetch route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, lat = 0, lng = 0;
    while (index < polyline.length) {
      int shift = 0, result = 0, b;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _showRoute(List<LatLng> points) {
    final Polyline polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: points,
      width: 6,
      color: const Color(0xff4252FF),
    );
    polylines.add(polyline);
  }

  LatLngBounds _computeBounds(LatLng from, LatLng to) {
    final southWest = LatLng(
      from.latitude < to.latitude ? from.latitude : to.latitude,
      from.longitude < to.longitude ? from.longitude : to.longitude,
    );
    final northEast = LatLng(
      from.latitude > to.latitude ? from.latitude : to.latitude,
      from.longitude > to.longitude ? from.longitude : to.longitude,
    );
    return LatLngBounds(southwest: southWest, northeast: northEast);
  }
}