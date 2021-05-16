import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/screens/auth/sign_in.dart';

class Trips extends StatefulWidget {
  @override
  _TripsState createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  Future signOut() async {
    try {
      var _signOut = await FirebaseAuth.instance.signOut().then((value) =>
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignIn())));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: signOut,
        child: FaIcon(FontAwesomeIcons.signOutAlt),
      ),
      body: Container(),
    );
  }
}
