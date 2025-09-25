import 'package:flutter_map/feature/presentation/screen/general_map_screen.dart';
import 'package:flutter_map/feature/presentation/screen/home_screen.dart';
import 'package:flutter_map/feature/presentation/screen/map_route_secreen.dart';
import 'package:get/get.dart';

abstract class AppRoute {
  static const homeScreen = '/homeScreen';
  static const generalMapScreen = '/generalMapScreen';
  static const mapRouteSecreen = '/mapRouteSecreen';

  static final pages = [
    GetPage(name: AppRoute.homeScreen, page: () => HomeScreen()),
    GetPage(name: AppRoute.generalMapScreen, page: () => GeneralMapScreen()),
    GetPage(name: AppRoute.mapRouteSecreen, page: () => MapRouteSecreen()),
  ];
}
