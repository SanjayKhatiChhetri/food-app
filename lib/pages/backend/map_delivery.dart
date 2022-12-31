import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:food_app/components/loading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'dart:ui' as ui;

class MapDelivery extends StatefulWidget {
  final LatLng currentLocation;
  final LatLng destinationLocation;
  const MapDelivery(
      {Key? key,
      required this.currentLocation,
      required this.destinationLocation})
      : super(key: key);

  @override
  State<MapDelivery> createState() => _MapDeliveryState();
}

class _MapDeliveryState extends State<MapDelivery> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late LatLng sourceLocation =
      LatLng(widget.currentLocation.latitude, widget.currentLocation.longitude);
  late LatLng destination = LatLng(widget.destinationLocation.latitude,
      widget.destinationLocation.longitude);

  List<LatLng> polylineCoordinates = [];

  static const String googleApiKey = "AIzaSyD2cILQL8UKDuQIaK6MxctM7kKRbwZ5qdg";

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    print(result.points);

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  late LocationData currentPosition;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentPositionIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentPosition = location;
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      currentPosition = newLoc;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
              target: LatLng(newLoc.latitude!, newLoc.longitude!))));

      setState(() {});
    });
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }

  void setCustomMarkerIcon() async{
    final Uint8List? markerIcon = await getBytesFromAsset('assets/pin.png', 150);
    sourceIcon = BitmapDescriptor.fromBytes(markerIcon!);

    final Uint8List? markerIcons = await getBytesFromAsset('assets/placeholder.png', 150);
    currentPositionIcon = BitmapDescriptor.fromBytes(markerIcons!);

    // BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/placeholder.png").then((cIcon){
    //   currentPositionIcon = cIcon;
    // });

    setState(() {});
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Delivery'),
        centerTitle: true,
      ),
      body: currentPosition == null
          ? Loading()
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentPosition.latitude!, currentPosition.longitude!),
                  zoom: 13.5),
              polylines: {
                Polyline(
                    polylineId: PolylineId("route"),
                    points: polylineCoordinates,
                    color: Colors.indigoAccent.shade700,
                    width: 6)
              },
              markers: {
                Marker(
                  markerId: MarkerId("currentPosition"),
                  icon: currentPositionIcon,
                  position: LatLng(
                      currentPosition.latitude!, currentPosition.longitude!),
                ),
                Marker(markerId: MarkerId("source"), icon: sourceIcon, position: sourceLocation),
                Marker(
                    markerId: MarkerId("destination"), position: destination),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}
