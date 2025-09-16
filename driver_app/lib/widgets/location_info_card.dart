import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationInfoCard extends StatelessWidget {
  final Position? currentLocation;

  const LocationInfoCard({super.key, this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.withValues(alpha: 0.1),
            child: const Icon(Icons.my_location, color: Colors.blue, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Current Location",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                if (currentLocation != null)
                  Text(
                    "Lat: ${currentLocation!.latitude.toStringAsFixed(4)}, Lng: ${currentLocation!.longitude.toStringAsFixed(4)}",
                    style: TextStyle(color: Colors.grey[700]),
                  )
                else
                  const Text("Fetching location..."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
