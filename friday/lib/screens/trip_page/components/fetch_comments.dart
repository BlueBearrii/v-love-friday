import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/trips.dart';

class FetchComments extends StatefulWidget {
  final Map data;
  const FetchComments({Key key, this.data}) : super(key: key);

  @override
  _FetchCommentsState createState() => _FetchCommentsState();
}

class _FetchCommentsState extends State<FetchComments> {
  User user = FirebaseAuth.instance.currentUser;

  Future<List> fetchTripBook() async {
    List data = [];

    await TripRoute.fetchingComments(user.uid, widget.data["tripId"])
        .then((value) {
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
    return FutureBuilder(
      future: fetchTripBook(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.length != 0) {
            return mapComments(snapshot.data);
          } else {
            return Container();
          }
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

  Widget mapComments(List doc) {
    print(doc);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: doc.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Card(
                  color: Colors.white,
                  elevation: 1.2,
                  child: Column(
                    children: [
                      doc[index]["photo_path"] == ''
                          ? Container()
                          : Stack(children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  doc[index]["photo_path"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: doc[index]["commentor_profile"] !=
                                              null
                                          ? Image.network(
                                              doc[index]["commentor_profile"])
                                          : Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                    ),
                                    Text(
                                      doc[index]["commentor_name"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(doc[index]["comment"]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 15, right: 15, top: 0),
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            Row(
                              children: [
                                IconButton(
                                    icon: FaIcon(FontAwesomeIcons.heart),
                                    onPressed: () {}),
                                Text(doc[index]["likes"].length.toString())
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
