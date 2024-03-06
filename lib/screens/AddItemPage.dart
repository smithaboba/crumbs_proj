import 'package:crumbs_flutter_1/Widgets/CategoriesDropDown.dart';
import 'package:crumbs_flutter_1/Widgets/my_textfield.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../Widgets/SearchLocation.dart';

class AddItem extends StatefulWidget {
  AddItem({
    super.key, // Parameterized constructor for the AddItem widget.
    required this.title, // Required title parameter.
    required this.user, // Required user parameter.
  });

  final String title; // Stores the title of the AddItem widget.
  GoogleSignInAccount?
      user; // Stores user information, which is optional for now.

  @override
  State<AddItem> createState() =>
      _AddItemState(); // Creates the state for the AddItem widget.
}

class _AddItemState extends State<AddItem> {
  final _controllerName =
      TextEditingController(); // Controller for item name input.
  // final _controllerCategory = TextEditingController(); // Controller for item category input.
  final _controllerDescription =
      TextEditingController(); // Controller for item description input.
  final _controllerLocation =
      TextEditingController(); // Controller for item location input.
  final _controllerPrice =
      TextEditingController(); // Controller for item price input.

  late DatabaseReference dbRef; // Reference to the Firebase Realtime Database.

  String _category = 'Fresh Produce';

  String location = 'Item Location';
  double lat = 0;
  double long = 0;

  void setLocation(String loc, double lat, double long) {
    setState(() {
      location = loc;
      this.lat = lat;
      this.long = long;
    });
  }

  void searchLocation(double lat, double long, Function setLocation) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SearchLocation(lat: lat, long: long, setLocation: setLocation),
        );
      },
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void setCategory(String category) {
    setState(() {
      _category = category;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child(
        'Items'); // Initializes the reference to the 'Items' node in the database.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 16.0),
                child: Center(
                  child: Text(
                    'Add Item', // Title text for the form.
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 1), // Adds space at the top of the screen.

              // Text Field for Item Name
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MyTextField(
                  controller: _controllerName,
                  labelText: 'Item Name', // Label for the text field.
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name.';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
              ),

              const SizedBox(height: 1), // Adds space between fields.

              // Text Field for Item Category

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                    child: CategoriesDropDown(downValueChange: setCategory)),
              ),

              const SizedBox(height: 1), // Adds space between fields.

              // Text Field for Item Description
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MyTextField(
                  controller: _controllerDescription,
                  labelText: 'Item Description', // Label for the text field.
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item description.';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
              ),

              const SizedBox(height: 1), // Adds space between fields.

              // Text Field for Item Location

              // Text Field for Item Price
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MyTextField(
                  controller: _controllerPrice,
                  labelText: 'Item Price', // Label for the text field.
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item price.';
                    }
                    double? price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return 'Please enter a valid number for price.';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        location,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ),

              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      Position position = await _determinePosition();
                      searchLocation(
                          position.latitude, position.longitude, setLocation);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Search Location'),
                        SizedBox(width: 10),
                        Icon(Icons.search),
                      ],
                    )),
              ),

              const SizedBox(height: 1), // Adds space between fields.

              const SizedBox(
                  height: 10), // Adds space between the fields and the button.

              Center(
                child: MaterialButton(
                  onPressed: () async {
                    // When the button is pressed, create a map of item details and push it to the Firebase Realtime Database.
                    if (location == 'Item Location' || lat == 0 || long == 0) {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Error',
                              style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              'Please select a location.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> items = {
                          'name': _controllerName.text,
                          'category': _category,
                          'description': _controllerDescription.text,
                          'location': location,
                          'lat': lat,
                          'long': long,
                          'price': (double.tryParse(_controllerPrice.text)!
                              .toStringAsFixed(2)),
                          'Uid': widget.user!.id,
                        };
                        dbRef.push().set(
                            items); // Pushes the item data to the database.

                        // Show a pop-up dialog
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Success',
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'The item has been successfully submitted.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        // Clear the text field values
                        _controllerName.clear();
                        _controllerDescription.clear();
                        _controllerLocation.clear();
                        _controllerPrice.clear();
                        setLocation("Item Location", 0, 0);
                      }
                    }
                  },
                  child: Text('Submit'), // Button label.
                  color: Colors.green[100], // Button background color.
                  textColor:
                      Colors.green[800], // Text color of the button label.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20), // Set the button's border shape.
                  ),
                ),
              ),

              const SizedBox(height: 20), // Adds space at the bottom.
            ],
          ),
        ),
      ),
    );
  }
}
