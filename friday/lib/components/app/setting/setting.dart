import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friday/utils/custom_size.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final customSize = new CustomSize();
  final List menu = ["logout"];

  _signOut() {
    FirebaseAuth.instance
        .signOut()
        .whenComplete(
          () => Navigator.popUntil(
            context,
            ModalRoute.withName('/'),
          ),
        )
        .then(
      (value) {
        Navigator.pushNamed(context, '/sign_in');
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == null) {
              return Container();
            } else {
              return Center(
                child: ElevatedButton(
                    onPressed: _signOut, child: Text("Sign Out")),
              );
            }
          }
        },
      ),
    );
  }
}
