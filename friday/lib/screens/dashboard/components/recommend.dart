import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/trips.dart';
import 'package:friday/screens/dashboard/components/rec_trip.dart';
import 'package:friday/utils/custom_loading.dart';
import 'package:friday/utils/margin_space.dart';

class Reccomend extends StatefulWidget {
  const Reccomend({Key key}) : super(key: key);

  @override
  _ReccomendState createState() => _ReccomendState();
}

class _ReccomendState extends State<Reccomend> {
  User user = FirebaseAuth.instance.currentUser;

  Future<List> fetchTripBook() async {
    List data = [];

    await TripRoute.fetchingPublicTrips(user.uid).then((value) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ประสบการณ์ทริปที่ถูกแชร์เป็นสาธารณะ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(51, 51, 51, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "คุณสามารถร่วมชมเพื่อมองหาไอเดียใหม่ในการเที่ยว\nและสามารถร่วมแสดงความคิดเห็นต่อทริปของเขาได้",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(51, 51, 51, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: fetchTripBook(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(snapshot.data);
              if (snapshot.data.length != 0) {
                return mapPublicRecommend(snapshot.data);
              } else {
                return Container();
              }
            }
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget mapPublicRecommend(doc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: doc.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    CustomLoading.dynamicPopup(
                        context, RecTrip(data: doc[index]));
                  },
                  child: Card(
                    child: Container(
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              doc[index]["coverUrl"],
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc[index]["tripName"],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                            "Budget : ${doc[index]["budget"].toString()} Baht"),
                                        Row(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.mapMarkerAlt,
                                              size: 16,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            marginSpace(0, 5),
                                            Text(doc[index]["destination"]),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(FontAwesomeIcons.solidHeart,
                                              color: Theme.of(context)
                                                  .accentColor),
                                          marginSpace(0, 5),
                                          Text(doc[index]["likes"]
                                              .length
                                              .toString())
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
