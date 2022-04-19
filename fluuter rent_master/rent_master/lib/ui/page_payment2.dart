import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_master/data.dart';
import 'package:rent_master/utils/responsive_screen.dart';
import 'package:rent_master/utils/utils.dart';
import 'package:rent_master/widgets/invoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

class PaymentPage2 extends StatefulWidget {
  DocumentSnapshot docsSnap;
  @override
  _PaymentPage2State createState() => _PaymentPage2State(docsSnap);
  PaymentPage2(this.docsSnap);
}

class _PaymentPage2State extends State<PaymentPage2> {
  DocumentSnapshot docsSnap;
  _PaymentPage2State(this.docsSnap);
  String _mobileNo,_name,_email,_city,_propertyName;
  double _amount;
  var name;
  var _startDate, _lastDate;
  Screen size;
  DateTime _sdate,_ldate;
  Razorpay _razorpay;
  var owner;
  bool dataflag= false;
  var datareview;
  dynamic transactionInitialisation;
  var _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    name=docsSnap.data()['firstName'];
    owner = {
      'name': docsSnap.data()['firstName']+' '+docsSnap.data()['lastName'],
      'mobileNo': docsSnap.data()['mobileNo'],
      'email': docsSnap.data()['email'],
      'address': docsSnap.data().containsKey('address') ? docsSnap['address'] : '',
      'city': docsSnap.data().containsKey('city') ? docsSnap['city'] : '',
    };
    //openCheckout();
  }
  
  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pay Rent to$name",
          style: TextStyle(fontFamily: 'Ex02'),
        ),
        backgroundColor: colorCurve,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(size.getWidthPx(20)),
          child: ListView(
            children: <Widget>[
               TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name *', 
                  hintText: 'Enter Your Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person)
                ),
                validator: validateName,
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              
              SizedBox(
                height: size.getWidthPx(10),
              ),
               TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter Your Email', 
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.mail)
                ),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              SizedBox(
                height: size.getWidthPx(10),
              ),
               TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mobile Number *', 
                  hintText: 'Enter Your Mobile Number formart 254706327125',
                  border: OutlineInputBorder(),
                  prefixText: "+2540",
                  prefixIcon: Icon(Icons.phone)
                ),
                maxLength: 12,
                keyboardType: TextInputType.phone,
                validator: validatePhone,
                onChanged: (value) {
                  setState(() {
                    _mobileNo = value;
                  });
                },
              ),
              SizedBox(
                height: size.getWidthPx(5),
              ),
               TextFormField(
                decoration: InputDecoration(
                  labelText: 'Rent Amount *', 
                  hintText: 'Enter Your Amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(FontAwesomeIcons.dollarSign)
                ),
                keyboardType: TextInputType.phone,
                validator: validateAmount,
                onChanged: (value) {
                  setState(() {
                    _amount = double.parse(value.toString());
                  });
                },
              ),
              SizedBox(
                height: size.getWidthPx(10),
              ),
               TextFormField(
                 maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Address *', 
                  hintText: 'Enter Rented Property Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home)
                ),
                validator: validateAddress,
                onChanged: (value) {
                  setState(() {
                    _propertyName = value;
                  });
                },
              ),
              SizedBox(
                height: size.getWidthPx(10),
              ),
               TextFormField(
                decoration: InputDecoration(
                  labelText: 'City *', 
                  hintText: 'Enter City',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(FontAwesomeIcons.mapMarkerAlt),
                ),
                validator: validateCity,
                onChanged: (value) {
                  setState(() {
                    _city = value;
                  });
                },
              ),
              SizedBox(
                height: size.getWidthPx(10),
              ),
              GestureDetector(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2025),
                  ).then<DateTime>((DateTime value){
                    if(value!=null && _lastDate==null){
                      setState((){_startDate = new DateFormat('dd-MM-yyyy').format(value);_sdate=value;});
                    }else if(value!=null && _lastDate!=null){
                      (value.difference(_sdate).inSeconds < 0) ? setState((){_startDate = new DateFormat('dd-MM-yyyy').format(value);_sdate=value;})
                       : Fluttertoast.showToast(msg: 'Start Date must be before  $_lastDate');
                    }
                  });
                },
                child:AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: _startDate == null ? 'Start Date *' : _startDate.toString(),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(FontAwesomeIcons.calendarAlt),
                    ),
                    validator: (value){
                      return _startDate==null ? 'Start date is required': null;
                    },
                  ),
                )
              ),
              SizedBox(
                height: size.getWidthPx(10),
              ),
              GestureDetector(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2025),
                  ).then<DateTime>((DateTime value){
                    if(value!=null && _startDate != null){
                      (value.difference(_sdate).inSeconds > 0) ? setState((){_lastDate = new DateFormat('dd-MM-yyyy').format(value);_ldate=value;})
                       : Fluttertoast.showToast(msg: 'Last Date must be after  $_startDate');
                      //print('Date Time = $value');
                    }else if(value!=null && _startDate==null){
                      Fluttertoast.showToast(msg: 'Select Start Date');
                    }
                  });
                },
                child:AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: _lastDate==null ? 'Last Date *' : _lastDate.toString(),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(FontAwesomeIcons.calendarAlt),
                    ),
                    validator: (value){
                      return _lastDate==null ? 'Last date is required': null;
                    },
                  ),
                )
              ),

              SizedBox(
                height: size.getWidthPx(10),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(size.getWidthPx(5)),
                child: Container(
                  width: double.infinity,
                  color: Colors.blue[700],
                  child: FlatButton(
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        //openCheckout();
                        try {
                          transactionInitialisation =
                          await MpesaFlutterPlugin.initializeMpesaSTKPush(
                          businessShortCode: "174379",
                          transactionType: TransactionType.CustomerPayBillOnline,
                          amount: _amount,
                          partyA: _mobileNo,
                          partyB: "174379",
                          callBackURL: Uri(scheme: "https",
                              host: "mpesa-requestbin.herokuapp.com",
                              path: "/14y5a4r1"),
                          accountReference: "rentmaster",
                          phoneNumber: _mobileNo,
                          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
                          transactionDesc: "rentpayment",
                          passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");
                          print("transactionresults:"+transactionInitialisation.toString());
                          var payment = {
                          'dateCreated' : new DateTime.now(),
                          'amount' : _amount,
                          'status' : "SUCCESS",
                          'ownerRef' : docsSnap.reference,
                          'paymentID' : "transactionInitialisation.toString()",
                          'mode' : 'MPESA PAYBILL',
                          'ownerfname' : docsSnap.data()['firstName'],
                          'ownersname' : docsSnap.data()['lastName'],
                          'city' : _city,
                          'propertyAddress' : _propertyName,
                          'tenantContact' : "+254$_mobileNo",
                          'tenantEmail' : _email,
                          'tenantName' : _name,
                          'startDate' : _startDate,
                          'lastDate' : _lastDate,};
                          FirebaseFirestore.instance.collection('Payment').add(payment);
                          Future.delayed(Duration(seconds: 10), () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Invoice(payment,owner)));
                            });
                          return transactionInitialisation;
                        }
                        catch (e) {
                          print("CAUGHT EXCEPTION: " + e.toString());
                          }
                          var payment = {
                          'dateCreated' : new DateTime.now(),
                          'amount' : _amount,
                          'status' : "SUCCESS",
                          'ownerRef' : docsSnap.reference,
                          'paymentID' : "transactionInitialisation.toString()",
                          'mode' : 'CARD / NET BANKING',
                          'city' : _city,
                          'propertyAddress' : _propertyName,
                          'tenantContact' : "+2540$_mobileNo",
                          'tenantEmail' : _email,
                          'tenantName' : _name,
                          'startDate' : _startDate,
                          'lastDate' : _lastDate,};
                          FirebaseFirestore.instance.collection('Payment').add(payment);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Invoice(payment,owner)));
                          }
                          },
                          child: Center(child: Text(
                            "PROCEED FOR PAYMENT",
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: size.getWidthPx(20),
                            fontFamily: 'Ex02'),
                            )),
                            ),
                            height: size.hp(8),
                            ),
                            )
                            ],
                            ),
                            ),
                            )
                            );
                            }

  String validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String validateAddress(String value) {
    if (value.isEmpty) return 'Address is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z0-9-,./\\[\] ]+$');
    if (!nameExp.hasMatch(value))
      return 'Address can only contain [ 0-9 A-Z a-z . - \\ / ] only';
    return null;
  }

  String validateCity(String value) {
    if (value.isEmpty) return 'City is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z0-9-,./\\[\] ]+$');
    if (!nameExp.hasMatch(value))
      return 'City can contain [ 0-9 A-Z a-z . - \\ / ] only';
    return null;
  }

  String validatePhone(String value) {
    if(value.isEmpty) return 'Mobile number is required.';
    final RegExp amtExp = new RegExp(r'^[0-9]+$');
    if(!amtExp.hasMatch(value)) return 'Please enter valid mobile number';
    else if(value.length!=12){
      return 'Mobile number must beformart 254706327125';
    }
    return null;
  }

  String validateAmount(String value) {
    if(value.isEmpty) return 'Please provide the amount to be paid.';
    final RegExp amtExp = new RegExp(r'^[0-9]+$');
    if(double.parse(value)<=0.0 || !amtExp.hasMatch(value)){
      return 'Please enter valid amount.';
    }
    return null;
  }

  String validateEmail(String value) {
      if (value.isEmpty) {
        return 'Email is required.';
      }
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
  }
    }

