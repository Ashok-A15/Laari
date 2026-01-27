import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OwnerMap extends StatefulWidget {
  const OwnerMap({super.key});

  @override
  State<OwnerMap> createState() => _OwnerMapState();
}

class _OwnerMapState extends State<OwnerMap> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor laariIcon = BitmapDescriptor.defaultMarker;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _setCustomMarker();
    _requestLocationPermission();
  }

  /// Loads laari.png, resizes it, and converts it to a Google Maps marker
  Future<void> _setCustomMarker() async {
    final ByteData data = await rootBundle.load('assets/laari.png');
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 120,   // 👈 change size here
      targetHeight: 120,  // 👈 change size here
    );

    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? resizedData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List resizedBytes = resizedData!.buffer.asUint8List();

    setState(() {
      laariIcon = BitmapDescriptor.fromBytes(resizedBytes);
    });
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle denied
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle denied forever
      return;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      // Move camera to current location with zoom level
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      // Handle error
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("laari1"),
        position: const LatLng(12.3077, 76.6533),
        icon: laariIcon,
        anchor: const Offset(0.5, 0.5), // 👈 centers marker like Uber
      ),
    };

    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("current"),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(20),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(12.3077, 76.6533),
              zoom: 13,
            ),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
