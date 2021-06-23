import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/utils/margin_space.dart';

class Cover extends StatelessWidget {
  final Map data;
  const Cover({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            data["coverUrl"],
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.width * 0.8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0x00000000),
                const Color(0x00000000),
                const Color(0x00000000),
                const Color(0xCC000000),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["tripName"],
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    marginSpace(2, 0),
                    Text(
                      "งบประมาณ : ${data["budget"].toString()} บาท",
                      style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    marginSpace(2, 0),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.mapMarkerAlt,
                          size: 16,
                          color: Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                        ),
                        Text(
                          data["destination"],
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                        marginSpace(0, 5),
                        FaIcon(
                          FontAwesomeIcons.calendar,
                          size: 16,
                          color: Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                        ),
                        Text(
                          data["days"],
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.heart,
                          color: Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.5),
                        ),
                        Text(
                          data["likes"].length.toString(),
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
