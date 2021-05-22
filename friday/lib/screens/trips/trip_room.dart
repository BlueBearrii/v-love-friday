import 'package:flutter/material.dart';
import 'package:friday/screens/booking/fetching_lists.dart';

class TripRoom extends StatefulWidget {
  final String data;
  final String roomName;
  const TripRoom({Key key, this.data, this.roomName}) : super(key: key);

  @override
  _TripRoomState createState() => _TripRoomState();
}

class _TripRoomState extends State<TripRoom> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => FetchingLists()));
        },
        label: const Text('Booking here'),
        icon: const Icon(Icons.explore),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(),
    );
  }
}
