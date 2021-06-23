import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/screens/trip_page/components/comment_popup.dart';
import 'package:friday/screens/trip_page/components/cover.dart';
import 'package:friday/screens/trip_page/components/fetch_booking.dart';
import 'package:friday/screens/trip_page/components/fetch_comments.dart';
import 'package:friday/screens/trip_page/components/setting.dart';
import 'package:friday/utils/custom_loading.dart';
import 'package:image_picker/image_picker.dart';

class TripPage extends StatefulWidget {
  final Map data;
  const TripPage({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  User user = FirebaseAuth.instance.currentUser;

  File _image;
  String _image_path;
  final picker = ImagePicker();

  Future getImage() async {
    try {
      final PickedFile pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

      setState(() {
        _image = File(pickedFile.path);
        _image_path = pickedFile.path;
      });

      print(_image);
    } catch (e) {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context)
                      .push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                          Setting(tripId: widget.data["tripId"]),
                    ),
                  )
                      .then((value) {
                    if (value == true) {
                      setState(() {});
                    }
                  });
                })
          ],
        ),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              Cover(data: widget.data),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "การจองของทริป",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                              "คุณสามารถเริ่มต้นการจองกิจกรรม หรือ สถานที่ต่าง ๆ \nเพื่อเนรมิตทริปในแบบที่คุณต้องการ\nและสร้างความทรงจำที่น่าจดจำ"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FetchBookingLists(data: widget.data),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "บันทึกความทรงจำ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                              "โพสและแชร์เรื่องราวของคุณผ่านแคปชั่นและภาพถ่าย \nเพื่อเป็นความทรงจำที่ดีในระหว่างทริป"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            return Navigator.of(context)
                                .push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) =>
                                    CommentPopUp(data: widget.data),
                              ),
                            )
                                .then((value) {
                              if (value == true) {
                                setState(() {});
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(width: 0.5, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "เขียนบันทึก",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.pen,
                                    color: Colors.grey,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FetchComments(data: widget.data)
            ],
          ),
        ));
  }
}
