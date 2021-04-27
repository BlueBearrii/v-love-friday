import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/utils/custom_size.dart';
import 'package:url_launcher/url_launcher.dart';

import 'booking_search.dart';

class BookingSelect extends StatefulWidget {
  final Map data;

  const BookingSelect({Key key, this.data}) : super(key: key);
  @override
  _BookingSelectState createState() => _BookingSelectState();
}

class _BookingSelectState extends State<BookingSelect> {
  final customSize = new CustomSize();
  final List _hotel = [];
  final List _activityAndPlace = [];

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("INDEX : ${widget.data}");
    var rating = (widget.data["rating"][0] +
            (widget.data["rating"][1] * 2) +
            (widget.data["rating"][2] * 3) +
            (widget.data["rating"][3] * 4) +
            (widget.data["rating"][4] * 5)) /
        (widget.data["rating"][0] +
            widget.data["rating"][1] +
            widget.data["rating"][2] +
            widget.data["rating"][3] +
            widget.data["rating"][4]);

    var voted_count = (widget.data["rating"][0] +
        widget.data["rating"][1] +
        widget.data["rating"][2] +
        widget.data["rating"][3] +
        widget.data["rating"][4]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        title: Text(
          widget.data["name"],
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BookingSearch()));
        },
        label: const Text('Booking here'),
        icon: const Icon(Icons.explore),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Card(
                      color: Colors.white,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.network(
                              widget.data["url"],
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "${widget.data["name"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              "Trip id",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.data["tripId"]}",
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Time period",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              "${widget.data["date"].length} day",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Budget",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              widget.data["budget"].toString(),
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Rating",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              "${rating.toStringAsFixed(1)} ($voted_count)",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow[500],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                height: 1,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  Expanded(
                    child: Text(
                      widget.data["storyTelling"] != null
                          ? widget.data["storyTelling"]
                          : "คุณยังไม่ได้บอกเล่าความรู้สึกแก่เราและคนอื่น",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                height: 1,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Accommodation",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Card(
                      color: Colors.blueAccent,
                      child: Center(
                          child: Text(
                        "You need to booking hotel ?",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                height: 1,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    "Activities and place",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.data['date'].length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                color: Colors.grey,
                              ),
                              Text(
                                "${widget.data['date'][index]}",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Divider(
                                    height: 1,
                                    thickness: 1,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 150,
                                child: Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: double.infinity,
                                              child: VerticalDivider(
                                                thickness: 1,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "12:00",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blueAccent),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: double.infinity,
                                              child: VerticalDivider(
                                                thickness: 1,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Card(
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(7),
                                                child: AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child: Image.network(
                                                    widget.data["url"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(7),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                          child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                                "Name : Mentor Coffee"),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                "Status : On going"),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                "Price : 10 Bath"),
                                                          ),
                                                        ],
                                                      )),
                                                      Divider(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Center(
                                                              child: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .solidCommentAlt,
                                                                  color: Colors
                                                                      .blueAccent),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Center(
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  print(
                                                                      "Clicky !!");
                                                                  await launch(
                                                                      'tel:0123456789');
                                                                },
                                                                child: FaIcon(
                                                                    FontAwesomeIcons
                                                                        .mobile,
                                                                    color: Colors
                                                                        .blueAccent),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Center(
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  print(
                                                                      "Clicky !!");

                                                                  final String
                                                                      googleMapslocationUrl =
                                                                      "https://www.google.com/maps/search/?api=1&query=12.9182,100.7803";

                                                                  final String
                                                                      encodedURl =
                                                                      Uri.encodeFull(
                                                                          googleMapslocationUrl);
                                                                  await launch(
                                                                      encodedURl);
                                                                },
                                                                child: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .locationArrow,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        height: 10,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  );
                }),
            Container(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
