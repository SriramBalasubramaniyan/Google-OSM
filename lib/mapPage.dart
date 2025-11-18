import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osm_google/connectiveProvider.dart';
import 'package:osm_google/mapCacheProvider.dart';
import 'package:osm_google/mapControllerProvider.dart';
import 'package:provider/provider.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final online = context.watch<ConnectivityProvider>().online;
    final ctrl = context.watch<MapControllerProvider>();
    final cache = context.watch<MapCacheProvider>();

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(13.0827, 80.2707),
              zoom: 12,
            ),
            onMapCreated: (c) =>
                context.read<MapControllerProvider>().setController(c),

            onCameraIdle: () async {
              if (!online) return;

              final controller = ctrl.controller;
              if (controller == null) return;

              final bounds = await controller.getVisibleRegion();
              final bytes = await controller.takeSnapshot();
              if (bytes == null) return;

              await context.read<MapCacheProvider>().saveSnapshot(
                bytes: bytes,
                ne: bounds.northeast,
                sw: bounds.southwest,
              );
            },

            onTap: (pos) async {
              if (online) {
                Fluttertoast.showToast(
                  msg:
                      "Lat: ${pos.latitude.toStringAsFixed(7)}, Lng: ${pos.longitude.toStringAsFixed(7)}",
                );
                return;
              }

              final hit = cache.find(pos);
              if (hit == null) {
                Fluttertoast.showToast(msg: "No cached data here.");
                return;
              }

              final file = File(hit.path);
              final bytes = await file.readAsBytes();

              context.read<MapControllerProvider>().showOverlay(hit, bytes);
            },
          ),

          if (ctrl.overlayBytes != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: () =>
                    context.read<MapControllerProvider>().hideOverlay(),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: Image.memory(
                      ctrl.overlayBytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
