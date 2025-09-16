enum OrderStatus {
  Idle, // Order assigned, trip not started
  TripStarted, // Driver is heading to the restaurant
  ArrivedAtRestaurant, // Driver is within 50m of the restaurant
  PickedUp, // Driver has collected the order
  ArrivedAtCustomer, // Driver is within 50m of the customer
  Delivered, // Order is successfully delivered
}
