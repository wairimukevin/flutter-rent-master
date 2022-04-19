import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_master/data.dart';
import 'package:rent_master/ui/page_house_detail.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rent_master/model/models.dart';
import 'package:rent_master/utils/utils.dart';
import 'package:rent_master/widgets/drawer.dart';
import 'package:rent_master/widgets/drawer_landloard.dart';
import 'package:rent_master/widgets/widgets.dart';
import 'package:responsive_container/responsive_container.dart';

import '../LocalBindings.dart';
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
  var fname;
  var sname;
  int _selectedIndex = -1;
  String user;
  List<Property> premiumList =  List();
  List<Property> featuredList =  List();
  var citiesList = ["Nairobi", "nyeri", "mombasa", "karatina","meru","nanyuki","mombasa","narok"];
  Image image1;
  String docRef;
  DocumentSnapshot docsSnap;


  @override
  void initState() {
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


  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('House').where("0firstName",isEqualTo:fname)
         .where('lastName',isEqualTo:sname).snapshots(),
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
                        //index == 0 ? upperPart() : SizedBox(width: 0,),
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
      drawer: docsSnap != null ? drawer_landlocrd(image1,context,docsSnap.data()['profileImage'],docsSnap.data()['firstName']+" "+docsSnap.data()['lastName'],docsSnap.data()['email'],"true",'/User/'+docRef)
                              : drawer_landlocrd(image1,context,'assets/icons/avatar.png','Login / Register ','','false',null),
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
                                                  child: Text('${docsSnap.data()['builtUpArea']} Sq.ft.')
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
                                                      child: Text('${docsSnap['Overview']['room']} BHK in ${docsSnap['Address']['city']}')
                                                    ),
                                                    Align(
                                                      child: Text('${docsSnap['Overview']['furnishingStatus']}')
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
                                                      child: Text('Rs. / month'),
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


}

