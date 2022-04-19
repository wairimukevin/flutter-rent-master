import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:rent_master/LocalBindings.dart';
import 'package:rent_master/data.dart';
import 'package:rent_master/ui/page_house_detail.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_master/model/models.dart';
import 'package:rent_master/utils/utils.dart';
import 'package:rent_master/widgets/drawer.dart';
import 'package:rent_master/widgets/widgets.dart';
import 'package:responsive_container/responsive_container.dart';
var userRef;
class SearchResultPage extends StatefulWidget {
  SearchResultPage(u){
    userRef=u;
  }
  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  Screen size;
  var _locality;
  int _selectedIndex = -1;
  String user;
  List<Property> premiumList =  List();
  List<Property> featuredList =  List();
  var citiesList = ["Nairobi", "nyeri", "mombasa", "karatina","meru","nanyuki","mombasa","narok"];
  Image image1;
  String docRef;
  final _formKey1 = GlobalKey<FormState>();
  DocumentSnapshot docsSnap;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future<bool> validateAndSave() async {
    final form = _formKey1.currentState;
    if (form.validate()) {
      form.save();
     Navigator.pop(context);
    var userRef= await LocalStorage.sharedInstance.loadUserRef(Constants.userRef);
    print('docRef :'+ userRef);
    print(_locality);
    Navigator.push(context, MaterialPageRoute(builder: (_)=> usersearch (userRef)));
   return true;
    } else {
      return false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('House').snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == null || !snapshot.hasData )
          ? new Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue[700],
            ),
          )
          : Container(
            child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                DocumentSnapshot docsSnap = snapshot.data.docs[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        index == 0 ? upperPart() : SizedBox(width: 0,),
                        index == 0 ? SizedBox(height: 10,):SizedBox(height: 0),
                        Container(
                          padding: new EdgeInsets.symmetric(horizontal: 10),
                          child: getCard(docsSnap,context,index,userRef)
                        ),
                      ],
                    );
                  },
              )
          );
        }
      ),
      drawer: docsSnap != null ? drawer_tenant(image1,context,docsSnap.data()['profileImage'],docsSnap.data()['firstName']+" "+docsSnap.data()['lastName'],docsSnap.data()['email'],"true",'/User/'+docRef)
                              : drawer_tenant(image1,context,'assets/icons/avatar.png','Login / Register ','','false',null),
    );
  }

  Widget upperPart() {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: UpperClipper(),
          child: Container(
            height: size.getWidthPx(140),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorCurve, colorCurve],
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: size.getWidthPx(6)),
              child: Column(
                children: <Widget>[
                  titleWidget(),
                  SizedBox(height: size.getWidthPx(1)),
                  upperBoxCard(),
                ],
              ),
            ),
            //searchResult(),
            
          ],
        ),
      ],
    );
  }

  List<bool> _isPressed = List<bool>();
    
   Widget getCard(DocumentSnapshot docsSnap,var context,index,var userReference){
        //setStatus(snapshot);
        _isPressed.add(false);
        return Column(
              children: <Widget>[
                      Stack(
                            children: <Widget>[
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                margin: new EdgeInsets.all(8),
                                borderOnForeground: true,
                                child: InkWell(
                                  onTap: (){
                                    // Navigate
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HouseDetail(docsSnap),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.92,
                                          height: MediaQuery.of(context).size.height*0.25,
                                          color: Colors.grey,
                                          child:docsSnap.data().containsKey('houseImages') ? Image.network(
                                            '${docsSnap.data()['houseImages'][0]}',
                                            fit: BoxFit.fill
                                          ): Image.asset('assets/icons/avatar.png'),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          ResponsiveContainer(
                                            widthPercent: 23,
                                            heightPercent: 9,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide( 
                                                      color: Colors.grey,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text('${docsSnap.data()['builtUpArea']} Sqaure.ft.')
                                                ),
                                              ),
                                            ),
                                          ),
                                          ResponsiveContainer(
                                            widthPercent: 41,
                                            heightPercent: 9,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide( 
                                                      color: Colors.grey,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Align(
                                                      child: Text('${docsSnap['Overview']['room']} room(s) in ${docsSnap['Address']['locality']}')
                                                    ),
                                                    Align(
                                                      child: Text('${docsSnap.data()['status']}')
                                                    ),
                                                  ],
                                                ),
                                            ),
                                          ),
                                          ResponsiveContainer(
                                            widthPercent: 23,
                                            heightPercent: 9,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                                              child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text('${docsSnap.data()['monthlyRent']}'),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text('ksh/month'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ) 
                                    ],
                                  ),
                                ),
                              ),
        ],
      ),
      SizedBox(
        height: 10.0,
      ),
    ]);
  }

  Widget titleWidget() {
    return Row(
      children: <Widget>[
        IconButton(
          padding: new EdgeInsets.fromLTRB(1,0,0,0),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Text("Which type of house",
                  style: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white
                    ),
                  ),
              Text("would you like to buy?",
                style: TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Card upperBoxCard() {
    return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(
            horizontal: size.getWidthPx(20), vertical: size.getWidthPx(0)),
        borderOnForeground: true,
        child: Container(
          height: size.getWidthPx(120),
          child:Form(
            key: _formKey1,
            child: Column(
            children: <Widget>[
               TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'Locality',
                        hintText: _locality,
                      ),
                      onSaved: (String value) {
                        if (_locality == null) {
                          _locality = value;
                        } else {
                          value = _locality;
                        }
                      },
                      autofocus: true,
                      validator: (value) =>
                          value.isEmpty ? 'Locality is required' : null,
                    ),
                     IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                      validateAndSave();
                      }
                          ),
            ],
          ), 
          ),
          
        ));
  }

