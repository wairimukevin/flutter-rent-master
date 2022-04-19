import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_master/data.dart';
import 'package:rent_master/ui/page_payment.dart';
import 'package:rent_master/ui/page_payment2.dart';
import 'package:rent_master/ui/page_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rent_master/utils/responsive_screen.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class paypesa extends StatefulWidget {
  @override
  _paypesaState createState() => _paypesaState();

}

class _paypesaState extends State<paypesa> {
  bool _enabled = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Screen size;
  SearchBar searchBar;
  bool dataflag= false;
  var datareview;
  bool userflag= false;
  var userreview;
  @override
  void initState(){
    super.initState();
    /*data().getUSERdata('mwas','kevo')
        .then((QuerySnapshot docs){
      if(docs.docs.isNotEmpty){
        userflag=true;
        userreview=docs.docs[0].data;
        print(userreview);
      }
    });
    data().gethousedata('24','available')
        .then((QuerySnapshot docs){
      if(docs.docs.isNotEmpty){
        dataflag=true;
        datareview=docs.docs[0].data;
      }
    });*/
  }
  
  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  }
  
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Search People'),
        backgroundColor: Colors.blue[700],
        actions: [searchBar.getSearchAction(context)]);
  }
  
  _paypesaState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onClosed: () {
          print("closed");
        });
  }


  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    FlutterStatusbarcolor.setStatusBarColor(Colors.blue[700]);
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      key: _scaffoldKey,
      appBar: searchBar.build(context),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('User').snapshots(),
          builder: (context, snapshot) {
          return (snapshot.connectionState == null || !snapshot.hasData )
          ? new Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue[700],
            ),
          )
          : Container(
            padding: new EdgeInsets.fromLTRB(size.getWidthPx(10),size.getWidthPx(10),size.getWidthPx(10),0),
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot docsSnap = snapshot.data.docs[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getUserCard(docsSnap, context),
              ],
            );
          },
        ),
      );
    }));
  }

  Widget getUserCard(DocumentSnapshot docsSnap,var context){
    size = Screen(MediaQuery.of(context).size);
    return Container(
      margin: new EdgeInsets.only(bottom: size.getWidthPx(20)),
      child: new Card(
        elevation: 4,
        borderOnForeground: true,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfilePage('/User/'+docsSnap.id,true)));
              Fluttertoast.showToast(msg: "Card Tapped ${docsSnap.data()['firstName']} ${docsSnap.data()['lastName']}" );
            },
            child: Container(
              width: size.wp(90),
              height: size.hp(20),
              child: Row(
                children: <Widget>[
                  Container(
                    width: size.hp(15),
                    color: Colors.grey,
                    child: docsSnap.data().containsKey("profileImage") ? Image.network(
                      '${docsSnap.data()['profileImage']}',
                    ) : Image.asset('assets/icons/avatar.png'),
                  ),
                  Container(
                    width: size.wp(90)-size.hp(15),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.getWidthPx(12),horizontal: size.getWidthPx(16)),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${docsSnap.data()['firstName']} ${docsSnap.data()['lastName']}',
                              style: TextStyle(
                                fontFamily: 'Ex02',
                                fontSize: size.getWidthPx(20),
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5)
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.mapMarkerAlt,
                                size: size.getWidthPx(16),
                                color: Colors.grey,
                              ),
                              docsSnap.data().containsKey("city") ?
                              Text(
                                "${docsSnap.data()['city']}, kenya",
                                style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16)),
                              ) : Text("kenya",style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16))),
                            ],
                          ),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Padding(
                            padding: new EdgeInsets.symmetric(horizontal: size.getWidthPx(15)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: size.getWidthPx(40),
                                  height: size.getWidthPx(40),
                                  decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(size.getWidthPx(20)),
                                      border: new Border.all(
                                        width: size.getWidthPx(1),
                                        color: Colors.transparent
                                      ),
                                      color: Colors.blueAccent,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      tooltip: "Pay Rent",
                                      icon: Icon(
                                        FontAwesomeIcons.wallet,
                                        size: size.getWidthPx(17),
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        Navigator.push(context, 
                                            MaterialPageRoute(builder: (_)=> PaymentPage2(docsSnap)));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}