import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:permission_handler/permission_handler.dart';


class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  MapboxMap? mapboxMapController;
  bool _isInitialized = false;
  geolocator.Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _initializeMapbox();
    _getUserLocation();
  }

  Future<geolocator.Position> _determinePosition() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    //Test if services are enabled
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled so return error
      return Future.error('Location services are disabled');
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }

    return await geolocator.Geolocator.getCurrentPosition();
  }
  

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {

    mapboxMapController = mapboxMap;
    
    final geoJson = await rootBundle.loadString('assets/map_styles/counties.geojson');

    // Enabling location component for flutter
    await mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        showAccuracyRing: true
      )
    );

    await mapboxMap.style.addSource(GeoJsonSource(
      id : 'counties',
      data: geoJson
    ));

    await mapboxMap.style.addLayer(FillLayer(
      id: 'fog-of-war',
      sourceId: 'counties',
      fillColor: const Color.fromARGB(255, 22, 22, 22).toARGB32(),
      fillOpacity: .95,
    ));

    try {
      final currPos = await _determinePosition();
      if (currPos != null) {

        // Trying to center camera on userlocation upon opening map
        await mapboxMap.flyTo(
          CameraOptions(
            center: Point(coordinates: Position(currPos.longitude, currPos.latitude)),
            zoom: 14.0,
            pitch: 45,
          ),
          MapAnimationOptions(duration: 2000),
        );
        
      }
    } catch (e) {
      print('Error with fetching location: $e');
    }


  }

  Future<void> _initializeMapbox() async {
    // await dotenv.load(fileName: ".env");

    MapboxOptions.setAccessToken(
      "pk.eyJ1Ijoia2V2Z2Fyb285IiwiYSI6ImNtOWJmemoyYzBoMW0ybW9kaTM3azRiMXcifQ.olNbnKFuqW_9-_eVZR-7pQ"
    );

    setState(() {
      _isInitialized = true; // Mark initialization as complete
    });
  }

  Future<void> _getUserLocation() async {

    // Check and request location permissions using permission_handler
    if (await Permission.location.isDenied) {
      await Permission.location.request(); // Requesting location permission
    }

    if (await Permission.location.isPermanentlyDenied) {
      return;
    }

    try {
      // Fetch current location with geolocator
      final position = await _determinePosition();
      setState(() {
        _userPosition = position; // Storing user location for future calculations
      });
    } catch (e) {
      print('error fetching user location: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Show a loading indicator while initializing
      return Scaffold(
        appBar: AppBar(title: Text('Map')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: MapWidget(
        onMapCreated: _onMapCreated,

        styleUri: 'mapbox://styles/kevgaroo9/cm9sofuwr00sy01s63rzr8g7c',

      ),
    );
  }
}