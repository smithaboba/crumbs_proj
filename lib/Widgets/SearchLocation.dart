import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationInfo {
  final List locations;

  const LocationInfo({
    required this.locations,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    if (json['results'] == []) {
      return const LocationInfo(
        locations: [],
      );
    } else {
      return LocationInfo(
        locations: json['results'] as List,
      );
    }
  }
}

class SearchLocation extends StatefulWidget {
  const SearchLocation({
    super.key,
    required this.lat,
    required this.long,
    required this.setLocation,
  });

  final double lat;
  final double long;
  final Function setLocation;

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  LocationInfo? _locationInfo;

  ListTile buildListTile(
      String address, BuildContext context, double long, double lat) {
    return ListTile(
      title: Text(address),
      onTap: () => {widget.setLocation(address), Navigator.pop(context)},
    );
  }

  Future<LocationInfo> fetchAlbum(
      double long, double lat, String search) async {
    final response = await http.get(Uri.parse(
        'https://www.mapquestapi.com/search/v4/place?location=$long,$lat&sort=distance&feedback=false&key=3Riq9X4MdNkCQst4YPrDjy9CvFGMBmK2&pageSize=5&q=$search'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return LocationInfo.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return LocationInfo(locations: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 300,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search Location',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (val) {
              fetchAlbum(widget.long, widget.lat, val).then((value) {
                setState(() {
                  _locationInfo = value;
                });
              });
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (_locationInfo == null)
                      const ListTile(
                        title: Text(''),
                      ),
                    if (_locationInfo != null)
                      for (var i = 0; i < _locationInfo!.locations.length; i++)
                        ListTile(
                          title: Text(
                              _locationInfo!.locations[i]['displayString']),
                          onTap: () => {
                            widget.setLocation(
                                _locationInfo!.locations[i]['displayString'],
                                _locationInfo!.locations[i]["place"]["geometry"]
                                    ["coordinates"][0],
                                _locationInfo!.locations[i]["place"]["geometry"]
                                    ["coordinates"][1]),
                            Navigator.pop(context)
                          },
                        ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