Widget _searchWidget() {
    return Container(
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Container(
                  child: Row(children: <Widget>[
                    SizedBox(width: size.getWidthPx(10),),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: 'search by Locality',
                        hintText: _locality,
                      ),
                      onSaved: (String value) {
                        if (_locality == null) {
                          _locality = value;
                        } else {
                          value = _locality;
                        }
                      },
                      autofocus: true,
                      validator: (value) =>
                          value.isEmpty ? 'Locality is required' : null,
                    ),
                     IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        Navigator.pop(context);
              var userRef= await LocalStorage.sharedInstance.loadUserRef(Constants.userRef);
              print('docRef :'+ userRef);
              Navigator.push(context, MaterialPageRoute(builder: (_)=> usersearch (userRef)));
                      }
                          ),
                          ],) 
                      ),),
                      ],
                    ),
                    padding: EdgeInsets.only(bottom :size.getWidthPx(8)),
                    margin: EdgeInsets.only(top: size.getWidthPx(8), right: size.getWidthPx(8), left:size.getWidthPx(8)),
                );
  }

  Padding leftAlignText({text, leftPadding, textColor, fontSize, fontWeight}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text??"",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Exo2',
                fontSize: fontSize,
                fontWeight: fontWeight ?? FontWeight.w500,
                color: textColor)),
      ),
    );
  }

  Padding buildChoiceChip(index, chipName) {
    return Padding(
      padding: EdgeInsets.only(left: size.getWidthPx(8)),
      child: ChoiceChip(
        backgroundColor: backgroundColor,
        selectedColor: colorCurve,
        labelStyle: TextStyle(
            fontFamily: 'Exo2',
            color:
                (_selectedIndex == index) ? backgroundColor : textPrimaryColor),
        elevation: 4.0,
        padding: EdgeInsets.symmetric(
            vertical: size.getWidthPx(4), horizontal: size.getWidthPx(12)),
        selected: (_selectedIndex == index) ? true : false,
        label: Text(chipName),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
class usersearch extends StatefulWidget {
  usersearch(u){
    userRef=u;
  }
  @override
  _usersearchState createState() => _usersearchState();
}

class _usersearchState extends State<usersearch> {
  Screen size;
  var _locality;
  int _selectedIndex = -1;
  String user;
  List<Property> premiumList =  List();
  List<Property> featuredList =  List();
  Image image1;
  String docRef;
  DocumentSnapshot docsSnap;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('House').where("locality",isEqualTo:_locality).snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == null || !snapshot.hasData )
          ? new Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue[700],
            ),
          )
          : Container(
            child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                DocumentSnapshot docsSnap = snapshot.data.docs[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        index == 0 ? SizedBox(height: 10,):SizedBox(height: 0),
                        Container(
                          padding: new EdgeInsets.symmetric(horizontal: 10),
                          child: searchcard(docsSnap,context,index,userRef)
                        ),
                      ],
                    );
                  },
              )
          );
        }
      ),
      drawer: docsSnap != null ? drawer_tenant(image1,context,docsSnap.data()['profileImage'],docsSnap.data()['firstName']+" "+docsSnap.data()['lastName'],docsSnap.data()['email'],"true",'/User/'+docRef)
                              : drawer_tenant(image1,context,'assets/icons/avatar.png','Login / Register ','','false',null),
    );
  }

  List<bool> _isPressed = List<bool>();
    
   Widget searchcard(DocumentSnapshot docsSnap,var context,index,var userReference){
        //setStatus(snapshot);
        _isPressed.add(false);
        return Column(
              children: <Widget>[
                      Stack(
                            children: <Widget>[
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                margin: new EdgeInsets.all(8),
                                borderOnForeground: true,
                                child: InkWell(
                                  onTap: (){
                                    // Navigate
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HouseDetail(docsSnap),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.92,
                                          height: MediaQuery.of(context).size.height*0.25,
                                          color: Colors.grey,
                                          child:docsSnap.data().containsKey('houseImages') ? Image.network(
                                            '${docsSnap.data()['houseImages'][0]}',
                                            fit: BoxFit.fill
                                          ): Image.asset('assets/icons/avatar.png'),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          ResponsiveContainer(
                                            widthPercent: 23,
                                            heightPercent: 9,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide( 
                                                      color: Colors.grey,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text('${docsSnap.data()['builtUpArea']} Sqaure.ft.')
                                                ),
                                              ),
                                            ),
                                          ),
                                          ResponsiveContainer(
                                            widthPercent: 41,
                                            heightPercent: 9,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                    right: BorderSide( 
                                                      color: Colors.grey,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Align(
                                                      child: Text('${docsSnap['Overview']['room']} room(s) in ${docsSnap['Address']['locality']}')
                                                    ),
                                                    Align(
                                                      child: Text('${docsSnap.data()['status']}')
                                                    ),
                                                  ],
                                                ),
                                            ),
                                          ),
                                          ResponsiveContainer(
                                            widthPercent: 23,
                                            heightPercent: 9,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                                              child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text('${docsSnap.data()['monthlyRent']}'),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Text('ksh/month'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ) 
                                    ],
                                  ),
                                ),
                              ),
        ],
      ),
    ]);
  }




}
