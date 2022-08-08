import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../core/constants/controllers.dart';
import 'current_location_marker.dart';
import 'current_location_options.dart';

CurrentLocationMarkerBuilder _defaultMarkerBuilder =
    (BuildContext context, Position ld) {
  return Marker(
      point: LatLng(ld.latitude, ld.longitude),
      builder: (_) => CurrentLocationMarker(ld),
      height: 60,
      width: 60,
      rotate: false);
};

class CurrentLocationLayer extends StatefulWidget {
  const CurrentLocationLayer(this.options, this.map, this.stream, {Key? key})
      : super(key: key);

  ///this three parameters are required by LayerOptions to extend its function
  final CurrentLocationOptions options;
  final MapState map;
  final Stream<void> stream;

  @override
  _CurrentLocationLayerState createState() => _CurrentLocationLayerState();
}

class _CurrentLocationLayerState extends State<CurrentLocationLayer>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        Obx(() {
          ///whenever a new value of current location then onLocationUpdate
          ///is called which calls setState
          widget.options.onLocationUpdate!.call();
          if (locationController.currentLocation.value == null) {
            return Container();
          }
          final Marker? marker = locationController.currentPosition != null
              ? _defaultMarkerBuilder(
                  context, locationController.currentPosition!)
              : null;
          return marker != null
              ? MarkerLayerWidget(
                  options: MarkerLayerOptions(
                    markers: <Marker>[
                      marker,
                    ],
                  ),
                )
              : Container();
        }),
      ],
    ));
  }
}
