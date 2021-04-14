import 'package:flutter/material.dart';
import 'package:friday/common/custom_size.dart';

class BookingSelect extends StatefulWidget {
  final Map data;

  const BookingSelect({Key key, this.data}) : super(key: key);
  @override
  _BookingSelectState createState() => _BookingSelectState();
}

class _BookingSelectState extends State<BookingSelect> {
  final customSize = new CustomSize();
  final List arr = [];
  final List _activityAndPlace = [];

  @override
  Widget build(BuildContext context) {
    print("INDEX : ${widget.data}");
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: customSize.getHeight(25, context),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.data["image"],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.data["title"],
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Booking id ${widget.data["booking_id"]}",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Budget : 1000",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.grey,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("${widget.data["day"][index]}"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Accomodation",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      arr.length == 0
                          ? Container()
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: arr.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: Text("TEDT"),
                                );
                              },
                            ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            arr.add("New");
                          });
                        },
                        child: Text("Add"),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Activities and place",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      _activityAndPlace.length == 0
                          ? Container()
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _activityAndPlace.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: Text("TEDT"),
                                );
                              },
                            ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _activityAndPlace.add("New");
                          });
                        },
                        child: Text("Add"),
                      ),
                    ],
                  ),
                );
              },
              childCount: widget.data["day"].length,
            ),
          ),
        ],
      ),
    );
  }
}
