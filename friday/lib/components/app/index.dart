import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friday/components/app/booking/booking.dart';
import 'package:friday/components/app/setting/setting.dart';
import 'package:friday/main.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Text(
        'Index 0: Explore',
      ),
    ),
    Booking(),
    Setting()
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: "Explore"),
            BottomNavigationBarItem(
                icon: Icon(Icons.card_travel), label: "Booking"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Setting"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: _onItemTapped,
        ),
        body: _widgetOptions.elementAt(_selectedIndex));
  }
}
