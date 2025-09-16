import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/order_status.dart';
import '../widgets/action_button.dart';
import '../widgets/destination_card.dart';
import '../widgets/location_info_card.dart';
import '../widgets/order_timeline.dart';

class AssignedOrderScreen extends StatefulWidget {
  const AssignedOrderScreen({super.key});

  @override
  State<AssignedOrderScreen> createState() => _AssignedOrderScreenState();
}

class _AssignedOrderScreenState extends State<AssignedOrderScreen> {
  // --- DUMMY ORDER DATA ---
  final String orderId = "ORD-2025-XYZ";
  final String restaurantName = "Shree Leela Gurukripa";
  final String customerName = "Anjali Verma";

  // --- GEOGRAPHICAL COORDINATES (Indore, MP) ---
  final Position restaurantLocation = Position.fromMap({
    'latitude': 22.7533,
    'longitude': 75.8937,
  }); // Vijay Nagar Square
  final Position customerLocation = Position.fromMap({
    'latitude': 22.7176,
    'longitude': 75.8515,
  }); //Raj Mohalla

  // --- STATE VARIABLES ---
  OrderStatus _status = OrderStatus.Idle;
  Position? _currentLocation;
  double _distanceToRestaurant = double.infinity;
  double _distanceToCustomer = double.infinity;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLoading = true;

  static const Color primaryColor = Color(0xFF4B0082);

  @override
  void initState() {
    super.initState();
    _initializeLocationAndUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  // --- CORE LOGIC: LOCATION & NAVIGATION ---
  Future<void> _initializeLocationAndUpdates() async {
    // ... (This logic remains the same as before)
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorSnackBar("Location services are disabled. Please enable them.");
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorSnackBar("Location permissions are denied.");
        if (mounted) setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorSnackBar(
        "Location permissions are permanently denied. Please enable them from your phone settings.",
      );
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    _startLocationUpdates();
    if (mounted) setState(() => _isLoading = false);
  }

  void _startLocationUpdates() {
    // ... (This logic remains the same as before)
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((Position position) {
          print(
            "📍 [Live Location] Lat: ${position.latitude}, Lng: ${position.longitude}",
          );

          if (mounted) {
            setState(() {
              _currentLocation = position;
              _updateDistances();
            });
          }
        });
  }

  void _updateDistances() {
    if (_currentLocation == null) return;
    setState(() {
      _distanceToRestaurant = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        restaurantLocation.latitude,
        restaurantLocation.longitude,
      );
      _distanceToCustomer = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        customerLocation.latitude,
        customerLocation.longitude,
      );
    });
  }

  void _launchMapsNavigation(double lat, double lng) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    try {
      await launchUrl(googleMapsUrl);
    } catch (e) {
      _showErrorSnackBar("Could not open Google Maps.");
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Order #$orderId"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : _currentLocation == null
          ? _buildLocationErrorUI()
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                OrderTimeline(currentStatus: _status),
                const SizedBox(height: 24),
                DestinationCard(
                  title: "Restaurant Details",
                  name: restaurantName,
                  distance: _distanceToRestaurant,
                  icon: Icons.storefront_outlined,
                  onNavigate: () => _launchMapsNavigation(
                    restaurantLocation.latitude,
                    restaurantLocation.longitude,
                  ),
                ),
                const SizedBox(height: 16),
                DestinationCard(
                  title: "Customer Details",
                  name: customerName,
                  distance: _distanceToCustomer,
                  icon: Icons.person_pin_circle_outlined,
                  onNavigate: () => _launchMapsNavigation(
                    customerLocation.latitude,
                    customerLocation.longitude,
                  ),
                ),
                const SizedBox(height: 16),
                LocationInfoCard(currentLocation: _currentLocation),
              ],
            ),
      bottomNavigationBar: _isLoading
          ? null
          : ActionButton(
              status: _status,
              distanceToRestaurant: _distanceToRestaurant,
              distanceToCustomer: _distanceToCustomer,
              onStatusChange: (newStatus) {
                setState(() {
                  _status = newStatus;
                });
              },
              onError: () {
                final distance = _status == OrderStatus.TripStarted
                    ? _distanceToRestaurant
                    : _distanceToCustomer;
                final destination = _status == OrderStatus.TripStarted
                    ? "restaurant"
                    : "customer";
                _showErrorSnackBar(
                  "Please reach the $destination first. You are still ${distance.toStringAsFixed(0)}m away.",
                );
              },
            ),
    );
  }

  Widget _buildLocationErrorUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              "Location Not Available",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Could not fetch your location. Please ensure location services are enabled and permissions are granted.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: _initializeLocationAndUpdates,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
