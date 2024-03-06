import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget{
  PlaceholderPage ({
  super.key,
  //required this.link,
  });

  @override
  Widget build (BuildContext context)
  {
    return Padding(padding: EdgeInsets.all(2),
    child: Column(
      children: [
        ElevatedButton.icon(onPressed: () {
          Navigator.pop(context);
        },
          icon: Icon(Icons.arrow_back),
          label: Text("Go Back")),
        Text("HELLO, PLACEHOLDER STUB"),
      ],
    ),);
  }
}