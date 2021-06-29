import 'package:flutter/material.dart';

class LoadingNomal extends StatefulWidget {
  const LoadingNomal({Key key}) : super(key: key);

  @override
  _LoadingNomalState createState() => _LoadingNomalState();
}

class _LoadingNomalState extends State<LoadingNomal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12.withOpacity(0.6),
        body: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: CircularProgressIndicator(
                strokeWidth: 10,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          ),
        ));
  }
}
