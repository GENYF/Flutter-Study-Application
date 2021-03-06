import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:airvisual_normal/src/models/models.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NearestCity(),
    );
  }
}

class NearestCity extends StatefulWidget {
  @override
  _NearestCityState createState() => _NearestCityState();
}

class _NearestCityState extends State<NearestCity> {
  AirResult _result;

  Future<AirResult> fetchData() async {
    var url = 'https://api.airvisual.com/v2/nearest_city?key=61de6f57-da2b-47e1-86fc-14bd1e08354f';
    var response = await http.get(url);
    var jsonResponse = convert.jsonDecode(response.body);
    return _result = AirResult.fromJson(jsonResponse);
  }

  @override
  void initState() {
    super.initState();

    fetchData().then((airResult) {
      setState(() {
        _result = airResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: _result == null
              ? CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '현재 위치 미세먼지',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: getColor(_result),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('얼굴사진'),
                          _result == null
                              ? Text('측정중')
                              : Text(
                            '${_result.data.current.pollution.aqius}',
                            style: TextStyle(fontSize: 40),
                          ),
                          Text(
                            '보통',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.network(
                                'https://airvisual.com/images/${_result.data.current.weather.ic}.png',
                                width: 32,
                                height: 32,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                '${_result.data.current.weather.tp}°',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          Text(
                            '습도 ${_result.data.current.weather.hu}%',
                          ),
                          Text(
                            '풍속 ${_result.data.current.weather.ws}m/s',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return Colors.greenAccent;
    } else if (result.data.current.pollution.aqius <= 100) {
      return Colors.yellow;
    } else if (result.data.current.pollution.aqius <= 150) {
      return Colors.orange;
    } else {
      return Colors.redAccent;
    }
  }
}
