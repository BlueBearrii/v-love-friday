import 'package:flutter/material.dart';
import 'package:friday/utils/loading/loading.dart';

class CallLoading {
  static onLoading(context) {
    Navigator.push(
        context,
        PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) => Loading()));
  }
}
