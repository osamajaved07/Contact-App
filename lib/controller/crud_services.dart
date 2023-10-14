// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDservices{
  User? user = FirebaseAuth.instance.currentUser;

  Future addNewContacts(String name, String phone, String email) async {
    Map <String,dynamic> data = {
      "name" : name,
      "email" : email,
      "phone" : phone
    };


    try{
      await FirebaseFirestore.instance.collection("users").
      doc(user!.uid).collection("contacts").add(data);
      print("Document added");
    }

    catch (e) {
      print(e.toString());
    }

  }
  Stream<QuerySnapshot> getContacts({String? searchQuery}) async* {
    var contactsQuery = FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .collection("contacts")
    .orderBy('name');
    
    //a filter to perform search
    if (searchQuery!=null && searchQuery.isNotEmpty){
      String searchEnd = searchQuery + "\uf8ff";
      contactsQuery= contactsQuery.where("name", isGreaterThanOrEqualTo: searchQuery, isLessThan: searchEnd );
    }

    var contacts = contactsQuery.snapshots();
    yield* contacts;
  }

  Future updateContact(String name, String phone, String email, String docId) async {
    Map <String,dynamic> data = {
      "name" : name,
      "email" : email,
      "phone" : phone
    };


    try{
      await FirebaseFirestore.instance.collection("users").
      doc(user!.uid).collection("contacts").doc(docId).update(data);
      print("Contact Updated");
    }

    catch (e) {
      print(e.toString());
    }

  }
  Future deletecontact (String docId) async {
    try {
      await FirebaseFirestore.instance.collection("users").
      doc(user!.uid).collection("contacts").doc(docId).delete();
      print("Contact deleted");
    }
    catch (e){
      print(e.toString());
    }

  }
}