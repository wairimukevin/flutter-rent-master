
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:rent_master/IntialPage.dart';
 
void main()async{
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MpesaFlutterPlugin.setConsumerKey('aFmTN4izXgZLN4HVbFFIRhmm7Glx3GZf');
  MpesaFlutterPlugin.setConsumerSecret('4iyWCYNsplNFLv4p');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Color(0xfff8f5f0));
    return MaterialApp(
      title: 'rentmaster',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntialPage(),
    );
  }
}