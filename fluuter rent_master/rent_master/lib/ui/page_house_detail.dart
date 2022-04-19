import 'package:rent_master/LocalBindings.dart';
import 'package:rent_master/data.dart';
import 'package:rent_master/services/upload_image.dart';
import 'package:rent_master/ui/page_payment2.dart';
import 'package:rent_master/ui/page_profile.dart';
import 'package:rent_master/ui/paympesa.dart';
import 'package:rent_master/ui/photo_list.dart';
import 'package:rent_master/utils/Constants.dart';
import 'package:rent_master/utils/responsive_screen.dart';
import 'package:rent_master/widgets/drawer.dart';
import 'package:rent_master/widgets/drawer_landloard.dart';
import 'package:rent_master/widgets/utils_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:rent_master/services/network_image.dart';
import 'package:intl/intl.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rent_master/ui/page_payment.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

final String headImageAssetPath = "";
final List<String> imgList = [];
var userReference;
String userRef;
String houseRef;
final Widget placeholder = Container(color: Colors.grey);
List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

class CarouselWithIndicator extends StatefulWidget {
  final DocumentSnapshot snapshot;
  @override
  _CarouselWithIndicatorState createState() =>
      _CarouselWithIndicatorState(snapshot);
  CarouselWithIndicator(this.snapshot);
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  final DocumentSnapshot snapshot;
  _CarouselWithIndicatorState(this.snapshot);

  bool dataflag= false;
   var datareview;
  bool userflag= false;
  var userreview;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Swiper(
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child:snapshot.data().containsKey('houseImages') ? 
            PNetworkImage(
              snapshot.data()['houseImages'][index],
              fit: BoxFit.cover,
            ): Image.asset('assets/icons/avatar.png'),
          );
        },
        itemCount: snapshot.data()['houseImages'].length,
       viewportFraction: 1,
       scale: 1,
       pagination: SwiperPagination(),
      ),
    );
  }
}

DocumentSnapshot ownerSnapshot;

class HouseDetail extends StatefulWidget {
  // Declare a field that holds the Todo.
  DocumentSnapshot snapshot;
  HouseDetail(this.snapshot);
  @override
  _HouseDetailState createState() => _HouseDetailState(snapshot);
}

class _HouseDetailState extends State<HouseDetail> {
DocumentSnapshot snapshot;   
  _HouseDetailState(this.snapshot);

  bool _isPressed = false,_fireStatus=false;
Image image1;
String docRef;
var fname;
var sname;
var email;
var mobileNo;
DocumentSnapshot docsSnap;
  @override
  void initState() {
    super.initState();
    ownerDetail();
  }

