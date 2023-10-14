// ignore_for_file: camel_case_types, unused_import, prefer_const_constructors, non_constant_identifier_names, avoid_types_as_parameter_names, unused_local_variable, prefer_final_fields, unused_field, avoid_unnecessary_containers, prefer_is_empty, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact/add_contact.dart';
import 'package:contact/controller/auth_service.dart';
import 'package:contact/controller/crud_services.dart';
import 'package:contact/update_contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  late Stream<QuerySnapshot> _stream;
  
  TextEditingController _searchcontroller = TextEditingController();
  FocusNode _searchfocusNode = FocusNode(); 

  @override
  void initState() {
    _stream = CRUDservices().getContacts();
    
    super.initState();
  }

  @override
  void dispose() {
    _searchfocusNode.dispose();
    _stream.drain();
    super.dispose();
  }

  //to call the contact using url launcher
  calluser(String phone) async {
    String url = "tel:$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await  launchUrl(Uri.parse(url));
    }
    else {
      throw "Could not launch$url ";
    }

  }


  searchContacts(String search){
    _stream = CRUDservices().getContacts(searchQuery: search);

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),


      floatingActionButton: _addcontactbutton(context),



      drawer: _drawer(context),


      body: StreamBuilder<QuerySnapshot>(builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: Text(
              "Loading..."
            ),
          );
        }
        return snapshot.data?.docs.length ==0? 
        Center(
          child: Text("No contact found") ) : 
          ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document){
            Map<String,dynamic> data = document.data()! as Map <String, dynamic>;
            return GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Details'),
          
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar( radius: 30,
                child: Text(data['name'][0],style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),), ),
              // ListTile(
                
              //   title: Text(data['name']),
              //   subtitle: Text(data['phone']),
              // ),
              SizedBox(height: 18,),
              Text(data['name'],style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
              SizedBox(height: 4,),
              Text(data['phone'],style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            ],
          ),
          actions: <Widget>[
            
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Edit Contact',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => updatecontact(
                        name: data['name'],
                        email: data['email'],
                        phone: data['phone'],
                        docId: document.id,
                      ),
                    ));
                  },
                ),
                TextButton(
              child: Text('Close',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
              ],
            ),
            // TextButton(
            //   child: Text('Close'),
            //   onPressed: () {
            //     Navigator.of(context).pop(); // Close the dialog
            //   },
            // ),
          ],
        );
      },
    );
  },
  child: ListTile(
    leading: CircleAvatar(child: Text(data['name'][0]),),
    title: Text(data['name']),
    subtitle: Text(data['phone']),
    trailing: IconButton(
      onPressed: () {
        calluser(data['phone']);
      },
      icon: Icon(Icons.phone),
    ),
  ),
);

            // return ListTile(
            //   onTap:() => Navigator.push(context, MaterialPageRoute(
            //     builder: (context) => updatecontact(
            //       name: data['name'],
            //       phone: data['phone'],
            //       email: data['email'],
            //       docId: document.id))) ,


            //   leading: CircleAvatar(child: Text(data['name'][0]),),

            //   title: Text(data['name']),
            //   subtitle: Text(data['phone']),
            //   trailing: IconButton(onPressed: (){
            //     calluser(data['phone']);
            //   }, icon: Icon(Icons.phone)) ,
            // );
          }).toList().cast(),
        );
      }, stream: _stream),
    );
  }




  FloatingActionButton _addcontactbutton(BuildContext context) {
    return FloatingActionButton(onPressed: (){
      Navigator.pushNamed(context, "/add");
    },
    child: Icon(Icons.person_add),);
  }










  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Column(
            children: [
              if (FirebaseAuth.instance.currentUser != null)  // Check if currentUser is not null
              CircleAvatar(
                maxRadius: 32,
                child: Text(FirebaseAuth.instance.currentUser!.email.toString()[0].toUpperCase()),
              ),
            SizedBox(height: 8,),
            if (FirebaseAuth.instance.currentUser != null)
              Text(FirebaseAuth.instance.currentUser!.email.toString()),  // Check and use only if currentUser is not null
            ],
          )), 
          ListTile(
            onTap: () {
              // AuthService().logout();
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  title:  Text("Confirm Logout"),
                  content: Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text("Cancel")),
                    TextButton(onPressed: (){
                      AuthService().logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: 
                          Text('Logged Out...')));
                      Navigator.pushReplacementNamed(context, '/login');

                    }, child: Text("Logout"))
                  ],
                );
              });
            },
            leading: Icon(Icons.logout_outlined),
            title: Text('Logout'),
          )
        ],
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      
      title: Text('CONTACT'),
      centerTitle: true,
      bottom: PreferredSize(preferredSize: Size(MediaQuery.of(context).size.width *8, 80), 
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left:16, right: 16,bottom: 8 ),
          child: TextFormField(
            onChanged:(value) {
              searchContacts(value);
              setState(() {
                
              });

            },
            focusNode: _searchfocusNode,
                    keyboardType:TextInputType.name,
                        validator: (value) => value!.isEmpty? 
                        "Name is required.":null,
                        controller: _searchcontroller,
                        
                        decoration: InputDecoration(
                          
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),),
                          label: Text('Search'),
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: _searchcontroller.text.isNotEmpty? 
                          IconButton(onPressed: (){
                            _searchcontroller.clear();
                            _searchfocusNode.unfocus();
                            _stream = CRUDservices().getContacts();
                            setState(() {
                               
                            });
                          }, icon: Icon(Icons.close)
                          ):null 
                          // hintText: 'Enter name here'
                        ),
                        
                      ),
        ),
      )),
    );
  }
}

