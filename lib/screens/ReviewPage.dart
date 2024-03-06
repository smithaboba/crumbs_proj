import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';


final database = FirebaseDatabase.instance.ref();
final databaseReview = database.child('Reviews/');
/*final nextReview = <String, dynamic>{
                "Iid": 99999,
                "Rating": true,
                "Text": "Example review here",
                "Uid": 123,
};*/
late TextEditingController textController;

class ReviewPage extends StatefulWidget {
  ReviewPage({super.key, required this.title, required this.user, required this.itemID, required this.itemName});
  final String title;
  GoogleSignInAccount? user;
  String itemID;
  String itemName;
  
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  void _sendReview(){
    setState(() {
     
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;
      
    });
  }

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String itemName = widget.itemName;
    double rating = 0;
    String Uname = "Anonymous User";
    if (widget.user!.displayName != null) {
      Uname = widget.user!.displayName!;
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:  Text("Crumbs",
                style: Theme.of(context).textTheme.headlineMedium),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back when the back button is pressed
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Add a review for $itemName',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: textController,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Reviews could not be empty.';
                      }
                      return null; // Return null if the input is valid
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your review here...',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                  // Update the rating variable when the user taps on a star
                    rating = newRating;
                  }
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    //TODO: Need to figure out way to get google auth ID
                    //Currently, can't access the GoogleSignInAuthentication? user variable here
                    if (_formKey.currentState!.validate()) {
                      final buildReview = <String, dynamic>{
                        "Iid": widget.itemID,
                        "Rating": rating.toStringAsFixed(1),
                        "Text": textController.text,
                        "Uid": widget.user!.id,
                        "Uname": Uname,
                      };
                      try{
                        await databaseReview.push().set(buildReview);
                        showDialog(
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
                                  'The review has been successfully submitted.',
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
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                        );
                      }
                      on TimeoutException catch (e) {
                        print('Timeout: $e');
                      } on Error catch (e) {
                        print('Error: $e');
                      }
                      _sendReview();
                    }
                  },
                  child: Text(
                    "Send Review",
                    style: TextStyle(fontSize: 20),
                    ),
                ),
                SizedBox(height:200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}