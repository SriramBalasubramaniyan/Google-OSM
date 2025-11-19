import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osm_google/cachedSnapShot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class MapCacheProvider extends ChangeNotifier {
  List<CachedSnapshot> cache = [];
  late File manifestFile;
  late Directory storage;

  MapCacheProvider() {
    _init();
  }

  Future<void> _init() async {
    storage = await getApplicationDocumentsDirectory();
    manifestFile = File("${storage.path}/map_cache.json");

    if (await manifestFile.exists()) {
      final list = jsonDecode(await manifestFile.readAsString());
      cache = (list as List)
          .map((e) => CachedSnapshot.fromJson(e))
          .toList();
    }
    notifyListeners();
  }

  Future<void> saveSnapshot({
    required Uint8List bytes,
    required LatLng ne,
    required LatLng sw,
  }) async {
    final id = const Uuid().v4();
    final file = File("${storage.path}/snap_$id.png");
    await file.writeAsBytes(bytes);

    cache.add(CachedSnapshot(id: id, path: file.path, ne: ne, sw: sw));

    await manifestFile.writeAsString(jsonEncode(
      cache.map((e) => e.toJson()).toList(),
    ));

    notifyListeners();
  }

  CachedSnapshot? find(LatLng p) {
    try {
      return cache.firstWhere((c) => c.contains(p));
    } catch (_) {
      return null;
    }
  }
}