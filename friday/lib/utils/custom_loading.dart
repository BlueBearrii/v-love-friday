import 'package:flutter/material.dart';
import 'package:friday/utils/loading_nomal.dart';

class CustomLoading {
  static Widget loadingNormal(context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingNomal(),
      ),
    );
  }

  static Widget dynamicPopup(context, Widget _widget) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => _widget,
      ),
    );
  }
}
