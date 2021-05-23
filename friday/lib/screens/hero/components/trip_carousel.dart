import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TripCarousel extends StatefulWidget {
  @override
  _TripCarouselState createState() => _TripCarouselState();
}

class _TripCarouselState extends State<TripCarousel> {
  Stream collectionStream = FirebaseFirestore.instance
      .collection('trips')
      .where('uid', isEqualTo: "RERUlKWhTjbXJ7DgHhmcrcDjaJp1")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: collectionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          }
          return CarouselSlider(
            options: CarouselOptions(
              //height: 300.0,
              aspectRatio: 4 / 3,
              enableInfiniteScroll: false,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
            ),
            items: snapshot.data.docs.map((DocumentSnapshot document) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      print("Trip Name : ${document.data()['tripName']}");
                    },
                    child: Container(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(document.data()['tripName']),
                              Text(document.data()['uid'])
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(growable: false),
          );
        });
  }
}
