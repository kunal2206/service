import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/config/settings.dart';
import '../core/constants/controllers.dart';
import '../core/constants/palette.dart';
import 'map_widgets/current_location_options.dart';
import 'map_widgets/current_location_plugin.dart';
import 'map_widgets/map_zoom_button.dart';

class MapContainer extends StatefulWidget {
  final double obtainedHeight;
  final dynamic obtainedController;

  const MapContainer(
    this.obtainedController, {
    required this.obtainedHeight,
    Key? key,
  }) : super(key: key);

  @override
  _MapContainerState createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  final MapController _mapController = MapController();
  bool _tapped = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            onPositionChanged: (mapPosition, positionChanged) {
              widget.obtainedController.zoom.value = mapPosition.zoom;
            },
            onTap: (tapPosition, point) {
              setState(() {
                _tapped = true;
                widget.obtainedController.selectedPoint = point;
              });
            },
            crs: const Epsg3857(),
            zoom: 16,
            maxZoom: 18.499,
            minZoom: 3,
            center: LatLng(25, 86),
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            plugins: <MapPlugin>[
              CurrentLocationPlugin(),
            ],
          ),
          layers: <LayerOptions>[
            TileLayerOptions(
              urlTemplate: googleMapURI,
              subdomains: <String>['a', 'b', 'c'],
            ),
            CurrentLocationOptions(
              onLocationUpdate: () {
                if (locationController.currentPosition != null) {
                  _mapController.move(
                      LatLng(locationController.currentPosition!.latitude,
                          locationController.currentPosition!.longitude),
                      widget.obtainedController.zoom.value);
                }
                if (!_tapped) {
                  widget.obtainedController.selectedPoint = LatLng(
                      locationController.currentPosition!.latitude,
                      locationController.currentPosition!.longitude);
                }
              },
            ),
            if (_tapped)
              MarkerLayerOptions(
                markers: [
                  Marker(
                    height: 25,
                    width: 25,
                    point: widget.obtainedController.selectedPoint!,
                    builder: (context) => Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 1,
                              spreadRadius: 1.5,
                              offset: Offset(0, 1)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
        MapZoomButton(_mapController, givenHeight: widget.obtainedHeight)
      ],
    );
  }
}
