import 'package:flutter/material.dart';
import '../models/order_status.dart';

class OrderTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderTimeline({super.key, required this.currentStatus});

  static const Color primaryColor = Color(0xFF4B0082); // Indigo
  static const Color completedColor = Color(0xFF32CD32); // Lime Green

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Progress",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildTimelineTile(
            title: "Trip Started",
            isCompleted: currentStatus.index >= OrderStatus.TripStarted.index,
            isActive: currentStatus == OrderStatus.TripStarted,
          ),
          _buildTimelineTile(
            title: "Arrived at Restaurant",
            isCompleted:
                currentStatus.index >= OrderStatus.ArrivedAtRestaurant.index,
            isActive: currentStatus == OrderStatus.ArrivedAtRestaurant,
          ),
          _buildTimelineTile(
            title: "Order Picked Up",
            isCompleted: currentStatus.index >= OrderStatus.PickedUp.index,
            isActive: currentStatus == OrderStatus.PickedUp,
          ),
          _buildTimelineTile(
            title: "Arrived at Customer",
            isCompleted:
                currentStatus.index >= OrderStatus.ArrivedAtCustomer.index,
            isActive: currentStatus == OrderStatus.ArrivedAtCustomer,
          ),
          _buildTimelineTile(
            title: "Order Delivered",
            isCompleted: currentStatus.index >= OrderStatus.Delivered.index,
            isActive: currentStatus == OrderStatus.Delivered,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTile({
    required String title,
    required bool isCompleted,
    bool isActive = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted ? completedColor : Colors.grey[300],
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: primaryColor, width: 3)
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? completedColor : Colors.grey[300],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted ? Colors.black : Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
