import 'dart:ffi';

import 'package:crumbs_flutter_1/screens/PlaceholderPage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../Screens/PersonalReviewPage.dart';
import '../Screens/PersonalItemPage.dart';

import '../Screens/PersonalFavoritePage.dart';
import '../models/profile_page_links.dart';


class Profile_box extends StatelessWidget{
  final String box_title;
  final Color box_color;
  final Color box_title_color;
  final Color box_text_color;
  final IconData display_icon;
  GoogleSignInAccount? user;
  final int id;
  //final link;

  Profile_box ({
    super.key,
    required this.box_title,
    required this.box_color,
    required this.box_title_color,
    required this.box_text_color,
    required this.display_icon,
    required this.id,
    required this.user,
    //required this.link,
    });

  @override
  Widget build (BuildContext context)
  {
    
    return Padding(
  padding: EdgeInsets.all(24),
  child: GestureDetector(
    onTap: () {
      Widget createdLink;
      if(id == 0)
      {
        createdLink = PersonalFavoritePage(name: "STUB FAVORITE NAME", user: user);
      }
      else if (id == 1)
      {
        createdLink = PersonalReviewPage(name: "STUB REVIEW NAME", userId: user!.id);
      }
      else if (id == 2)
      {
        createdLink = PersonalItemPage(name: "STUB ITEMS PAGE", user: user);
      }
      else
      {
        createdLink = PlaceholderPage();
      }
      Navigator.push(context, MaterialPageRoute(builder: ((context) => createdLink)));
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
            textAlign: TextAlign.center,
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

