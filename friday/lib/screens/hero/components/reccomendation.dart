import 'package:flutter/material.dart';

class Reccomendation extends StatefulWidget {
  @override
  _ReccomendationState createState() => _ReccomendationState();
}

class _ReccomendationState extends State<Reccomendation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0.5, color: Colors.grey[350]),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2.5),
                                ),
                                Flexible(
                                  child: Text("username"),
                                ),
                              ],
                            ),
                            Divider(),
                            Text(
                              "ชื่อทริป",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "ทริป 3 วัน 2 คืน",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "เงินที่ใช้",
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
