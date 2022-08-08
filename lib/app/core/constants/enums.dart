// ignore_for_file: constant_identifier_names

enum OrderStatus {
  EXECUTED,
  BROADCAST,
  EXPIRED,
  ACCEPTED,
  STARTED,
  EXTEND_REQUEST,
  EXTENDED,
  CANCELLED,
  COMPLETE,
  PAID,
  VERIFIED
}

OrderStatus codeToStatus(String status) {
  switch (status) {
    case "1001":
      return OrderStatus.EXECUTED;//to be done by user //done
    case "1002":
      return OrderStatus.BROADCAST;//done by user so as to trigger payment
    case "1003":
      return OrderStatus.EXPIRED;
    case "1004":
      return OrderStatus.ACCEPTED;//to be done by serviceman //done
    case "1005":
      return OrderStatus.STARTED;//to be done by user
    case "1006":
      return OrderStatus.EXTEND_REQUEST;// to be done by user
    case "1007":
      return OrderStatus.EXTENDED;// to be done by serviceman
    case "1008":
      return OrderStatus.CANCELLED;//to be done by user //done
    case "1009":
      return OrderStatus.COMPLETE;// automatically after pressing verified //done
    case "1010":
      return OrderStatus.PAID;// serviceman //done
    case "1011":
      return OrderStatus.VERIFIED;// user verifies and the order is complete
    default:
      return OrderStatus.EXECUTED;
  }
}


String statusToString(OrderStatus status) {
  switch (status) {
    case OrderStatus.EXECUTED:
      return "Order placed";
    case OrderStatus.BROADCAST:
      return "Brodcast";
    case OrderStatus.STARTED:
      return "In Progress";
    case OrderStatus.EXTENDED:
      return "Extended";
    case OrderStatus.CANCELLED:
      return "Cancelled";
    case OrderStatus.COMPLETE:
      return "Completed";
    case OrderStatus.EXPIRED:
      return "event has expired";
    case OrderStatus.ACCEPTED:
      return "accepted";
    case OrderStatus.EXTEND_REQUEST:
      return "extend request";
    case OrderStatus.PAID:
      return "Payment made";
    case OrderStatus.VERIFIED:
      return "payment verified";
    default:
      return "Extended";
  }
}
