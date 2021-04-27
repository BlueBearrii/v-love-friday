import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:friday/constants/api.dart';
import 'package:friday/utils/custom_size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateBooking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<CreateBooking> {
  final customSize = new CustomSize();
  final apiPath = new API();
  final dio = Dio();

  final String kohLan =
      "https://www.renown-travel.com/images/coral-island-l.jpg";

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(Duration(days: 1));

  String tripName;
  double budget;

  bool _loading = false;

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  createTrip() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    await storage
        .ref("wallpaper/${FirebaseAuth.instance.currentUser.uid}/$tripName")
        .putFile(_image)
        .then((value) async {
      await value.ref.getDownloadURL().then((path) async {
        await dio
            .post(apiPath.createTrip,
                data: json.encode({
                  "uid": FirebaseAuth.instance.currentUser.uid,
                  "name": tripName,
                  "budget": budget,
                  "wallpaper": path,
                  "date": [
                    DateFormat.yMMMd().format(selectedStartDate),
                    DateFormat.yMMMd().format(selectedEndDate)
                  ],
                }))
            .then((value) {
          print(value.data);
          setState(() {
            _loading = false;
          });
        }).then((value) {
          Navigator.pop(context);
        }).catchError((onError) => {print(onError)});
      });
    }).catchError((onError) => {print(onError)});
  }

  _selectDate(BuildContext context, _initialDate, day) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _initialDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      helpText: 'Select booking date', // Can be used as title
      cancelText: 'Not now',
      confirmText: 'Book',
    );
    if (day == 0) {
      if (picked != null && picked != selectedStartDate)
        setState(() {
          selectedStartDate = picked;
          selectedEndDate = picked.add(Duration(days: 1));
        });
    } else {
      if (picked != null && picked != selectedEndDate)
        setState(() {
          selectedEndDate = picked;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Create new trip",
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(children: [
                Container(
                  height: customSize.getHeight(30, context),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    image: DecorationImage(
                      image: _image != null
                          ? FileImage(_image)
                          : NetworkImage(kohLan),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    onPressed: getImage,
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        Text(
                          "Edit",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: customSize.getWidth(5, context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Select booking date",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text("Start", style: TextStyle(fontSize: 16)),
                              TextButton(
                                onPressed: () {
                                  _selectDate(context, selectedStartDate, 0);
                                },
                                child: Text(
                                  DateFormat.yMMMd().format(selectedStartDate),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text("End", style: TextStyle(fontSize: 16)),
                              TextButton(
                                onPressed: () {
                                  _selectDate(context, selectedEndDate, 1);
                                },
                                child: Text(
                                  DateFormat.yMMMd().format(selectedEndDate),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  tripName = value;
                                });
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.edit),
                                  hintText: "Please enter trip name"),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  budget = double.parse(value);
                                });
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.money_off),
                                  hintText: "Your budget"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, bottom: 30),
                      width: double.infinity,
                      child: _loading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.blueAccent),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 15),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _loading = true;
                                });
                                createTrip();
                              },
                              child: Text("Create plan"),
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
  }
}
