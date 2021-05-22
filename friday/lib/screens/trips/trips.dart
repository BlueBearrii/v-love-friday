import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/screens/trips/create_trip.dart';
import 'package:friday/screens/trips/trip_room.dart';

class Trips extends StatefulWidget {
  @override
  _TripsState createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  @override
  Widget build(BuildContext context) {
    CollectionReference trips = FirebaseFirestore.instance.collection('trips');
    User user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Trips",
          style: TextStyle(color: Colors.teal),
        ),
        actions: [
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.pen,
                size: 18,
                color: Colors.teal,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateTrip()));
              })
        ],
      ),
      body: StreamBuilder(
        stream: trips.where("uid", isEqualTo: user.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                print(scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent);
              },
              child: ListView(
                shrinkWrap: true,
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return SizedBox(
                    height: 500,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TripRoom(
                                      data:
                                          document.data()["tripId"].toString(),
                                      roomName: document
                                          .data()["tripName"]
                                          .toString(),
                                    )));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(document.data()["tripName"]),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
