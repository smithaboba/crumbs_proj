import 'package:crumbs_flutter_1/Widgets/SideMenu.dart';

import 'ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'HomePage.dart';
import 'ReviewPage.dart';
import 'AddItemPage.dart';
import 'mapPage.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

var googleAuth = null;

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  static const String routeName = '/sign-in';

  @override
  State<SignInPage> createState() => _SignInPageState();

  GoogleSignInAccount? getCurrenUser() {
    return _googleSignIn.currentUser;
  }

  GoogleSignIn getSignIn() {
    return _googleSignIn;
  }
}

class _SignInPageState extends State<SignInPage> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> handleSignIn() async {
    try {
      final result = await _googleSignIn.signIn();
      googleAuth = await result?.authentication;
      _onItemTapped(0);
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleSignOut() async {
    try {
      _googleSignIn.signOut();
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _currentUser = null;
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildBody() {
    GoogleSignInAccount? user = _currentUser;

    late final List<Widget> _widgetOptions = <Widget>[
      HomePage(title: "Crumbs", user: _currentUser),
      ProfilePage(signOut: handleSignOut, user: _currentUser),
      // ReviewPage(title: "Review", user: googleAuth, userID: _currentUser!.id,),
      AddItem(title: "Add Item", user: _currentUser),
      MapPage()
    ];
    if (user != null) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("Crumbs",
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          drawer: SideMenu(setState: _onItemTapped),
          body: _widgetOptions[_selectedIndex]);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset('assets/images/Crumbs.png'),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              width: 250,
              child: ElevatedButton(
                onPressed: handleSignIn,
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('assets/images/google.png'),
                        height: 20.0,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Sign in with Google",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: buildBody(),
      ),
    );
  }
}
