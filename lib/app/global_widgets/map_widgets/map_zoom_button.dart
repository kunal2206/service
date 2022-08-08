import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../core/constants/palette.dart';

class MapZoomButton extends StatelessWidget {
  final MapController mapController;
  final double givenHeight;
  const MapZoomButton(this.mapController, {required this.givenHeight, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      top: givenHeight / 2,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: white,
            boxShadow: const [
              BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(1, 1),
                  color: Colors.grey)
            ]),
        child: _mapZoomButton(),
      ),
    );
  }

  Widget _mapZoomButton() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <IconData>[Icons.add, Icons.minimize]
            .map(
              (iconData) => IconButton(
                icon: Icon(
                  iconData,
                  color: dark,
                ),
                onPressed: () {
                  iconData == Icons.add
                      ? mapController.zoom + 1 <= 18.499
                          ? mapController.move(
                              mapController.center, mapController.zoom + 1)
                          : mapController.move(
                              mapController.center, mapController.zoom)
                      : mapController.zoom - 1 >= 3
                          ? mapController.move(
                              mapController.center, mapController.zoom - 1)
                          : mapController.move(
                              mapController.center, mapController.zoom);
                },
              ),
            )
            .toList());
  }
}
