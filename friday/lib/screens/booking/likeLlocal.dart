import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friday/apis/host.dart';

class LikeLocal extends StatefulWidget {
  final String hostid;
  const LikeLocal({Key key, this.hostid}) : super(key: key);

  @override
  _LikeLocalState createState() => _LikeLocalState();
}

class _LikeLocalState extends State<LikeLocal> {
  User user = FirebaseAuth.instance.currentUser;

  Future<String> goLike() async {
    return await HostingRoute.liked(user.uid, widget.hostid);
  }

  Future<bool> gotLike() async {
    return await HostingRoute.gotLiked(user.uid, widget.hostid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gotLike(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  icon: FaIcon(
                    snapshot.data == true
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: snapshot.data == true
                        ? Theme.of(context).accentColor
                        : Colors.white,
                  ),
                  onPressed: () {
                    goLike().then((value) {
                      setState(() {});
                    });
                  })
            ],
          ));
        }
        return Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.heart,
                  color: Colors.white,
                ),
                onPressed: null)
          ],
        ));
      },
    );
  }
}
