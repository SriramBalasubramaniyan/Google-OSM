import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cachedSnapShot.dart';

class MapControllerProvider extends ChangeNotifier {
  GoogleMapController? controller;
  Uint8List? overlayBytes;
  CachedSnapshot? overlayMeta;

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
}
