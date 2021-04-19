import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friday/common/custom_size.dart';
import 'package:friday/components/app/booking/booking_place.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class BookingSearch extends StatefulWidget {
  @override
  _BookingSearchState createState() => _BookingSearchState();
}

class _BookingSearchState extends State<BookingSearch> {
  final customSize = new CustomSize();
  var _listItems;

  Future _fetchLocation() async {
    final httpClient = http.Client();
    final Uri _authority =
        Uri.parse("https://test-create-api.herokuapp.com/api/hotel");
    http.Response response = await httpClient.get(_authority);
    final List parsedData = await jsonDecode(response.body.toString());

    print(parsedData);
    setState(() {
      _listItems = parsedData;
    });

    return response;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        toolbarHeight: customSize.getHeight(10, context),
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(width: 1),
              ),
            ),
          ),
        ),
      ),
      body: _listItems == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listItems.length,
              itemBuilder: (context, index) {
                print(_listItems.length);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingPlace(data: _listItems[index]),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Card(
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.network(
                                      _listItems[index]["image"],
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${_listItems[index]["name"]}"),
                                    Text(
                                        "Phone : ${_listItems[index]["phone"]}"),
                                    Text(
                                        "Address : ${_listItems[index]["address"]}"),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
