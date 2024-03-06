import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class Profile_signout_box extends StatelessWidget{
  final String box_title;
  final Color box_color;
  final Color box_title_color;
  final Color box_text_color;
  final IconData display_icon;
  AsyncCallback signOut;
  //final link;

  Profile_signout_box ({
    super.key,
    required this.box_title,
    required this.box_color,
    required this.box_title_color,
    required this.box_text_color,
    required this.display_icon,
    required this.signOut
    //required this.link,
    });

  @override
  Widget build (BuildContext context)
  {
    return Padding(
  padding: EdgeInsets.all(24),
  child: GestureDetector(
    onTap: () {
      showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Return the content of the dialog
                  return AlertDialog(
                    title: Text(
                      'Signing Out',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    content: Text(
                      'Are you sure you want to sign out?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      )
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                          signOut();
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          )
                        ),
                      ),
                    ],
                  );
                },
              );
    },
    child: Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: box_title_color,
              boxShadow: [
                    BoxShadow(
                      color: box_title_color,
                      offset: const Offset(
                        2.0,
                        2.0,
                      ),
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ],
  
            ),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(box_title,
            style: TextStyle(
              color: box_text_color,
              fontSize: 20,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,),
              
            ),
          ),
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Icon(
                display_icon,
                size: 28,)
              ),
          ),
        ],
      ),
        decoration: BoxDecoration(color: box_color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
                    BoxShadow(
                      color: box_color,
                      offset: const Offset(
                        2.0,
                        2.0,
                      ),
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                  ],
      ) ,
    ),
  ));
  }
}

