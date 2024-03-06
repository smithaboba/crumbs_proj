import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/item_model.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapboxMapController controller;
  Map<double, String> dict = {};
  List<LatLng> coords = [];
  List<String> locations = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken:
            "pk.eyJ1IjoibmljZzY2NDUiLCJhIjoiY2xwMG1yYjFvMGEwMTJycnh0M2g1aWwwOSJ9.ZX7kPHTEpL5biChPaj0p5A",
        onMapCreated: (controller) {
          // Assign the controller to the local variable
          this.controller = controller;
          retrieveItemData();
          Timer(Duration(seconds: 1), () {
            populateMap();
          });
        },
        onMapClick: (point, latLng) {
          popUp(latLng);
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(34.427, -119.876),
          zoom: 13.0,
        ),
      ),
    );
  }

  void populateMap() {
    addMarkers(controller, coords, locations);
  }

  void retrieveItemData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    dbRef.child("Items").onChildAdded.listen((data) {
      ItemData itemData = ItemData.fromJson(data.snapshot.value as Map);
      try {
        if (itemData.lat != null && itemData.long != null) {
          double lat = double.parse(itemData.lat!);
          double long = double.parse(itemData.long!);
          //print(long);
          //print(lat);
          coords.add(LatLng(long, lat));
          locations.add(itemData.location!);
          dict[double.parse(long.toStringAsFixed(3))] = itemData.location!;
        }
      } catch (e) {}
    });
  }

  void addMarkers(MapboxMapController controller,
      List<LatLng> markerCoordinates, List<String> locations) {
    //print(dict);
    for (int i = 0; i < markerCoordinates.length; i++) {
      addMarker(controller, markerCoordinates[i], locations[i]);
    }
  }

  void addMarker(
      MapboxMapController controller, LatLng latLng, String name) async {
    var byteData = await rootBundle.load("assets/images/grocery-store.png");
    var markerImage = byteData.buffer.asUint8List();
    controller.addImage('marker', markerImage);
    await controller.addSymbol(SymbolOptions(
        iconSize: 2,
        iconImage: "marker",
        geometry: latLng,
        textSize: .5,
        textOffset: const Offset(0, 2)));
  }

  void popUp(LatLng latLng) {
    double latitude = latLng.latitude;
    double longitude = latLng.longitude;
    if (dict.containsKey(
      double.parse(latitude.toStringAsFixed(3)),
    )) {
      String location = dict[double.parse(latitude.toStringAsFixed(3))]!;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Store Location",
              style: TextStyle(
                color: Colors.green[800],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text("This store is: $location",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  )),
            ],
          );
        },
      );
    }
  }
}
