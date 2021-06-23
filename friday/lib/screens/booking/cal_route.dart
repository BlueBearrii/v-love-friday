import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CalRout extends StatefulWidget {
  final String tripId;
  final String position;
  const CalRout({Key key, this.tripId, this.position}) : super(key: key);

  @override
  _CalRoutState createState() => _CalRoutState();
}

class _CalRoutState extends State<CalRout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("booking")
            .orderBy("createdAt", descending: false)
            .get()
            .then((value) {
          List arr = [];
          value.docs.forEach((element) {
            if (element.data()["tripId"] == widget.tripId) {
              arr.add(element.data());
            }
          });
          return arr;
        }),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length != 0) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "เลือกจุดเริ่มต้นของคุณเพื่อศึกษาระยะทาง",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (cxt, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            child: SizedBox(
                              height: 180,
                              width: double.infinity,
                              child: Card(
                                child: Row(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.network(
                                          snapshot.data[index]["coverUrl"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              snapshot.data[index]["hostName"]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(DateFormat.yMMMd()
                                              .format(DateTime.parse(snapshot
                                                  .data[index]["bookingDate"]))
                                              .toString()),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(DateFormat.jm()
                                              .format(DateTime.parse(snapshot
                                                  .data[index]["bookingDate"]))
                                              .toString()),
                                        ),
                                        SizedBox(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton.icon(
                                                  onPressed: () async {
                                                    final String
                                                        googleMapslocationUrl =
                                                        "https://www.google.com/maps/dir/King+Mongkut’s+University+of+Technology+Thonburi,+126+Pracha+Uthit+Rd,+Bang+Mot,+Thung+Khru,+Bangkok+10140/King+Mongkut’s+University+of+Technology+Thonburi/King+Mongkut's+University+of+Technology+Thonburi+(Bangkhuntian)/";

                                                    final String encodedURl =
                                                        Uri.encodeFull(
                                                            googleMapslocationUrl);
                                                    await launch(encodedURl);
                                                  },
                                                  icon: Icon(
                                                    Icons.explore,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  label: Text(
                                                    "กดเพื่อดูระยะทาง",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              );
            }
          }
          return Center(
            child: Text(
              "Loading ...",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          );
        },
      ),
    );
  }
}
