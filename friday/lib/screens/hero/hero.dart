import 'package:flutter/material.dart';
import 'package:friday/screens/hero/components/create_trip_btn.dart';
import 'package:friday/screens/hero/components/reccomendation.dart';
import 'package:friday/screens/hero/components/trip_carousel.dart';

class HeroScreen extends StatefulWidget {
  @override
  _HeroScreenState createState() => _HeroScreenState();
}

class _HeroScreenState extends State<HeroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      drawer: Drawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            //UserBar(),
            Stack(children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.blue,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TripCarousel(),
              ),
            ]),
            CreateTripBtn(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ทริปยอดนิยม",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "แนะนำทริปที่คุณอาจสนใจ จากเหล่าผู้สร้างทริปสุดเจ๋ง",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Reccomendation(),
          ],
        ),
      ),
    );
  }
}
