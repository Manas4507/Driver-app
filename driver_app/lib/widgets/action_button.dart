import 'package:flutter/material.dart';
import '../models/order_status.dart';

class ActionButton extends StatelessWidget {
  final OrderStatus status;
  final double distanceToRestaurant;
  final double distanceToCustomer;
  final Function(OrderStatus) onStatusChange;
  final VoidCallback onError;

  const ActionButton({
    Key? key,
    required this.status,
    required this.distanceToRestaurant,
    required this.distanceToCustomer,
    required this.onStatusChange,
    required this.onError,
  }) : super(key: key);

  static const Color accentColor = Color(0xFF00BF63); // Vibrant Green

  @override
  Widget build(BuildContext context) {
    String buttonText = "";
    VoidCallback? onPressed;
    const double geofenceRadius = 50.0; // 50 meters

    switch (status) {
      case OrderStatus.Idle:
        buttonText = "Start Trip";
        onPressed = () => onStatusChange(OrderStatus.TripStarted);
        break;
      case OrderStatus.TripStarted:
        buttonText = "Arrived at Restaurant";
        onPressed = () {
          if (distanceToRestaurant <= geofenceRadius) {
            onStatusChange(OrderStatus.ArrivedAtRestaurant);
          } else {
            onError();
          }
        };
        break;
      case OrderStatus.ArrivedAtRestaurant:
        buttonText = "Order Picked Up";
        onPressed = () => onStatusChange(OrderStatus.PickedUp);
        break;
      case OrderStatus.PickedUp:
        buttonText = "Arrived at Customer";
        onPressed = () {
          if (distanceToCustomer <= geofenceRadius) {
            onStatusChange(OrderStatus.ArrivedAtCustomer);
          } else {
            onError();
          }
        };
        break;
      case OrderStatus.ArrivedAtCustomer:
        buttonText = "Deliver Order";
        onPressed = () => onStatusChange(OrderStatus.Delivered);
        break;
      case OrderStatus.Delivered:
        buttonText = "Order Complete";
        onPressed = null; // No more actions
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: onPressed == null ? Colors.grey : accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ),
    );
  }
}
