import 'package:flutter/material.dart';
import 'package:friday/common/custom_size.dart';
import 'package:friday/components/app/booking/booking_select.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final customSize = new CustomSize();
  final List litems = [
    "button title",
    "add",
    "list title",
  ];

  getListItems() {
    setState(() {
      litems.add("index 1");
      litems.add("index 2");
      litems.add("index 3");
      litems.add("index 4");
      litems.add("index 5");
      litems.add("index 6");
      litems.add("index 7");
    });
  }

  @override
  void initState() {
    super.initState();
    getListItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: ListView.builder(
            itemCount: litems.length,
            itemBuilder: (context, index) {
              if (litems[index] == "button title") {
                return Container(
                  width: customSize.getWidth(100, context),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Row(children: [
                    Text("Create new trip"),
                  ]),
                );
              } else if (litems[index] == "add") {
                return Container(
                  width: customSize.getWidth(100, context),
                  height: customSize.getHeight(8, context),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      Navigator.pushNamed(context, "/create_booking");
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                );
              } else if (litems[index] == "list title") {
                return Container(
                  width: customSize.getWidth(100, context),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Row(children: [
                    Text("Trips history"),
                  ]),
                );
              } else {
                return Container(
                  width: customSize.getWidth(100, context),
                  height: customSize.getHeight(25, context),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingSelect(
                            title: "Hello World",
                            message: litems[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 0.5, color: Colors.grey),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0),
                            )
                          ]),
                      child: Center(
                        child: Text(litems[index]),
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
