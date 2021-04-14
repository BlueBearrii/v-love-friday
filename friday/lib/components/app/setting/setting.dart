import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friday/common/custom_size.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final customSize = new CustomSize();
  final List menu = ["logout"];
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
            itemCount: menu.length,
            itemBuilder: (context, index) {
              if (menu[index] == "logout") {
                return ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance
                        .signOut()
                        .whenComplete(
                          () => Navigator.popUntil(
                            context,
                            ModalRoute.withName('/'),
                          ),
                        )
                        .then(
                          (value) => Navigator.pushNamed(context, '/sign_in'),
                        );
                  },
                  child: Text("Sign out"),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
