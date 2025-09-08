// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapViewBody extends StatefulWidget {
  const MapViewBody({super.key});

  @override
  State<MapViewBody> createState() => _MapViewBodyState();
}

class _MapViewBodyState extends State<MapViewBody> {
  GoogleMapController? _mapController;

  LatLng? _pickup;
  LatLng? _destination;
  double distance = 0.0;
  double min = 0.0;
  double hour = 0.0;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Location services are disabled.';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _pickup = LatLng(position.latitude, position.longitude);

        _destination = null;
        _markers.clear();
        _polylines.clear();
        distance = hour = min = 0.0;

        _markers.add(
          Marker(
            markerId: const MarkerId("current"),
            position: _pickup!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_pickup!));
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_pickup!, 16));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      if (_pickup == null) {
        _pickup = position;
        _markers.add(
          Marker(
            markerId: const MarkerId("pickup"),
            position: _pickup!,
            infoWindow: const InfoWindow(title: "Pickup"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
      } else if (_destination == null) {
        _destination = position;
        _markers.add(
          Marker(
            markerId: const MarkerId("destination"),
            position: _destination!,
            infoWindow: const InfoWindow(title: "Destination"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
        _drawRouteWithOSRM();
      } else {
        // Reset if user taps again
        _pickup = position;
        _destination = null;
        _markers.clear();
        _polylines.clear();
        distance = hour = min = 0.0;
        _markers.add(
          Marker(
            markerId: const MarkerId("pickup"),
            position: _pickup!,
            infoWindow: const InfoWindow(title: "Pickup"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
      }
    });
  }

  Future<void> _drawRouteWithOSRM() async {
    if (_pickup == null || _destination == null) return;

    final url =
        "http://router.project-osrm.org/route/v1/driving/${_pickup!.longitude},${_pickup!.latitude};${_destination!.longitude},${_destination!.latitude}?overview=full&geometries=geojson";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final coords = data["routes"][0]["geometry"]["coordinates"] as List;

        List<LatLng> polylineCoordinates = coords
            .map((c) => LatLng(c[1], c[0]))
            .toList();

        // ✅ Cast to double safely
        distance = (data["routes"][0]["distance"] as num).toDouble(); // meters
        min = (data["routes"][0]["duration"] as num).toDouble() / 60; // seconds
        hour =
            (data["routes"][0]["duration"] as num).toDouble() / 120; // seconds

        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId("route"),
              color: Colors.blue,
              width: 5,
              points: polylineCoordinates,
            ),
          );
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                _pickup!.latitude <= _destination!.latitude
                    ? _pickup!.latitude
                    : _destination!.latitude,
                _pickup!.longitude <= _destination!.longitude
                    ? _pickup!.longitude
                    : _destination!.longitude,
              ),
              northeast: LatLng(
                _pickup!.latitude >= _destination!.latitude
                    ? _pickup!.latitude
                    : _destination!.latitude,
                _pickup!.longitude >= _destination!.longitude
                    ? _pickup!.longitude
                    : _destination!.longitude,
              ),
            ),
            100,
          ),
        );

        // Show distance & duration
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.0444, 31.2357), // Cairo default
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            polylines: _polylines,
            onTap: _onMapTap,
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Column(
                  children: [
                    Text(
                      "Distance: ${(distance / 1000).toStringAsFixed(2)} km, "
                      "Duration: ${hour.toStringAsFixed(0)} hrs"
                      " ${min.toStringAsFixed(0)} mins",
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: _determinePosition,
              child: const Text("Find My Location"),
            ),
          ),
        ],
      ),
    );
  }
}
