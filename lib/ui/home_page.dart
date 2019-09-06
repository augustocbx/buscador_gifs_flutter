import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String TRENDING_URL =
    'https://api.giphy.com/v1/gifs/trending?api_key=FCZuRvAdCxeg0KQFIvsGTNJkwErmOEQS&limit=25&rating=R';
String SEARCH_URL =
    'https://api.giphy.com/v1/gifs/search?api_key=FCZuRvAdCxeg0KQFIvsGTNJkwErmOEQS&limit=20&rating=R&lang=en';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(TRENDING_URL);
    } else {
      response = await http.get("SEARCH_URL&q=$_search&offset=$_offset");
    }

    return json.decode(response.body);
  }


  @override
  void initState() {
    super.initState();
    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
