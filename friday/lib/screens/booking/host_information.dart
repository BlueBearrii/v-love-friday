import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/trips.dart';
import 'package:friday/main.dart';
import 'package:friday/screens/booking/cal_route.dart';
import 'package:friday/screens/booking/likeLlocal.dart';
import 'package:friday/utils/custom_loading.dart';
import 'package:friday/utils/margin_space.dart';
import 'package:friday/utils/time.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HostInformation extends StatefulWidget {
  final Map snapshot;
  final String tripId;
  final int balance;
  const HostInformation({Key key, this.snapshot, this.tripId, this.balance})
      : super(key: key);

  @override
  _HostInformationState createState() => _HostInformationState();
}

class _HostInformationState extends State<HostInformation> {
  User user = FirebaseAuth.instance.currentUser;

  int priceResult = 0;
  List keptVolumn = [];

  int people = 0;

  int dropdownHrValue = TimeSelect.hour[0];
  int dropdownMnValue = TimeSelect.min10[0];

  DateTime selectedDateCheckIn = DateTime.now();
  DateTime selectedDateCheckOut = DateTime.now();

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _selectedDateCheckIn(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDateCheckIn)
      setState(() {
        selectedDateCheckIn = picked;
        selectedDateCheckOut = picked;
      });
  }

  _selectedDateCheckOut(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDateCheckIn,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDateCheckOut)
      setState(() {
        selectedDateCheckOut = picked;
      });
  }

  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'smith@example.com',
    queryParameters: {'subject': 'Example Subject & Symbols are allowed!'},
  );

  Future<bool> _showMyDialog_() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('ยอดเงินของคุณไม่เพียงพอ'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการจอง'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'ระบบจะทำการชำระเงินโดยอัตโนมัติ\nคุณต้องการยืนยันการจองครั้งนี้ใช่หรือไม่ ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.snapshot);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      widget.snapshot["coverUrl"] == null
                          ? Container(
                              color: Colors.grey,
                            )
                          : AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                widget.snapshot["coverUrl"],
                                fit: BoxFit.cover,
                              ),
                            ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.8,
                        width: MediaQuery.of(context).size.width,
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
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.snapshot["hostName"],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  marginSpace(2, 0),
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.mapMarkerAlt,
                                        size: 14,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      marginSpace(0, 2),
                                      Text(
                                        widget.snapshot["address"]["province"],
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      marginSpace(0, 5),
                                      FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        size: 14,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      marginSpace(0, 2),
                                      Text(
                                        widget.snapshot["likes"].length
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                marginSpace(10, 0),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "รายละเอียด",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(widget.snapshot["description"]),
                        ),
                      ],
                    ),
                  ),
                ),
                marginSpace(10, 0),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "ติดต่อ",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.email),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(widget.snapshot["contact"]['email']),
                            ),
                            Expanded(child: Container()),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextButton(
                                  onPressed: () async {
                                    await launch(
                                        "mailto:${widget.snapshot["contact"]['email']}?subject=ติดต่อจากแอปพลิเคชัน Friday&body=");
                                  },
                                  child: Text("อีเมล์")),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.phone),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(widget.snapshot["contact"]["phone"]),
                            ),
                            Expanded(child: Container()),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextButton(
                                  onPressed: () async {
                                    await _makePhoneCall(
                                        "tel:${widget.snapshot["contact"]["phone"]}");
                                  },
                                  child: Text("โทร")),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                marginSpace(10, 0),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "ที่อยู่",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () async {
                              final String googleMapslocationUrl =
                                  "https://www.google.com/maps/place/King+Mongkut’s+University+of+Technology+Thonburi/@13.65117,100.4944552,17z/data=!3m1!4b1!4m5!3m4!1s0x30e2a251bb6b0cf1:0xf656e94ff13324ad!8m2!3d13.65117!4d100.4966439";

                              final String encodedURl =
                                  Uri.encodeFull(googleMapslocationUrl);
                              await launch(encodedURl);
                            },
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Stack(children: [
                                Image.network(
                                  "https://previews.123rf.com/images/ket4up/ket4up1707/ket4up170700042/81563570-gps-navigation-background-road-map-vector-illustration.jpg",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: null,
                                    child: Text(
                                      "แผนที่",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.home),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:
                                  Text(widget.snapshot["address"]['address']),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.home),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(widget.snapshot["address"]['city']),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.home),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:
                                  Text(widget.snapshot["address"]['province']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                marginSpace(10, 0),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "เงื่อนไขการจอง",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(widget.snapshot["conditions"]),
                        ),
                      ],
                    ),
                  ),
                ),
                marginSpace(10, 0),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "คำนวณการเดินทางก่อนเริ่มจอง",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (cxt) => CalRout(
                                        tripId: widget.tripId,
                                        position:
                                            "${widget.snapshot["lat"]},${widget.snapshot["long"]}"),
                                  ),
                                );
                              },
                              child: Text(
                                "ไปที่หน้าคำนวณเส้นทาง",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                marginSpace(10, 0),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "เลือกเวลาที่ต้องการ",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _selectedDateCheckIn(context);
                              },
                              child: Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("เช็คอิน"),
                                          Text(DateFormat.yMMMd()
                                              .format(selectedDateCheckIn)
                                              .toString())
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _selectedDateCheckOut(context);
                              },
                              child: Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("เช็คเอ้าท์"),
                                          Text(DateFormat.yMMMd()
                                              .format(selectedDateCheckOut)
                                              .toString())
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Card(
                        child: Row(children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text("ชั่วโมง"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          DropdownButton<int>(
                                            value: dropdownHrValue,
                                            isDense: true,
                                            iconSize: 0,
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            underline: Container(),
                                            onChanged: (int newValue) {
                                              setState(() {
                                                dropdownHrValue = newValue;
                                              });
                                            },
                                            items: TimeSelect.hour.map((value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Text("นาที"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          DropdownButton<int>(
                                            isDense: true,
                                            iconSize: 0,
                                            value: dropdownMnValue,
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            underline: Container(),
                                            onChanged: (int newValue) {
                                              setState(() {
                                                dropdownMnValue = newValue;
                                              });
                                            },
                                            items:
                                                TimeSelect.min10.map((value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      Row(children: [
                        Expanded(
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    if (people > 0) {
                                      setState(() {
                                        people--;
                                      });
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("จำนวนคน"),
                                      Text(people.toString())
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      people++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                marginSpace(10, 0),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "สิ่งที่น่่าสนใจ",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.snapshot["order"].length,
                        itemBuilder: (BuildContext ctx, int index) {
                          keptVolumn.add(0);
                          return SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Card(
                              child: Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Image.network(
                                        widget.snapshot["order"][index]
                                            ["image_path"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 4),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      widget.snapshot["order"]
                                                          [index]["title"],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "ราคา : ${widget.snapshot["order"][index]["price"]} / ${widget.snapshot["order"][index]["unit"]}",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  icon:
                                                      Icon(Icons.remove_circle),
                                                  onPressed: () {
                                                    if (keptVolumn[index] > 0) {
                                                      setState(() {
                                                        keptVolumn[index]--;
                                                        priceResult = priceResult -
                                                            int.parse(widget
                                                                        .snapshot[
                                                                    "order"][
                                                                index]["price"]);
                                                      });
                                                    }
                                                  }),
                                              Expanded(
                                                child: Text(
                                                  keptVolumn[index].toString(),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () {
                                                    setState(() {
                                                      keptVolumn[index]++;
                                                      priceResult = priceResult +
                                                          int.parse(widget
                                                                      .snapshot[
                                                                  "order"]
                                                              [index]["price"]);
                                                    });
                                                  }),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.only(bottom: 100),
                  child: Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: double.infinity,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "รวม  ${priceResult.toString()}  บาท",
                              ),
                            ],
                          ),
                        ),
                      )),
                      SizedBox(
                        height: double.infinity,
                        child: ElevatedButton(
                            onPressed: priceResult == 0
                                ? null
                                : () async {
                                    print(widget.balance);
                                    print(priceResult);
                                    if (priceResult > widget.balance) {
                                      _showMyDialog_();
                                    } else {
                                      _showMyDialog().then((value) async {
                                        print(value);
                                        if (value == true) {
                                          CustomLoading.loadingNormal(context);
                                          await TripRoute.bookNow({
                                            "pay": priceResult,
                                            "uid": user.uid,
                                            "tripId": widget.tripId,
                                            "hostId": widget.snapshot["hostid"],
                                            "hostName":
                                                widget.snapshot["hostName"],
                                            "coverUrl":
                                                widget.snapshot["coverUrl"],
                                            "phone": widget.snapshot["contact"]
                                                ["phone"],
                                            "bookingDate": DateTime(
                                                    selectedDateCheckIn.year,
                                                    selectedDateCheckIn.month,
                                                    selectedDateCheckIn.day,
                                                    dropdownHrValue,
                                                    dropdownMnValue)
                                                .toString()
                                          }).then((value) {
                                            if (value == true) {
                                              Navigator.pop(context);
                                              Navigator.pop(context, true);
                                            } else {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }
                                          });
                                        }
                                      });
                                    }
                                  },
                            child: Text("Booking now")),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
