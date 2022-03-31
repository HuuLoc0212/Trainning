class Collection {
  String? activityTypes;
  String? activityDescription;

  Collection({this.activityTypes, this.activityDescription});

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        activityTypes: json['activityTypes'].toString(),
        activityDescription: json['activityDescription'].toString(),
      );
  
}
