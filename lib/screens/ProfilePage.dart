import 'package:crumbs_flutter_1/screens/PersonalFavoritePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'SignInPage.dart';
import '../Widgets/SideMenu.dart';
import '../Widgets/Profile_box.dart';
import '../Widgets/Profile_signout_box.dart';
import 'PersonalReviewPage.dart';
import 'PersonalItemPage.dart';
import 'PersonalFavoritePage.dart';
class ProfilePage extends StatelessWidget {
  ProfilePage({
    super.key,
    required this.signOut,
    required this.user,
  });

  GoogleSignInAccount? user;
  AsyncCallback signOut;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List list_tile_name = ["Profile", "Reviews", "Items", "Sign Out"];

  

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    Color box_color = const Color.fromARGB(255, 41, 199, 46);
    Color normal_box_text = Color.fromARGB(255, 255, 254, 254);
    Color sign_out_box_text = Colors.white;
    Color normal_box_highlight = const Color.fromARGB(255, 42, 72, 7);
    Color sign_out_box_highlight = Colors.black;

  void _showAccountInfoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 25),
              Container(
                alignment: Alignment.center,
                child: GoogleUserCircleAvatar(identity: user!),
              ),
              SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${user?.displayName ?? 'Anonymous User'}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    )
                  ),
                  Text(
                    "${user?.email ?? 'N/A'}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    )
                  ),
                ],
              ),
              SizedBox(height: 10)
            ],
          ),
          actions: [
            TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Ok',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      ),
          ],
        );
      },
    );
  }

    String display_name = user?.displayName ?? "User";
    display_name = display_name.toUpperCase();
      return Scaffold(
          body: 
              SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Spacer(),
                      GestureDetector(
                        onTap:() {
                          _showAccountInfoPopup(context);
                        },
                        child: GoogleUserCircleAvatar(identity: user!)
                      ),
                    ],),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text("Welcome to Crumbs!",
                          style: TextStyle(fontSize: 19,
                          fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),


                    Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        
                        child: Text(display_name,
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 40),


                    SizedBox(height: 20,),
                    SingleChildScrollView(
                      child: Row(
                        children: 
                          List.generate(35, (int index) {
                            index = index + 5;
                            return Padding(
                              padding: EdgeInsets.all(2),
                              child: SizedBox(
                                width: 5,
                                height: 2,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: color),
                                ),
                              ),
                            );
                          }),
                        ),
                    ),
                        SizedBox(height: 33,),
                          
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: GridView(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Profile_box(box_title: "Favorited Items", box_color: box_color, box_title_color: normal_box_highlight, box_text_color: normal_box_text, display_icon: Icons.person, id: 0, user: user),
                                Profile_box(box_title: "Reviews", box_color: box_color, box_title_color: normal_box_highlight, box_text_color: normal_box_text, display_icon: Icons.book, id: 1, user: user),
                                Profile_box(box_title: "Items", box_color: box_color, box_title_color: normal_box_highlight, box_text_color: normal_box_text, display_icon: Icons.wallet_giftcard, id: 2, user: user),
                                Profile_signout_box(box_title: "Sign out", box_color: box_color, box_title_color: sign_out_box_highlight, box_text_color: sign_out_box_text, display_icon: Icons.exit_to_app,signOut: signOut,),

                              ]
                              ),
                          ),
                          //ElevatedButton(onPressed: signOut, child: Text("Sign Out")),
                    ],
                  ),
                
              ),
              /*
                  const SizedBox(
            height: 90,
                  ),
                  GoogleUserCircleAvatar(identity: user!),
                  const SizedBox(
            height: 10,
                  ),
                  Center(
            child: Text(
              user!.email ?? '',
              textAlign: TextAlign.center,
            ),
                  ),
                  const SizedBox(
            height: 10,
                  ),
                  const Center(
            child: Text(
              "Crumbs Profile",
              textAlign: TextAlign.center,
            ),
                  ),
                  SizedBox(
            height: 40,
                  ),
                  ElevatedButton(onPressed: signOut, child: Text("Sign Out")),
                */
          )
      
      );
  }
}
