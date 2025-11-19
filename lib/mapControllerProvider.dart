import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cachedSnapShot.dart';

class MapControllerProvider extends ChangeNotifier {
  GoogleMapController? controller;
  Uint8List? overlayBytes;
  CachedSnapshot? overlayMeta;

  MapType mapType = MapType.normal;
  bool trafficEnabled = false;
  bool buildingsEnabled = true;
  bool indoorViewEnabled = true;

  void setController(GoogleMapController c) {
    controller = c;
    notifyListeners();
  }

  void showOverlay(CachedSnapshot meta, Uint8List bytes) {
    overlayMeta = meta;
    overlayBytes = bytes;
    notifyListeners();
  }

  void hideOverlay() {
    overlayBytes = null;
    overlayMeta = null;
    notifyListeners();
  }

  // NEW: setters for map options
  void setMapType(MapType type) {
    mapType = type;
    notifyListeners();
  }

  void toggleTraffic() {
    trafficEnabled = !trafficEnabled;
    notifyListeners();
  }

  void toggleBuildings() {
    buildingsEnabled = !buildingsEnabled;
    notifyListeners();
  }

  void toggleIndoor() {
    indoorViewEnabled = !indoorViewEnabled;
    notifyListeners();
  }
}