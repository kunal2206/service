import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../models/latlong_data.dart';

enum LocationServiceStatus {
  unknown,
  disabled,
  permissionDenied,
  subscribed,
  paused,
  unsubscribed,
}

class GpsController extends GetxController {
  static GpsController instance = Get.find();

  StreamSubscription<Position>? _onLocationChangedSub;
  bool _isSubscribed = false;

  final Rx<LatlngData?> currentLocation = Rx<LatlngData?>(null);

  ///position object of the current location
  Position? _currentPosition;
  final Rx<LocationServiceStatus> currentServiceStatus =
      Rx<LocationServiceStatus>(LocationServiceStatus.unknown);

  bool get subscribeStatus {
    return _isSubscribed;
  }

  Future<bool> requestPermissions() async {
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      if ([LocationPermission.always, LocationPermission.whileInUse]
              .contains(await Geolocator.requestPermission()) ==
          false) {
        return Future<bool>.value(false);
      }
    }
    return Future<bool>.value(true);
  }

  ///this method will be used to subscribe the controller by various other controllers
  void subscribePosition(LocationAccuracy locationAccuracy) {
    _onLocationChangedSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    ).listen((Position ld) {
      _isSubscribed = true;
      _currentPosition = ld;
      currentLocation.value = LatlngData(
        location: LatLng(ld.latitude, ld.longitude),
        accuracy: ld.accuracy,
        altitude: ld.altitude,
        heading: ld.heading,
        speed: ld.speed,
        speedAccuracy: ld.speedAccuracy,
        timestamp: DateTime.now(),
      );
    }, onError: (Object error) {
      if (error is LocationServiceDisabledException) {
        currentServiceStatus.value = LocationServiceStatus.disabled;
      } else {
        currentServiceStatus.value = LocationServiceStatus.unsubscribed;
      }
    }, onDone: () {
      _isSubscribed = false;
      currentServiceStatus.value = LocationServiceStatus.unsubscribed;
    });
  }

  Future<void> unsubscribePosition() {
    if (_onLocationChangedSub != null) {
      _isSubscribed = false;
      return _onLocationChangedSub!.cancel();
    }
    return Future<void>.value();
  }

  @override
  void onClose() {
    _onLocationChangedSub?.cancel();
    super.onClose();
  }

  Position? get currentPosition {
    return _currentPosition;
  }
}
