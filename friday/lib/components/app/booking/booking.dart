import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friday/constants/api.dart';
import 'package:friday/utils/custom_size.dart';

import 'booking_select.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final customSize = new CustomSize();
  final apiPath = new API();
  final dio = Dio();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trips",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Colors.white54,
      body: StreamBuilder<Object>(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Please sign-in to booking"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/sign_in');
                          },
                          child: Text("Sign in"),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                String uid = FirebaseAuth.instance.currentUser.uid;
                return StreamBuilder(
                    stream: firestore
                        .collection("trips")
                        .where('uid', isEqualTo: uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView(
                        shrinkWrap: true,
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          print(document.data());
                          var rating = (document.data()["rating"][0] +
                                  (document.data()["rating"][1] * 2) +
                                  (document.data()["rating"][2] * 3) +
                                  (document.data()["rating"][3] * 4) +
                                  (document.data()["rating"][4] * 5)) /
                              (document.data()["rating"][0] +
                                  document.data()["rating"][1] +
                                  document.data()["rating"][2] +
                                  document.data()["rating"][3] +
                                  document.data()["rating"][4]);

                          var voted_count = (document.data()["rating"][0] +
                              document.data()["rating"][1] +
                              document.data()["rating"][2] +
                              document.data()["rating"][3] +
                              document.data()["rating"][4]);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookingSelect(data: document.data()),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 350,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5.0), // if you need this
                                    side: BorderSide(
                                      color: Colors.grey.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  elevation: 1.2,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                            document.data()['url'],
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover, loadingBuilder:
                                                (context, child,
                                                    loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                          );
                                        }),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                    document.data()['name']),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("งบประมาณ " +
                                                        document
                                                            .data()['budget']
                                                            .toString() +
                                                        " บาท"),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "เริ่มต้น : วันที่ " +
                                                                document.data()[
                                                                    'date'][0] +
                                                                " ถึง " +
                                                                document.data()[
                                                                    'date'][1]),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "คะแนน : ${rating.toStringAsFixed(1)} ($voted_count)"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    });
              }
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
