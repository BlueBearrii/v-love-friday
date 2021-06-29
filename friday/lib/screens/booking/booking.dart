import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/host.dart';
import 'package:friday/screens/booking/host_information.dart';
import 'package:friday/utils/margin_space.dart';

class Booking extends StatefulWidget {
  final String tripId;
  final int balance;
  const Booking({
    Key key,
    this.tripId,
    this.balance,
  }) : super(key: key);

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  User user = FirebaseAuth.instance.currentUser;
  String type;
  String searchName;

  final search = TextEditingController();

  Future<List> fetchingHosing(type) async {
    return await HostingRoute.fetchAllHost(type, user.uid, searchName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget lifeStyleBtn(int index, String name) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: GestureDetector(
            onTap: () {
              if (name == "ทั้งหมด") {
                search.clear();
                setState(() {
                  type = null;
                });
              } else {
                setState(() {
                  type = name;
                });
              }
            },
            child: Card(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  name,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: TextField(
            controller: search,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: "Destination ...",
                suffixIcon: Icon(Icons.search),
                enabled: true,
                filled: true,
                border: UnderlineInputBorder(borderSide: BorderSide.none)),
            style: TextStyle(color: Colors.grey),
            textAlignVertical: TextAlignVertical.center,
            onChanged: (value) {
              setState(() {
                searchName = value;
              });
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        lifeStyleBtn(0, "โรงแรมและที่พัก"),
                        lifeStyleBtn(1, "สิ่งอำนวยความสะดวก")
                      ],
                    ),
                    Row(
                      children: [
                        lifeStyleBtn(2, "ร้านอาหารและเครื่องดื่ม"),
                        lifeStyleBtn(3, "กิจกรรม")
                      ],
                    ),
                    Row(
                      children: [
                        lifeStyleBtn(4, "ทั้งหมด"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 15, right: 15),
              child: Row(
                children: [
                  Text(
                    "Booking",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: fetchingHosing(type),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print(snapshot.data);
                  return snapshot.data == null
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.38,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.search,
                                size: 40,
                              ),
                              marginSpace(10, 0),
                              Text(
                                "Item not found!!",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(snapshot.data[index]["type"]);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HostInformation(
                                        balance: widget.balance,
                                        snapshot: snapshot.data[index],
                                        tripId: widget.tripId),
                                  ),
                                ).then((value) {
                                  print(value);
                                  if (value == true) {
                                    Navigator.pop(context, true);
                                  }
                                });
                              },
                              child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10.5),
                                  child: Card(
                                    child: Column(
                                      children: [
                                        AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: snapshot.data[index]
                                                        ["coverUrl"] ==
                                                    null
                                                ? Container(
                                                    color: Colors.grey,
                                                  )
                                                : Image.network(
                                                    snapshot.data[index]
                                                        ["coverUrl"],
                                                    fit: BoxFit.cover,
                                                  )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data[index]
                                                          ["hostName"],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    marginSpace(2, 0),
                                                    Text(
                                                      snapshot.data[index]
                                                          ["type"],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    marginSpace(2, 0),
                                                    Row(
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .mapMarkerAlt,
                                                          size: 14,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                        marginSpace(0, 2),
                                                        Text(
                                                          snapshot.data[index]
                                                                  ["address"]
                                                              ["province"],
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        marginSpace(0, 5),
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .solidHeart,
                                                          size: 14,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                        ),
                                                        marginSpace(0, 2),
                                                        Text(
                                                          snapshot
                                                              .data[index]
                                                                  ["likes"]
                                                              .length
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "${snapshot.data[index]["order"][0]["price"]}/${snapshot.data[index]["order"][0]["unit"]} ",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          });
                }
                return Center(
                  heightFactor: 5,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
