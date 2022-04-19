import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rent_master/ui/page_add_house.dart';
class data{
   gethousedata(String buitUpArea,String status){
     return FirebaseFirestore.instance.collection("House")
         .where("builtUpArea",isEqualTo:buitUpArea)
         .where('status',isEqualTo:status)
         .snapshots();
   }
   getUSERdata(String firstName,String lastName){
     return FirebaseFirestore.instance.collection("User")
         .where("firstName",isEqualTo:firstName)
         .where('lastName',isEqualTo:lastName)
         .snapshots();
   }
}