import 'package:flutter/material.dart';
import 'package:osm_google/connectiveProvider.dart';
import 'package:osm_google/mapCacheProvider.dart';
import 'package:osm_google/mapControllerProvider.dart';
import 'package:osm_google/mapPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => MapCacheProvider()),
        ChangeNotifierProvider(create: (_) => MapControllerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MapPage(),
    );
  }
}