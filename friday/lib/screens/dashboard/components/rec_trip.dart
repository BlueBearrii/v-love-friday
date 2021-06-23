import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/screens/dashboard/components/fet_rec_trip.dart';
import 'package:friday/screens/trip_page/components/comment_popup.dart';
import 'package:friday/screens/trip_page/components/cover.dart';
import 'package:friday/screens/trip_page/components/fetch_booking.dart';
import 'package:friday/screens/trip_page/components/fetch_comments.dart';
import 'package:friday/utils/custom_loading.dart';

class RecTrip extends StatefulWidget {
  final Map data;
  const RecTrip({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  _RecTripState createState() => _RecTripState();
}

class _RecTripState extends State<RecTrip> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              Cover(data: widget.data),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Booking",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Text("List of all your booking"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FetRecTrip(data: widget.data),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Post",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FetchComments(data: widget.data)
            ],
          ),
        ));
  }
}
