import 'dart:convert';

import 'collection.dart';

class MyTimeline {
  String? groupDate;
  List<dynamic>? collections;
  // khai bao list dynamic. khi bao len server tra ve repos danh sach cac ngya da chekc in 

  MyTimeline({this.groupDate, this.collections});
// list dynamic
  factory MyTimeline.fromJson(Map<String, dynamic> jsonMap) => MyTimeline(
        groupDate: jsonMap['groupDate'].toString(),
        collections: jsonMap['collections'],
      );
}
