import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String TRENDING_URL =
    'https://api.giphy.com/v1/gifs/trending?api_key=FCZuRvAdCxeg0KQFIvsGTNJkwErmOEQS&limit=19&rating=R';
String SEARCH_URL =
    'https://api.giphy.com/v1/gifs/search?api_key=FCZuRvAdCxeg0KQFIvsGTNJkwErmOEQS&limit=19&rating=R&lang=en';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search == '') {
      response = await http.get(TRENDING_URL);
    } else {
      response = await http.get("$SEARCH_URL&q=$_search&offset=$_offset");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot.data['data']),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data['data'].length){
            return GestureDetector(
              child: Image.network(
                snapshot.data['data'][index]['images']['fixed_height']['url'],
                height: 300.0,
                fit: BoxFit.cover,
              ),
            );
          } else {
            return GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70.0,),
                  Text('Carregar mais...', style: TextStyle(color: Colors.white, fontSize: 22.0),)
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              },
            );
          }

        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
              decoration: InputDecoration(
                  labelText: 'Pesquise Aqui!',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  case ConnectionState.active:
                    // TODO: Handle this case.
                    break;
                  case ConnectionState.done:
                    // TODO: Handle this case.
                    break;
                }
                if (snapshot.hasError) {
                  Container();
                } else {
                  return _createGifTable(context, snapshot);
                }
                return Text('xx');
              },
            ),
          )
        ],
      ),
    );
  }
}
