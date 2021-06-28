import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friday/apis/trips.dart';
import 'package:image_picker/image_picker.dart';

class Setting extends StatefulWidget {
  final String tripId;
  const Setting({Key key, this.tripId}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  User user = FirebaseAuth.instance.currentUser;

  File _image;
  String _image_path;
  final picker = ImagePicker();

  Future<String> updateCover() async {
    String data;

    await TripRoute.updateCover(user.uid, widget.tripId, _image_path)
        .then((value) {
      if (value != null) {
        data = value;
      }
    });
    return data;
  }

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

  Future<bool> _showMyDialog(String message) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('สถานะการอัพเดท'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("การอัพเดท $message"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ปิด'),
              onPressed: () {
                if (message == "สำเร็จ")
                  Navigator.pop(context, true);
                else
                  Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: Center(
        child: SizedBox(
          width: 350,
          height: 450,
          child: Card(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        "ตั้งค่าหน้าปกทริป",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(child: Container()),
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context, true);
                        })
                  ],
                ),
                Stack(children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _image == null
                        ? Container(
                            color: Colors.grey,
                          )
                        : Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey)),
                        onPressed: getImage,
                        icon: Icon(Icons.camera),
                        label: Text("เลือกรูป")),
                  ),
                ]),
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: _image == null
                            ? null
                            : () async {
                                await updateCover().then((value) {
                                  if (value == "updated") {
                                    _showMyDialog("สำเร็จ").then((value) {
                                      if (value == true) {
                                        Navigator.pop(context, true);
                                      }
                                    });
                                  } else {
                                    _showMyDialog("ไม่สำเร็จ");
                                  }
                                });
                              },
                        child: Text("ยืนยัน"))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        "ตั้งค่าความเป็นสาธารณะ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection("trips")
                                .doc(widget.tripId)
                                .set({
                              "public": true
                            }, SetOptions(merge: true)).then(
                                    (value) => _showMyDialog("สำเร็จ"));
                          },
                          child: Text("สาธารณะ")),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection("trips")
                                .doc(widget.tripId)
                                .set({
                              "public": false
                            }, SetOptions(merge: true)).then(
                                    (value) => _showMyDialog("สำเร็จ"));
                          },
                          child: Text(
                            "ส่วนตัว",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
