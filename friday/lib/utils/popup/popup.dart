import 'package:flutter/material.dart';

class PopUp extends StatefulWidget {
  final String message;
  const PopUp({Key key, this.message}) : super(key: key);
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  @override
  Widget build(BuildContext context) {
    print(widget.message);
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.30),
        body: Center(
          child: SizedBox(
            width: 300,
            height: 150,
            child: Card(
              child: Column(
                children: [
                  Expanded(child: Center(child: Text(widget.message))),
                  Divider(
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "Yes",
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
