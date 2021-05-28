import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friday/screens/auth/signIn.dart';
import 'package:friday/screens/trips/Trips.dart';

class RouteToSignInScreen extends StatelessWidget {
  RouteToSignInScreen(this._selectedIndex);
  final int _selectedIndex;

  static List<Widget> _widgetOptions = <Widget>[
    Trips(),
    Center(
      child: Text(
        'Index 0: Explore',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
                child: Text("Sign in"),
              ),
            );
          } else {
            return _widgetOptions.elementAt(_selectedIndex);
          }
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
