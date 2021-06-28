import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/host.dart';
import 'package:friday/utils/custom_loading.dart';
import 'package:friday/utils/loading_nomal.dart';
import 'package:friday/utils/margin_space.dart';
import 'package:image_picker/image_picker.dart';

class CreateHost extends StatefulWidget {
  const CreateHost({Key key}) : super(key: key);

  @override
  _CreateHostState createState() => _CreateHostState();
}

class _CreateHostState extends State<CreateHost> {
  User user = FirebaseAuth.instance.currentUser;
  List<String> type = [
    "กิจกรรม",
    "โรงแรมและที่พัก",
    "ร้านอาหารและเครื่องดื่ม",
    "สิ่งอำนวยความสะดวก"
  ];
  List<Map> data = [
    {"title": null, "price": null, "unit": null, "image_path": null}
  ];

  List<Map> dataPreview = [
    {
      "image_preview": null,
    }
  ];
  File cover;
  String coverUrl;
  String selected_type;
  String hostName;
  String email;
  String description;
  String conditions;
  String phone;

  String province;
  String city;
  String address;

  final picker = ImagePicker();

  Future getImage(index) async {
    try {
      final PickedFile pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 100);

      setState(() {
        dataPreview[index]["image_preview"] = File(pickedFile.path);
        data[index]["image_path"] = pickedFile.path;
      });
    } catch (e) {
      print('No image selected.');
    }
  }

  Future getImageCover() async {
    try {
      final PickedFile pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 100);

      setState(() {
        cover = File(pickedFile.path);
        coverUrl = pickedFile.path;
      });
    } catch (e) {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                HostingRoute.createHost({
                  "uid": user.uid,
                  "hostName": hostName,
                  "address": {
                    "address": address,
                    "city": city,
                    "province": province
                  },
                  "contact": {"email": email, "phone": phone},
                  "order": data,
                  "description": description,
                  "conditions": conditions,
                  "coverUrl": coverUrl,
                  "type": selected_type
                }).then((value) {
                  return Navigator.pop(context);
                });
              })
        ],
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(children: [
              AspectRatio(
                  aspectRatio: 16 / 9,
                  child: cover == null
                      ? Container(
                          color: Colors.grey,
                        )
                      : Image.file(
                          cover,
                          fit: BoxFit.cover,
                        )),
              Positioned(
                right: 10,
                bottom: 10,
                child: ElevatedButton(
                  onPressed: getImageCover,
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.images),
                      marginSpace(0, 5),
                      Text("เลือกรูปภาพ")
                    ],
                  ),
                ),
              )
            ]),
            Form(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "ข้อมูล โฮสต์",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "ชื่อ",
                            prefixIcon: Icon(Icons.create),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          setState(() {
                            hostName = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              value: selected_type,
                              underline: Container(
                                width: 0,
                              ),
                              hint: Text("เลือกประเภท"),
                              isExpanded: true,
                              onChanged: (newValue) {
                                setState(() {
                                  selected_type = newValue;
                                });
                              },
                              items: type.map((e) {
                                return DropdownMenuItem<String>(
                                    value: e, child: Text(e));
                              }).toList(),
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: "ที่อยู่",
                            prefixIcon: Icon(Icons.create),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: "อำเภอ",
                            prefixIcon: Icon(Icons.create),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: "จังหวัด",
                            prefixIcon: Icon(Icons.create),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          setState(() {
                            province = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        maxLines: 6,
                        maxLength: 360,
                        decoration: InputDecoration(
                            labelText: "รายละเอียด",
                            prefixIcon: Icon(Icons.create),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "ข้อมูลติดต่อ",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "อีเมล",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "เบอร์โทรติดต่อ",
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "เงื่อนไข",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        maxLines: 6,
                        decoration: InputDecoration(
                            labelText: "เงื่อนไข",
                            prefixIcon: Icon(Icons.create),
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          setState(() {
                            conditions = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19),
              child: Row(
                children: [
                  Text(
                    "รายการ",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return formInput(index);
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        data.add({
                          "title": null,
                          "price": null,
                          "unit": null,
                          "image_path": null
                        });

                        dataPreview.add({
                          "image_preview": null,
                        });
                      });
                    })
              ],
            ),
            marginSpace(20, 0)
          ],
        ),
      ),
    );
  }

  Widget formInput(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                getImage(index);
              },
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: dataPreview[index]["image_preview"] == null
                    ? Container(
                        color: Colors.grey,
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.images,
                            size: 40,
                          ),
                        ),
                      )
                    : Image.file(
                        dataPreview[index]["image_preview"],
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "ชื่อ",
                  prefixIcon: Icon(Icons.restaurant_menu),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    data[index]["title"] = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "ราคา",
                  prefixIcon: Icon(Icons.attach_money_sharp),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    data[index]["price"] = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "หน่วย",
                  prefixIcon: Icon(Icons.attach_money_sharp),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    data[index]["unit"] = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
