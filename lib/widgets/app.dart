import 'package:flutter/material.dart';

import '../constants/constants.dart';

//app bar
PreferredSizeWidget? createAppbar(BuildContext context,
    {String? title, Color? color, Widget? leading}) {
  return AppBar(
    backgroundColor: color ?? primaryColor,
    elevation: 0,
    centerTitle: true,
    leading: leading ?? IconButton(
      color: color == null ? Colors.white : textColor,
      icon: const Icon(Icons.arrow_back_ios, size: 20.0),
      onPressed: () async => Navigator.of(context).pop(),
    ),
    title: Text(
      title ?? '',
      style: TextStyle(color: color == null ? Colors.white : textColor),
    ),
  );
}


BorderRadius borderRadius(
    double topLeft, double topRight, double bottomRight, double bottomLeft) {
  return BorderRadius.only(
    topLeft: Radius.circular(topLeft),
    topRight: Radius.circular(topRight),
    bottomRight: Radius.circular(bottomRight),
    bottomLeft: Radius.circular(bottomLeft),
  );
}