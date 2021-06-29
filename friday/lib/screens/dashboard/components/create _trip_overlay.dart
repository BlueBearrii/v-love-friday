import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/auth.dart';
import 'package:friday/apis/trips.dart';
import 'package:friday/utils/thia_province.dart';

class CreateTripOverlay extends StatefulWidget {
  const CreateTripOverlay({Key key}) : super(key: key);

  @override
  _CreateTripOverlayState createState() => _CreateTripOverlayState();
}

class _CreateTripOverlayState extends State<CreateTripOverlay> {
  User user = FirebaseAuth.instance.currentUser;
  Map _user;
  int budget = 0;
  int wallet;
  String tripName;
  String daySelected = daysTrip[0];
  String destinationSelected = destination[0];
  bool loadingState = false;

  static List<String> daysTrip = [
    '1 วัน',
    '2 วัน',
    '3 วัน',
    '4 วัน',
    '5 วัน',
    '6 วัน',
    '7 วัน',
    '8 วัน',
    '9 วัน',
    '10 วัน',
    '11 วัน',
    '12 วัน',
    '13 วัน',
    '14 วัน',
    'มากกว่า 14 วัน',
    'มากกว่า 30 วัน'
  ];

  static List<String> destination = ThaiProvince.all_province;

  final _formKey = GlobalKey<FormState>();

  Future<Map> fetchUserInfo() async {
    await AuthRoute.userInfo(user.uid).then((value) {
      print(value.data["message"]["wallet"]);
      setState(() {
        _user = value.data["message"];
        wallet = value.data["message"]["wallet"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor, //change your color here
        ),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: 600,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.all(25),
                      child: Center(
                        child: Text(
                          "กรอกรายละเอียดทริป",
                          style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]),
                  Expanded(
                      child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              setState(() {
                                tripName = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณาตั้งชื่อทริปของคุณ';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "ชื่อ ทริป",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (_formKey.currentState.validate()) {
                                if (value.isEmpty == false) {
                                  setState(
                                    () {
                                      budget = int.parse(value);
                                    },
                                  );
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณาใส่งบประมาณที่ต้องการ';
                              }

                              if (int.parse(value) > _user["wallet"]) {
                                return "ยอดเงินในกระเป๋าของคุณไม่พอ กรุณาเติมเงิน";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "งบประมาณ",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: DropdownButton(
                                underline: Container(
                                  width: 0,
                                ),
                                value: daySelected,
                                isExpanded: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    daySelected = newValue;
                                  });
                                },
                                items: daysTrip.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: DropdownButton(
                                underline: Container(
                                  width: 0,
                                ),
                                value: destinationSelected,
                                isExpanded: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    destinationSelected = newValue;
                                  });
                                },
                                items: destination
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).accentColor)),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loadingState = !loadingState;
                                    });
                                    TripRoute.createTrip({
                                      "uid": user.uid,
                                      "tripName": tripName,
                                      "budget": budget,
                                      "days": daySelected,
                                      "destination": destinationSelected,
                                      "user_image_path":
                                          _user["user_image_path"]
                                    }).then((value) {
                                      if (value == "trip/created") {
                                        Navigator.pop(context, true);
                                      }

                                      setState(() {
                                        loadingState = !loadingState;
                                      });
                                    });
                                  }
                                },
                                child: loadingState
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        "สร้างทริปแล้ว ไปจองสถานที่กันเลย!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                              ),
                            )),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
