import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friday/apis/auth.dart';
import 'package:friday/auth/firebase_auth_class.dart';
import 'package:friday/screens/authentication/login.dart';
import 'package:friday/screens/dashboard/dashboard.dart';

class Index extends StatefulWidget {
  Index({Key key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return auth.currentUser == null ? Login() : Dashboard();
  }
}
