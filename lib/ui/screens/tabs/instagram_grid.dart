import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class InstagramGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> _photos = <String>[];

    Future<List<String>> _getPhotos() async {
      var url =
          "https://api.unsplash.com/photos/?client_id=acd95b10c12e3a4e1197b733f3868177078c5ab17b57d66a4d4e2e3436067f77";
      var response = await http.get(url);
      var responseJson = jsonDecode(response.body);

      return (responseJson as List).map((item) {
        print(item['urls']['small']);
        String _newPhoto = item['urls']['small'];
        _photos.add(_newPhoto);
        return item['urls']['small'];
      }).toList();
    }

    return FutureBuilder<Object>(
        future: _getPhotos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                children:
                  List.generate(
                      _photos.length, (int) =>Image.network(
                        _photos[int],
                        fit: BoxFit.cover,
                  ),),
            );
          }
        });
  }
}

