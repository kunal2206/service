import 'package:latlong2/latlong.dart';

class Address {
  String? id;
  String identification;
  String landmark;
  String city;
  String state;

  Address({
    this.id,
    required this.city,
    required this.identification,
    required this.landmark,
    required this.state,
  });

  Map<String, dynamic> toJson({required LatLng location}) {
    return {
      "identification": identification,
      "landmark": landmark,
      "state": state,
      "city": city,
      "coordinates": {
        "latitude": location.latitude,
        "longitude": location.longitude
      }
    };
  }
}
