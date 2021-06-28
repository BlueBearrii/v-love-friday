import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/trips.dart';
import 'package:friday/screens/dashboard/components/create%20_trip_overlay.dart';
import 'package:friday/screens/trip_page/trip_page.dart';
import 'package:friday/utils/margin_space.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({Key key}) : super(key: key);

  @override
  _TripHistoryState createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {
  User user = FirebaseAuth.instance.currentUser;

  Future<List> fetchHistoryTrips() async {
    List data = ["Initial Create card"];
    await TripRoute.fetchTrips(user.uid).then((value) {
      if (value != null) {
        value.forEach((element) {
          data.add(element);
        });
      }
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 360,
        child: Center(
          child: FutureBuilder<List>(
            future: fetchHistoryTrips(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 16, bottom: 8),
                    child: Text(
                      "ประสบการณ์ทริปของคุณ",
                      style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                        initialPage: snapshot.data.length > 1 ? 1 : 0,
                        height: 300,
                        viewportFraction: 0.8,
                        enableInfiniteScroll:
                            snapshot.data.length > 1 ? true : false,
                        enlargeCenterPage: true),
                    items: snapshot.data.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: 500,
                            height: 300,
                            child: i == "Initial Create card"
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(
                                        PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder:
                                              (BuildContext context, _, __) =>
                                                  CreateTripOverlay(),
                                        ),
                                      )
                                          .then((value) {
                                        if (value == true) {
                                          setState(() {});
                                          //fetchHistoryTrips();
                                        }
                                      });
                                    },
                                    child: Card(
                                      child: Stack(children: [
                                        Positioned(
                                          top: 20,
                                          right: 20,
                                          child: FaIcon(
                                            FontAwesomeIcons.cloud,
                                            size: 40,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Positioned(
                                          top: 60,
                                          right: 60,
                                          child: FaIcon(
                                            FontAwesomeIcons.cloud,
                                            size: 30,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Positioned(
                                          top: 20,
                                          left: 20,
                                          child: FaIcon(
                                            FontAwesomeIcons.cloud,
                                            size: 20,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 40,
                                          child: FaIcon(
                                            FontAwesomeIcons.cloud,
                                            size: 40,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -120,
                                          right: -20,
                                          child: Container(
                                            height: 180,
                                            width: 180,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(90),
                                                ),
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -130,
                                          left: -20,
                                          child: Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(100),
                                                ),
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.fly,
                                              size: 60,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            marginSpace(5, 0),
                                            Text(
                                              'เริ่มสร้างทริปของคุณที่นี่ \nคลิ๊กเลย !!',
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Color.fromRGBO(
                                                      51, 51, 51, 1),
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                            pageBuilder:
                                                (BuildContext context, _, __) =>
                                                    TripPage(
                                                      data: i,
                                                    )),
                                      );
                                    },
                                    child: Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: Colors.white10,
                                      child: Stack(
                                        children: [
                                          i["coverUrl"] == null
                                              ? Center(
                                                  child: Icon(
                                                    Icons.image,
                                                    size: 50,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Container(
                                                  height: double.infinity,
                                                  child: Image.network(
                                                    i["coverUrl"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  const Color(0x00000000),
                                                  const Color(0x00000000),
                                                  const Color(0x00000000),
                                                  const Color(0xCC000000),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        i["tripName"],
                                                        style: TextStyle(
                                                            fontSize: 22.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      marginSpace(2, 0),
                                                      Text(
                                                        "งบประมาณ : ${i["budget"].toString()} บาท",
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            letterSpacing: 0.5,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      marginSpace(2, 0),
                                                      Row(
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .mapMarkerAlt,
                                                            size: 16,
                                                            color: Colors.white,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        2),
                                                          ),
                                                          Text(
                                                            i["destination"],
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          marginSpace(0, 5),
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .calendar,
                                                            size: 16,
                                                            color: Colors.white,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        2),
                                                          ),
                                                          Text(
                                                            i["days"],
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .heart,
                                                            color: Colors.white,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        2.5),
                                                          ),
                                                          Text(
                                                            i["likes"]
                                                                .length
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
