import 'package:flutter/material.dart';

class UserBar extends StatefulWidget {
  @override
  _UserBarState createState() => _UserBarState();
}

class _UserBarState extends State<UserBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Username"),
                Text("id"),
              ],
            ),
            Expanded(child: Container()),
            Text("Balance"),
          ],
        ),
      ),
    );
  }
}