  void ownerDetail() async {
    print('OwnerDetail inme');
     userReference= await LocalStorage.sharedInstance.loadUserRef(Constants.userRef);
    //await FirebaseFirestore.instance.collection("House")
        //.doc(['ownerDetail'].toString())
        //.doc(snapshot.data()['ownerDetail'].toString())
      await FirebaseFirestore.instance.collection("User").doc(userReference)
        .get()
        .then((DocumentSnapshot ds) {
            print('Doc Found Owner');
            print(ds);
            setState(() {   
              ownerSnapshot = ds;
            });
        });
    print('Outside 108');
    userReference= await LocalStorage.sharedInstance.loadUserRef(Constants.userRef);
    print("user ref"+userReference);
    FirebaseFirestore.instance.collection("User").doc(userReference).get().then((DocumentSnapshot ds){
      print(ds);
      print('Loged in with '+ds.data()['firstName']);
      if(ds.data().containsKey('FavouriteHouse')){
        if(ds.data()['FavouriteHouse'].contains('/House/'+snapshot.id)){
          setState(() {
            _fireStatus=true;
            print('TRUE');
          });
        }
      }
    });
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
      if(ds.data().containsKey('mobileNo')){
          setState(() {
            mobileNo=ds.data()['mobileNo'];
            print('phone'+mobileNo);
          });
        }
      if(ds.data().containsKey('email')){
          setState(() {
            email=ds.data()['email'];
            print('email'+email);
          });
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    FlutterStatusbarcolor.setStatusBarColor(Colors.blue[700].withOpacity(0.9));
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
          child: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            title: Column(children: [
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ''+snapshot['Address']['city'],
                  //"Shangrila Luxury Apartment",
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 12.0,
                      ),
                      Text(
                        ''+snapshot['Address']['locality'],
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
            backgroundColor: Colors.blue[700],
            elevation: 0,
          ),
        ),
        body:
        Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperOne(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[700].withOpacity(0.3),
                ),
                height: 410,
              ),
            ),
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[700].withOpacity(0.6),
                ),
                height: 410,
              ),
            ),
            ClipPath(
              clipper: WaveClipperOne(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[700].withOpacity(1),
                ),
                height: 400,
              ),
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        CarouselWithIndicator(snapshot),
                      ],
                    ),
                    getCards(),
                  ],
                ),
              ),
            ),
          ],
        ),
        drawer: docsSnap != null ? drawer_tenant(image1,context,docsSnap.data()['profileImage'],docsSnap.data()['firstName']+" "+docsSnap.data()['lastName'],docsSnap.data()['email'],"true",'/User/'+docRef)
          :drawer_tenant(image1,context,'assets/icons/avatar.png','Login / Register ','','false',null),
      ),
    );
  }

  Widget getFirstCard() {
  return ownerSnapshot!=null ? Center(
    child: Card(
      elevation: 6,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(0.0),
          child: Container(
            padding: new EdgeInsets.symmetric(horizontal: 40,vertical: 20),
            child: Center(
              child: Padding(
                            padding: new EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(20),
                                      border: new Border.all(
                                        width: 1,
                                        color: Colors.transparent
                                      ),
                                      color: Colors.greenAccent.shade700,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      tooltip: "Call",
                                      icon: Icon(
                                        FontAwesomeIcons.phoneAlt,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        var url = "tel:"+snapshot.data()['mobileNo'].toString();
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
                                            fontSize: 15
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(25),
                                      border: new Border.all(
                                        width: 1,
                                        color: Colors.transparent
                                      ),
                                      color: Colors.redAccent,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      tooltip: "Chat",
                                      icon: Icon(
                                        FontAwesomeIcons.solidComment,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                      var url = "sms:"+snapshot.data()['mobileNo'].toString();
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
                                            fontSize: 15
                                          );
                                        }
                                      }
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(20),
                                      border: new Border.all(
                                        width: 1,
                                        color: Colors.transparent
                                      ),
                                      color: Colors.blueAccent,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      tooltip: "Pay Rent",
                                      icon: Icon(
                                        FontAwesomeIcons.wallet,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        Navigator.push(context, 
                                            MaterialPageRoute(builder: (_)=> PaymentPage2(ownerSnapshot)));
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                width: 50.0,
                                height: 50.0,
                                color: Colors.white,
                                child: new RawMaterialButton(
                                  elevation: 20.0,
                                  child: new Icon(
                                    Icons.book_online_sharp,
                                    size: 35,
                                    color: (_fireStatus)
                                        ? Colors.blue[700]
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _fireStatus = !_fireStatus;
                                    });
                                    if(snapshot.data()['status']=="availabe"){
                                    if(_fireStatus){
                                                FirebaseFirestore.instance.runTransaction((transaction) async{
                                                var docsSnap = await transaction.get(snapshot.reference);
                                                await transaction.update(docsSnap.reference,{
                                                  'status':"booked",
                                                });
                                                });
                                                FirebaseFirestore.instance.runTransaction((transaction) async{
                                                var docsSnap = await transaction.get(snapshot.reference);
                                                await transaction.update(docsSnap.reference,{
                                                  'bookingdate':DateTime.now(),
                                                });
                                                });
                                                FirebaseFirestore.instance.doc('/User/'+userReference).update({
                                                  'bookedHouse':FieldValue.arrayUnion(['/House/'+snapshot.id])
                                                });
                                                FirebaseFirestore.instance.runTransaction((transaction) async{
                                                var docsSnap = await transaction.get(snapshot.reference);
                                                await transaction.update(docsSnap.reference,{
                                                  'tenant':'/User/'+userReference,
                                                  'tenantf':fname+sname,
                                                });
                                                });
                                                FirebaseFirestore.instance.runTransaction((transaction) async{
                                                var docsSnap = await transaction.get(snapshot.reference);
                                                await transaction.update(docsSnap.reference,{
                                                  'tenante':email,
                                                });
                                                });
                                                FirebaseFirestore.instance.runTransaction((transaction) async{
                                                var docsSnap = await transaction.get(snapshot.reference);
                                                await transaction.update(docsSnap.reference,{
                                                  'tenantn':mobileNo,
                                                });
                                                });
                                                FirebaseFirestore.instance.doc('/User/'+userReference).update({
                                                  'booking date':DateTime.now(),
                                                });

                                              } else{
                                                FirebaseFirestore.instance.runTransaction((transaction) async{
                                                  var docsSnap = await transaction.get(snapshot.reference);
                                                  await transaction.update(docsSnap.reference,{
                                                    'status':"available",
                                                    'tenantf':"none",
                                                  });
                                                });
                                                FirebaseFirestore.instance.runTransaction((transaction) async{
                                                  var docsSnap = await transaction.get(snapshot.reference);
                                                  await transaction.update(docsSnap.reference,{
                                                    'tenante':"none",
                                                    'tenantn':"none",
                                                    'bookingdate':"none",
                                                  });
                                                });
                                                FirebaseFirestore.instance.doc('/User/'+userReference).update({
                                                  'bookedHouse':FieldValue.arrayRemove(['/House/'+snapshot.id])
                                                });
                                              }
                                              
                                    Fluttertoast.showToast(
                                        msg: (_fireStatus)
                                            ? "house booking succesfull"
                                            : "house booking cancled",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0);}
                                        else{
                                          Fluttertoast.showToast(
                                        msg: "house is already booked,cann't be booked",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                        }
                                  },
                                ),
                              ),
                              ],
                            ),
                          ),
            )
          ),
        ),
      ),
    ),
  ) : Center(child: Card(child: CircularProgressIndicator(),),);
}

