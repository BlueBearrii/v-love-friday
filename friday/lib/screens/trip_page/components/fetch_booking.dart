import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/trips.dart';
import 'package:friday/screens/booking/booking.dart';
import 'package:friday/utils/margin_space.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class FetchBookingLists extends StatefulWidget {
  final Map data;
  const FetchBookingLists({Key key, this.data}) : super(key: key);

  @override
  _FetchBookingListsState createState() => _FetchBookingListsState();
}

class _FetchBookingListsState extends State<FetchBookingLists> {
  User user = FirebaseAuth.instance.currentUser;
  int balance;

  Future<List> fetchTripBook() async {
    List data = [];

    balance =
        await TripRoute.loadBalanceUpdated(user.uid, widget.data["tripId"]);

    await TripRoute.fetchTripBooking(user.uid, widget.data["tripId"])
        .then((value) {
      if (value != null) {
        value.forEach((element) {
          data.add(element);
        });
      }
    });

    data.add("initial booking");
    return data;
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
          "วันที่ทำการจอง : $_formatDate",
          style: TextStyle(fontSize: 14.0),
        ),
        Text(
          "เวลาเข้าเช็คอิน : $_formatTime",
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
              String initialMessage = "initial booking";
              return snapshot.data[itemIndex] == initialMessage
                  ? GestureDetector(
                      onTap: balance == 0
                          ? null
                          : () {
                              Navigator.of(context)
                                  .push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) =>
                                      Booking(
                                    balance: balance,
                                    tripId: widget.data["tripId"],
                                  ),
                                ),
                              )
                                  .then((value) {
                                setState(() {});
                              });
                            },
                      child: Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.wallet,
                                size: 48,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                'ยอดเงินคงเหลือ ${balance.toString()} บาท \n คลิ๊ก! เพื่อหาประสบการณ์ที่คุณสนใจ',
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Card(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[itemIndex]["hostName"],
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        Text(
                                          "ราคา : ${snapshot.data[itemIndex]["pay"].toString()} บาท",
                                          style: TextStyle(fontSize: 14.0),
                                        ),
                                        setDateTime(snapshot.data[itemIndex]
                                            ["bookingDate"])
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              bottom: 10,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await _makePhoneCall(
                                          "tel:${widget.data[itemIndex]["phone"]}");
                                    },
                                    icon: Icon(
                                      Icons.call,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  marginSpace(0, 2),
                                  IconButton(
                                    onPressed: () async {
                                      final String googleMapslocationUrl =
                                          "https://www.google.com/maps/place/King+Mongkut’s+University+of+Technology+Thonburi/@13.65117,100.4944552,17z/data=!3m1!4b1!4m5!3m4!1s0x30e2a251bb6b0cf1:0xf656e94ff13324ad!8m2!3d13.65117!4d100.4966439";

                                      final String encodedURl =
                                          Uri.encodeFull(googleMapslocationUrl);
                                      await launch(encodedURl);
                                    },
                                    icon: Icon(
                                      Icons.navigation,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
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
