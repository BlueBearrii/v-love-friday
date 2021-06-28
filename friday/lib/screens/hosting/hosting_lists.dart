import 'package:flutter/material.dart';
import 'package:friday/screens/hosting/components/create_host.dart';

class HostingLists extends StatefulWidget {
  const HostingLists({Key key}) : super(key: key);

  @override
  _HostingListsState createState() => _HostingListsState();
}

class _HostingListsState extends State<HostingLists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("จัดการ โฮสต์"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => CreateHost()));
              })
        ],
      ),
      body: Container(),
    );
  }
}
