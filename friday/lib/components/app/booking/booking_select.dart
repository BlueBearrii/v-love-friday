import 'package:flutter/material.dart';

class BookingSelect extends StatefulWidget {
  final String title;
  final String message;

  const BookingSelect({Key key, this.title, this.message}) : super(key: key);
  @override
  _BookingSelectState createState() => _BookingSelectState();
}

class _BookingSelectState extends State<BookingSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Column(
          children: [
            Text(widget.title),
            Text(widget.message),
          ],
        ),
      ),
    );
  }
}
