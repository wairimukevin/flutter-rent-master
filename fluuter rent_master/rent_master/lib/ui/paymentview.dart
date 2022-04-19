import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_master/data.dart';
import 'package:rent_master/ui/page_payment.dart';
import 'package:rent_master/ui/page_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rent_master/utils/Constants.dart';
import 'package:rent_master/utils/responsive_screen.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import '../LocalBindings.dart';

class paymentview extends StatefulWidget {
  @override
  _paymentviewState createState() => _paymentviewState();

}

class _paymentviewState extends State<paymentview> {
  bool _enabled = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Screen size;
  var fname;
  var sname;
  var userReference;
  SearchBar searchBar;
  bool dataflag= false;
  var datareview;
  bool userflag= false;
  var userreview;
  @override
  void initState(){
     ownerDetail();
  }

  void ownerDetail() async {
    userReference= await LocalStorage.sharedInstance.loadUserRef(Constants.userRef);
    print("user ref"+userReference);
    FirebaseFirestore.instance.collection("User").doc(userReference).get().then((DocumentSnapshot ds){
      print(ds);
      print('Loged in with '+ds.data()['firstName']);
      if(ds.data().containsKey('firstName')){
          setState(() {
            fname=ds.data()['firstName'];
            print('fname'+fname);
          });
        }
      if(ds.data().containsKey('lastName')){
          setState(() {
            sname=ds.data()['lastName'];
            print('fname'+sname);
          });
        }
    });
  }
  
  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  }
  
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Search tenant'),
        backgroundColor: Colors.blue[700],
        actions: [searchBar.getSearchAction(context)]);
  }
  
  _paymentviewState() {
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
           stream: FirebaseFirestore.instance.collection('Payment').where("ownerfname",isEqualTo:fname)
           .where('ownersname',isEqualTo:sname).snapshots(),
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
      margin: new EdgeInsets.only(bottom: size.getWidthPx(10)),
      child: new Card(
        elevation: 4,
        borderOnForeground: true,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: (){
              //Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfilePage('/User/'+docsSnap.id,true)));
              //Fluttertoast.showToast(msg: "Card Tapped ${docsSnap.data()['firstName']} ${docsSnap.data()['lastName']}" );
            },
            child: Container(
              width: size.wp(100),
              height: size.hp(50),
              child: Row(
                children: <Widget>[
                  Container(
                    width: size.wp(130)-size.hp(20),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.getWidthPx(12),horizontal: size.getWidthPx(10)),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'tenant:${docsSnap.data()['tenantName']}',
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
                              docsSnap.data().containsKey("propertyAddress") ?
                              Text(
                                "rentaladdress:${docsSnap.data()['propertyAddress']}",
                                style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16)),
                              ) : Text("kenya",style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16))),
                            ],
                          ),  
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Row(
                            children: <Widget>[
                              docsSnap.data().containsKey("ownerfname") ?
                              Text(
                                "landlord:${docsSnap.data()['ownerfname']}""${docsSnap.data()['ownersname']},",
                                style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16)),
                              ) : Text("landlord",style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16))),
                            ],
                          ),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Row(
                            children: <Widget>[
                              docsSnap.data().containsKey("mode") ?
                              Text(
                                "method:${docsSnap.data()['mode']}",
                                style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16)),
                              ) : Text("kenya",style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16))),
                            ],
                          ),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.dollarSign,
                                size: size.getWidthPx(16),
                                color: Colors.grey,
                              ),
                              docsSnap.data().containsKey("amount") ?
                              Text(
                                "amount:${docsSnap.data()['amount']}",
                                style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16)),
                              ) : Text("amount",style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16))),
                            ],
                          ),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Row(
                            children: <Widget>[
                              docsSnap.data().containsKey("lastDate") ?
                              Text(
                                "rental due date${docsSnap.data()['lastDate']}",
                                style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16)),
                              ) : Text("due date",style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16))),
                            ],
                          ),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Row(
                            children: <Widget>[
                              docsSnap.data().containsKey("startDate") ?
                              Text(
                                "rented date:${docsSnap.data()['startDate']}",
                                style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16)),
                              ) : Text("start date",style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16))),
                            ],
                          ),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Row(
                            children: <Widget>[
                              docsSnap.data().containsKey("dateCreated") ?
                              Text(
                                "paid on:${docsSnap.data()['dateCreated']}",
                                style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16)),
                              ) : Text("paid on",style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16))),
                            ],
                          ),
                          SizedBox(
                            height: size.getWidthPx(10),
                          ),
                          Padding(
                            padding: new EdgeInsets.symmetric(horizontal: size.getWidthPx(100)),
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
                                      color: Colors.greenAccent.shade700,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      tooltip: "Call",
                                      icon: Icon(
                                        FontAwesomeIcons.phoneAlt,
                                        size: size.getWidthPx(17),
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        var url = "tel:"+docsSnap.data()['tenantContact'].toString();
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Can't Lauch Phone",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: size.getWidthPx(15)
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.getWidthPx(12)),
                                Container(
                                  width: size.getWidthPx(40),
                                  height: size.getWidthPx(40),
                                  decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(size.getWidthPx(20)),
                                      border: new Border.all(
                                        width: size.getWidthPx(1),
                                        color: Colors.transparent
                                      ),
                                      color: Colors.redAccent,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      tooltip: "Chat",
                                      icon: Icon(
                                        FontAwesomeIcons.solidComment,
                                        size: size.getWidthPx(17),
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                      //   Fluttertoast.showToast(
                                      //     msg: "Start Chatting with ${docsSnap['firstName']}",
                                      //     toastLength: Toast.LENGTH_SHORT,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIos: 1,
                                      //     backgroundColor: Colors.black,
                                      //     textColor: Colors.white,
                                      //     fontSize: size.getWidthPx(15)
                                      //   );
                                      var url = "sms:"+docsSnap.data()['tenantContact'].toString();
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Can't Lauch Phone",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: size.getWidthPx(15)
                                          );
                                        }
                                      }
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