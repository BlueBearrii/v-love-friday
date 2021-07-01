import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/auth.dart';
import 'package:friday/apis/trips.dart';
import 'package:friday/auth/firebase_auth_class.dart';
import 'package:friday/screens/dashboard/components/recommend.dart';
import 'package:friday/screens/dashboard/components/trip_history.dart';
import 'package:friday/screens/hosting/hosting.dart';
import 'package:friday/utils/margin_space.dart';

import '../index.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user = FirebaseAuth.instance.currentUser;
  Map _user;

  Future<Map> fetchUserInfo() async {
    var data;
    await AuthRoute.userInfo(user.uid).then((value) {
      if (value != null) {
        print(value.data["message"]);
        data = value.data["message"];
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text("FRIDAY"),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: fetchUserInfo(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data != null) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Text("${snapshot.data["wallet"].toString()}"),
                            marginSpace(0, 5),
                            FaIcon(FontAwesomeIcons.wallet)
                          ],
                        ),
                      );
                    }
                  }

                  print("SnapShot : ${snapshot.data}");
                  return Row(
                    children: [
                      Text("Loading.."),
                      marginSpace(0, 5),
                      FaIcon(FontAwesomeIcons.wallet)
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              FutureBuilder(
                future: fetchUserInfo(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [Text("Loading ...")],
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: snapshot.data["user_image_path"] != null
                              ? Image.network(snapshot.data["user_image_path"])
                              : Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                        ),
                        marginSpace(0, 4),
                        Text(snapshot.data["displayName"])
                      ],
                    ),
                  );
                },
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextButton(
                      onPressed: null, //() {
                      //   Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //       builder: (ctx) => Hosting(),
                      //     ),
                      //   );
                      // },
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.building,
                            color: Colors.grey,
                          ),
                          marginSpace(0, 5),
                          Text(
                            "Hosting (soon)",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextButton(
                      onPressed: null,
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.wrench,
                            color: Colors.grey,
                          ),
                          marginSpace(0, 5),
                          Text(
                            "Setting (soon)",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextButton(
                      onPressed: () {
                        FirebaseAuthClass.signOut().then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Index()),
                              (route) => false);
                        });
                      },
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.signOutAlt,
                            color: Theme.of(context).accentColor,
                          ),
                          marginSpace(0, 5),
                          Text(
                            "Sign out",
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [TripHistory(), Reccomend()],
        ),
      ),
    );
  }
}
