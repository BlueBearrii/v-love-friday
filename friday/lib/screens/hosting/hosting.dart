import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/screens/hosting/hosting_lists.dart';
import 'package:friday/utils/margin_space.dart';

class Hosting extends StatefulWidget {
  const Hosting({Key key}) : super(key: key);

  @override
  _HostingState createState() => _HostingState();
}

class _HostingState extends State<Hosting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "สร้างโฮสต์ของคุณ",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).accentColor, //change your color here
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
                Positioned(
                  top: 20,
                  right: 20,
                  child: FaIcon(
                    FontAwesomeIcons.cloud,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 60,
                  child: FaIcon(
                    FontAwesomeIcons.cloud,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: FaIcon(
                    FontAwesomeIcons.cloud,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 100,
                  child: FaIcon(
                    FontAwesomeIcons.cloud,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  bottom: -2,
                  left: 30,
                  child: FaIcon(
                    FontAwesomeIcons.solidBuilding,
                    size: 150,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 50,
                  child: FaIcon(
                    FontAwesomeIcons.warehouse,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: FaIcon(
                    FontAwesomeIcons.tree,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 120,
                  child: FaIcon(
                    FontAwesomeIcons.tree,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 10,
                  child: FaIcon(
                    FontAwesomeIcons.tree,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 30,
                  child: FaIcon(
                    FontAwesomeIcons.tree,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 140,
                  child: FaIcon(
                    FontAwesomeIcons.solidBuilding,
                    size: 90,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ]),
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  marginSpace(15, 0),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                    child: Text(
                      "สร้างโฮสต์ของตัวเอง",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "เริ่มต้นกิจการร่วมกับเราโดยการแชร์บริการของคุณให้อยู่บนแพลทฟอร์มของเรา สร้างประสบการณ์ที่ดีแก่ผู้ใช้งานและเพิ่มโอกาสในการทำธุรกิจของคุณให้มีแต่ความทรงจำที่ดีร่วมกัน",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  marginSpace(10, 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => HostingLists()));
                            },
                            child: Text("ขั้นตอนถัดไป")),
                      ],
                    ),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
