import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/trips.dart';
import 'package:friday/screens/booking/booking.dart';
import 'package:intl/intl.dart';

class FetRecTrip extends StatefulWidget {
  final Map data;
  const FetRecTrip({Key key, this.data}) : super(key: key);

  @override
  _FetRecTripState createState() => _FetRecTripState();
}

class _FetRecTripState extends State<FetRecTrip> {
  User user = FirebaseAuth.instance.currentUser;
  int balance;

  Future<List> fetchTripBook() async {
    List data = [];

    balance = await TripRoute.loadBalanceUpdated(
        widget.data["uid"], widget.data["tripId"]);

    await TripRoute.fetchTripBooking(widget.data["uid"], widget.data["tripId"])
        .then((value) {
      if (value != null) {
        value.forEach((element) {
          data.add(element);
        });
      }
    });
    return data;
  }

  Widget setDateTime(String date) {
    var cvt = DateTime.parse(date);

    var _formatDate = DateFormat("d MMMM yyyy")
        .format(DateTime(cvt.year, cvt.month, cvt.day));
    var _formatTime = DateFormat("h:mm a")
        .format(DateTime(cvt.year, cvt.month, cvt.day, cvt.hour, cvt.minute));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date : $_formatDate",
          style: TextStyle(fontSize: 14.0),
        ),
        Text(
          "Time : $_formatTime",
          style: TextStyle(fontSize: 14.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTripBook(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CarouselSlider.builder(
            options: CarouselOptions(
              height: 300.0,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: false,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int itemIndex, int index) {
              return Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      snapshot.data[itemIndex]["coverUrl"] == null
                          ? Container(
                              width: double.infinity,
                              color: Colors.grey,
                            )
                          : Image.network(
                              snapshot.data[itemIndex]["coverUrl"],
                              fit: BoxFit.cover,
                            ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data[itemIndex]["hostName"],
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    "Price : ${snapshot.data[itemIndex]["pay"].toString()} Baht",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  setDateTime(
                                      snapshot.data[itemIndex]["bookingDate"])
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 10,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
        );
      },
    );
  }
}
