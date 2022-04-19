import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rent_master/Admin/Sign/LoginPage.dart';
import 'package:rent_master/Client/Sign/LoginPage.dart';
import 'package:rent_master/widgets/auth_design.dart';
import 'package:rent_master/utils/utils.dart';
import 'package:rent_master/LocalBindings.dart';
class IntialPage extends StatefulWidget {
  Screen size;
  @override
  _IntialPageState createState() => _IntialPageState();
}

class _IntialPageState extends State<IntialPage> {
  Screen size;
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    FlutterStatusbarcolor.setStatusBarColor(Colors.blue[700].withOpacity(1));
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[

        ],
      ),
      body: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: size.hp(7)),
                        child: Text(
                            'manage rental houses',
                            style: new TextStyle(
                              fontSize: size.getWidthPx(20),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Color(0x991976d2),
                            )
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: size.hp(2)),
                      child: Text(
                        'Affordable rental house',
                        style: new TextStyle(
                          fontSize: size.getWidthPx(20),
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Color(0x991976d2),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.hp(5),
                    ),
                    Image.asset(
                      'assets/landing_page.png',
                      width: size.wp(100),
                    ),
                    SizedBox(
                      height: size.hp(5),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.getWidthPx(30)),
                      child: RaisedButton(
                        child: Text('Landlord login'),
                        color: Colors.blue[700],
                        textColor: Colors.white,
                        elevation: 5,
                        padding: EdgeInsets.symmetric(vertical: size.getWidthPx(10), horizontal: size.getWidthPx(24)),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50),
                        ),
                        onPressed: (){
                          LocalStorage.sharedInstance.writeValue(key:Constants.isOnBoard,value: "1");
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LLoginPage()));
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0,size.getWidthPx(5),0,size.hp(6.5)),
                      child: RaisedButton(
                        child: Text('Tenant login'),
                        color: Colors.blue[700],
                        textColor: Colors.white,
                        elevation: 5,
                        padding: EdgeInsets.symmetric(vertical: size.getWidthPx(8), horizontal: size.getWidthPx(70)),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50),
                        ),
                        onPressed: (){
                          LocalStorage.sharedInstance.writeValue(key:Constants.isOnBoard,value: "1");
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CLoginPage()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}