Widget getSecondCard() {
  return Center(
    child: Card(
      elevation: 6,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(0.0),
          child: Container(
            child: Row(
              children: <Widget>[
                ResponsiveContainer(
                  widthPercent: 67,
                  heightPercent: 10,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: new EdgeInsets.fromLTRB(15, 16, 5, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${snapshot['Overview']['room']} BHK in ${snapshot['Address']['city']}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ),
                        Container(
                          padding: new EdgeInsets.fromLTRB(15, 0, 5, 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'At ${snapshot['Address']['society']}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveContainer(
                  widthPercent: 26,
                  heightPercent: 9,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: new EdgeInsets.fromLTRB(10, 16, 10, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              snapshot.data()['builtUpArea'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.6)),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          padding: new EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sq. ft.',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
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
    ),
  );
}

Widget getThirdCard() {
  return Center(
    child: Card(
      elevation: 6,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(0.0),
          child: Container(
            child: Row(
              children: <Widget>[
                ResponsiveContainer(
                  widthPercent: 47,
                  heightPercent: 12,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: new EdgeInsets.fromLTRB(15, 16, 5, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.dollarSign,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                Text(
                                  ''+snapshot.data()['depositAmount'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: new EdgeInsets.fromLTRB(15, 0, 5, 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Security Deposit',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveContainer(
                  widthPercent: 47,
                  heightPercent: 9,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          //                   <--- left side
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: new EdgeInsets.fromLTRB(10, 16, 10, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.dollarSign,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                Text(
                                  ''+snapshot.data()['monthlyRent'].toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black.withOpacity(0.6)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Rent per month',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
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
    ),
  );
}

Widget getFourthCard() {
  return Center(
    child: Card(
      elevation: 6,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(0.0),
          child: Container(
            child: Row(
              children: <Widget>[
                ResponsiveContainer(
                  widthPercent: 47,
                  heightPercent: 12,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: new EdgeInsets.fromLTRB(15, 16, 5, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ''+snapshot['Overview']['furnishingStatus'],//'Fully Furnished',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ),
                        Container(
                          padding: new EdgeInsets.fromLTRB(15, 0, 5, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Furnishing Status',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveContainer(
                  widthPercent: 47,
                  heightPercent: 9,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          //                   <--- left side
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: new EdgeInsets.fromLTRB(10, 16, 10, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ''+snapshot['Overview']['preferedType'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.6)),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          padding: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Prefered Tanents',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
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
    ),
  );
}

Widget getFifthCard() {
  return Center(
    child: Card(
      elevation: 6,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(0.0),
          child: Container(
              padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            //                   <--- left side
                            color: Colors.blue[500].withOpacity(0.6),
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'OVERVIEW',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  ResponsiveContainer(
                                    widthPercent: 42,
                                    heightPercent: 6,
                                    child: Container(
                                      padding: new EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          left: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          right: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.bed,color: Colors.black.withOpacity(0.6)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            snapshot['Overview']['room']+' Bedroom',
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ResponsiveContainer(
                                      widthPercent: 42,
                                      heightPercent: 6,
                                      child: Container(
                                        padding: new EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                            left: BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                            right: BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.solidHeart,color: Colors.black.withOpacity(0.6)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            snapshot.data()['favourite'].toString()+' Likes',
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ResponsiveContainer(
                                      widthPercent: 42,
                                      heightPercent: 6,
                                      child: Container(
                                        padding: new EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                            left: BorderSide(
                                              color: Colors.grey,
                                              width: 1.5,
                                            ),
                                            right: BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                            bottom: BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.home,color: Colors.black.withOpacity(0.6)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            //'Apartment',
                                            snapshot['Overview']['propertyType'],
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    ResponsiveContainer(
                                      widthPercent: 42,
                                      heightPercent: 6,
                                      child: Container(
                                        padding: new EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                            right: BorderSide(
                                              color: Colors.grey,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                        children: <Widget>[
                                          Icon(FontAwesomeIcons.toilet,color: Colors.black.withOpacity(0.6)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            snapshot['Overview']['bathroom']+' Bathroom',
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ResponsiveContainer(
                                      widthPercent: 42,
                                      heightPercent: 6,
                                      child: Container(
                                        padding: new EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                              right: BorderSide(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.calendarAlt,color: Colors.black.withOpacity(0.6)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                DateFormat('dd/MM/yyyy').format((snapshot.data()['Date Created'] as Timestamp).toDate()).toString(),
                                                style: TextStyle(
                                                  color: Colors.black.withOpacity(0.6),
                                                  fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ),
                                      ),
                                      ResponsiveContainer(
                                        widthPercent: 42,
                                        heightPercent: 6,
                                          child: Container(
                                            padding: new EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                              right: BorderSide(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.grey,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.key,color: Colors.black.withOpacity(0.6)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                snapshot.data()['status'],
                                                style: TextStyle(
                                                  color: Colors.black.withOpacity(0.6),
                                                  fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                ),
              ),
  );
}

Widget getSixthCard() {
  return Center(
  child: Card(
    elevation: 6,
    child: InkWell(
      splashColor: Colors.blue.withAlpha(30),
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(0.0),
        child: Container(
            padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          //                   <--- left side
                          color: Colors.blue[500].withOpacity(0.6),
                          width: 3.0,
                        ),
                      ),
                    ),
                    child: Text('DESCRIPTION',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.7),
                        )),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                    snapshot.data()['description'],
                ),
                // Body Here
              ],
            )),
      ),
    ),
  ),
    );
}

Widget getSeventhCard() {
  return Center(
    child: Card(
      elevation: 6,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(0.0),
          child: Container(
              padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            //                   <--- left side
                            color: Colors.blue[500].withOpacity(0.6),
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text('AMENITIES',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.7),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Wrap(
                    children: <Widget>[
                      for(var i in snapshot['Facilities'])
                        getFacility(i)
                    ],
                  )
                  
                  // Body Here
                ],
              )),
        ),
      ),
    ),
  );
}

Widget getFacility(var fac){
  switch(fac){
    case 'Fire Safety':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffE6B15C), Color(0xffFFF84E)])),   
              child: Image.asset(
                'assets/icons/fire-extinguisher.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
    case 'Air Conditioner':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffFFB849), Color(0xffD20B54)])),   
              
              child: Image.asset(
                'assets/icons/ac.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
    case 'Washing Machine':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff76BAFF), Color(0xff4EFFF8)])),   
              
              child: Image.asset(
                'assets/icons/washing-machine.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
    case 'Car Parking':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff3A40EE), Color(0xffF747AB)])),   
              
              child: Image.asset(
                'assets/icons/parking.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case 'Wi-Fi':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffff74a4), Color(0xffCA54D4)])),   
              
              child: Image.asset(
                'assets/icons/wifi-signal.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case 'Tiffin Facility':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffff74a4), Color(0xffCA54D4)])),   
              
              
              child: Image.asset(
                'assets/icons/restaurant.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case '24x7 Water Supply':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffE6B15C), Color(0xffFFF84E)])),   
              
              
              child: Image.asset(
                'assets/icons/water.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case 'Garden':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff2BFBED), Color(0xffD9E021)])),   
              
              
              child: Image.asset(
                'assets/icons/garden.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case 'Lift':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffFBBF36), Color(0xffF88D44)])),   
              
              
              child: Image.asset(
                'assets/icons/lift.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case '24x7 CCTV':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffC8E234), Color(0xff6AEB34)])),   
              
              
              child: Image.asset(
                'assets/icons/cctv.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case 'Swimming Pool':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff77A5F8), Color(0xffD5A3FF)])),   
              
              
              child: Image.asset(
                'assets/icons/swimming-pool.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case 'Security':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffB26FEC), Color(0xff22E6B9)])),   
              
              
              child: Image.asset(
                'assets/icons/watchman.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case 'Children Park':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffB4FF4E), Color(0xff2FC145)])),   
              
              
              child: Image.asset(
                'assets/icons/children-playarea.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case 'Gym':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffFCCF31), Color(0xffF55555)])),   
              
              
              child: Image.asset(
                'assets/icons/dumbbell.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
      case 'HouseKeeping':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff60FF04), Color(0xff23EDED)])),   
              
              
              child: Image.asset(
                'assets/icons/house-keeping.png',
                width: 45,
              ),
            ),
          ),
      );
      break;
  }
}

Widget getNinthCard() {
  return Center(
    child: Card(
      elevation: 6,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(0.0),
          child: Container(
              padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            //                   <--- left side
                            color: Colors.blue[500].withOpacity(0.6),
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text('PICTURES BY CUSTOMERS',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.7),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  PhotosList(snapshot.id.toString()),
                  // Body Here
                  ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.blue[700],
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=> MultiImage(snapshot.id,snapshot)));
                    },
                    child: Center(child: Text(
                      "ADD HOUSE IMAGES",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Ex02'
                      ),
                    )),
                  ),
                ),
              )
                ],
              )),
        ),
      ),
    ),
  );
}

Widget getEightCard() {
  return Center(
  child: Card(
    elevation: 6,
    child: InkWell(
      splashColor: Colors.blue.withAlpha(30),
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(0.0),
        child: Container(
            padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          //                   <--- left side
                          color: Colors.blue[500].withOpacity(0.6),
                          width: 3.0,
                        ),
                      ),
                    ),
                    child: Text('ADDRESS',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.7),
                        )),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    snapshot['Address']['houseNo']+'--house no,'+snapshot['Address']['society']+'--society,',
                    style: TextStyle(
                      fontFamily: 'Ex02',
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 18,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    snapshot['Address']['locality']+'--location,',
                    style: TextStyle(
                      fontFamily: 'Ex02',
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 18,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    snapshot['Address']['city']+'--city,',
                    style: TextStyle(
                      fontFamily: 'Ex02',
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 18,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    snapshot['Address']['state']+'--state, '+snapshot['Address']['pincode']+'--pincode',
                    style: TextStyle(
                      fontFamily: 'Ex02',
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),

                // Body Here
              ],
            )),
      ),
    ),
  ),
    );
}


Widget getTenthCard() {
  return Center(
    child: Card(
      elevation: 6,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(0.0),
          child: Container(
              padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            //                   <--- left side
                            color: Colors.blue[500].withOpacity(0.6),
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'OWNER\'S DETAIL',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  getUserCard(context),
                  //Body Here
                ],
              )),
        ),
      ),
    ),
  );
}

