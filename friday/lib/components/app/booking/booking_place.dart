import 'package:flutter/material.dart';

class BookingPlace extends StatefulWidget {
  final Map data;

  const BookingPlace({Key key, this.data}) : super(key: key);
  @override
  _BookingPlaceState createState() => _BookingPlaceState();
}

class _BookingPlaceState extends State<BookingPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.data["name"],
            style: TextStyle(color: Colors.black87),
          ),
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("Confirm ?"),
                content: Text("You want to confirm ?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("No"),
                  )
                ],
              ),
              barrierDismissible: false,
            );
          },
          label: const Text('Booking Now'),
          icon: const Icon(Icons.explore),
          backgroundColor: Colors.blueAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                widget.data["image"],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(widget.data["address"]),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(widget.data["phone"]),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Description : " + widget.data["details"]),
            ),
            Container(),
          ],
        )));
  }
}
