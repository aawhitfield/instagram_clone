import 'package:flutter/material.dart';

class InstaCard {
  String url;

  InstaCard({this.url});

  InstaCard.fromMap(Map<String, dynamic> data, String id)
      : this(
    url : data['url'],
  );
}