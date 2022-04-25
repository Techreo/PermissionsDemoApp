import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Geolocation extends StatefulWidget {
  const Geolocation({Key? key}) : super(key: key);

  @override
  _Geolocalizacion createState() => _Geolocalizacion();
}

class _Geolocalizacion extends State<Geolocation> {
  Position? _currentPosition;

  CameraPosition _initialPosition = const CameraPosition(target: LatLng(19.3759479,-99.1780131),zoom: 20.0);
  final Completer<GoogleMapController> _controller = Completer();


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
      ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
            Padding(
                padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                ),
                child: const Text("Obtener localización"),
                onPressed: () {
                  _getCurrentLocation();
                },
              ),
            ),
          ],
        )
    );
  }

  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() async {
        _currentPosition = position;
        double _lat = _currentPosition!.latitude;
        double _long = _currentPosition!.longitude;
        final GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(_lat, _long),
          zoom: 20.0,
        )));
      });
    }).catchError((e) {
      print(e);
    });
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Position>('_currentPosition', _currentPosition));
  }
}
