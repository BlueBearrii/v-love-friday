import 'package:flutter/material.dart';

class CreateTripBtn extends StatefulWidget {
  @override
  _CreateTripBtnState createState() => _CreateTripBtnState();
}

class _CreateTripBtnState extends State<CreateTripBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Divider(
                thickness: 1,
                height: 1,
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  height: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {}, child: Text("สร้างทริปเลย !!")),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 1,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
