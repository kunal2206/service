class OrderItem {
  final String id;
  final String productId;
  final int quantity;
  final double salePrice;

  OrderItem(
      {required this.id,
      required this.productId,
      required this.quantity,
      required this.salePrice});
}

class Order {
  final String id;
  final String addressName;
  final String serviceMan;
  final String status;
  final String createdAt;

  List<OrderItem>? orderItems;

  Order(
      {this.orderItems,
      required this.id,
      required this.addressName,
      required this.serviceMan,
      required this.status,
      required this.createdAt});
}

