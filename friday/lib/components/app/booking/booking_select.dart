import 'package:flutter/material.dart';
import 'package:friday/common/custom_size.dart';

class BookingSelect extends StatefulWidget {
  final Map data;

  const BookingSelect({Key key, this.data}) : super(key: key);
  @override
  _BookingSelectState createState() => _BookingSelectState();
}

class _BookingSelectState extends State<BookingSelect> {
  final customSize = new CustomSize();

  final String kohLan =
      "https://www.renown-travel.com/images/coral-island-l.jpg";
  @override
  Widget build(BuildContext context) {
    print("INDEX : ${widget.data}");
    return Scaffold(
      body: Stack(children: [
        Container(
          child: Column(
            children: [
              Container(
                height: customSize.getHeight(30, context),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  image: DecorationImage(
                    image: NetworkImage(widget.data["image"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.data["title"],
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Booking id : ${widget.data["booking_id"]}",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Colors.grey,
                          ),
                          Text(
                            widget.data["location"],
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    print("Clicky !!");
                  }),
            ],
          ),
          body: Container(),
        ),
      ]),
    );
  }
}
