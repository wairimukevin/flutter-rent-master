import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:rent_master/severmodel//views/result.dart';



class LoadingScreen extends StatefulWidget {

  LoadingScreen({@required this.area, @required this.bhk, @required this.bathroom, @required this.location});

  final int area;
  final int bhk;
  final int bathroom;
  final String location;


  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("going to call getestimate");
    setState(() {
      final int area = 2000;
      final int bhk =3;
      final int bathroom = 3;
      final String location = '';

      getEstimate(area, bhk, bathroom, location);
    });

  }
  
  Future getEstimate(int area,int bhk, int bathroom, String location)async{
    Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8'
    };

    print("1************");
    try {
      print("try++++++++++");
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:5000/predict_home_price?location=$location&total_sqft=$area&bhk=$bhk&bath=$bathroom'),headers: headers);
      print("api parsed sucessfully");
      if (response.statusCode == 200) {
        print("2***********");
        String data = response.body;
        var decodedata = jsonDecode(data);
        print(decodedata['estimated_price']);
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            ResultsPage(bmiResult: decodedata['estimated_price'])),);
        return decodedata['estimated_price'];
      } else {
        print("3++++++++++++++++++");
        print(response.statusCode);
      }
    }
    catch(e){
      print("in catch ");
      print(e);
    }

  }






  @override
  Widget build(BuildContext context) {

    int area_ = widget.area;
    int bhk_ = widget.bhk;
    int bathroom_ = widget.bathroom;
    String location_ = widget.location;



    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.blue,
          size: 100.0,
        ),
      ),
    );
  }
}