Widget getUserCard(var context){
    var size = Screen(MediaQuery.of(context).size);
    return ownerSnapshot!=null ? Card(
      elevation: 0,
      borderOnForeground: true,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=> ProfilePage('/User/'+ownerSnapshot.id,true)));
            Fluttertoast.showToast(msg: "Card Tapped ${docsSnap.data()['firstName']} ${docsSnap.data()['lastName']}" );
          },
          child: Container(
            width: size.wp(90),
            height: size.hp(15),
            child: Row(
              children: <Widget>[
                /*Container(
                  width: size.hp(15),
                  color: Colors.grey,
                  child: ownerSnapshot.data()["profileImage"] ? Image.network(
                    '${ownerSnapshot.data()['profileImage']}',
                  ) : Image.asset('assets/icons/avatar.png'),
                ),*/
                Container(
                  width: size.hp(15),
                  color: Colors.grey,
                  child: Image.asset('assets/icons/avatar.png'),
                ),
                Container(
                  width: size.wp(92.7)-size.hp(20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.getWidthPx(12),horizontal: size.getWidthPx(16)),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${snapshot.data()['firstName']} ${snapshot.data()['lastName']}',
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
                            snapshot.data().containsKey("city") ?
                            Text(
                              "${snapshot.data()['city']}, nyeri",
                              style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16)),
                            ) : Text("nyeri",style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16))),
                          ],
                        ),
                        SizedBox(
                          height: size.getWidthPx(10),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: snapshot.data().containsKey("email") ?Text(
                            "${snapshot.data()['email']}",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(14))
                          ): Text("email",style: TextStyle(color: Colors.grey,fontSize: size.getWidthPx(16))),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    ) : Center(child: Card(child: CircularProgressIndicator(),),);
  }

Widget getCards() {
  return Container(
    padding: new EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    child: Column(
      children: <Widget>[
// First Card
        getFirstCard(),
// Second Card
        getSecondCard(),
// Third Card Deposit & Rent
        getThirdCard(),
// Fourth Card
        getFourthCard(),
// Fifth Card
        getFifthCard(),
// Sixth Card
        getSixthCard(),
// Seventh Card
        getSeventhCard(),
// Eight Card
        getEightCard(),
// Ninth Card
        //getNinthCard(),
        // Tenth Card
        getTenthCard(),
      ],
    ),
  );
}


}