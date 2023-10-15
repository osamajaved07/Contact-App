// ignore_for_file: camel_case_types, prefer_final_fields, unused_field, prefer_const_constructors

import 'package:contact/controller/crud_services.dart';
import 'package:flutter/material.dart';

class addcontact extends StatefulWidget {
  const addcontact({super.key});

  @override
  State<addcontact> createState() => _addcontactState();
}

class _addcontactState extends State<addcontact> {
  final formkey = GlobalKey<FormState>();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left:20, right: 20, top: 100),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                  
                  
                namefield(),
                  
                    SizedBox(height: 40,),
                  
                  
                  
                    phonenumberfield(),
                  
                    SizedBox(height: 40,),
                  
                    
                  
                    emailfield(),
                  
                    SizedBox(height: 40,),
                  
                  
                  
                  
                  
                    addcontactbutton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      elevation: 4,
      title: Text("Add Contact"),
      centerTitle: true,
    );
  }





  SizedBox addcontactbutton(BuildContext context) {
    return SizedBox(
                    height: 48,
                    width: MediaQuery.of(context).size.width * .9,
                    child: ElevatedButton(onPressed: (){
                      if (formkey.currentState!.validate()){
                        CRUDservices().addNewContacts(_namecontroller.text, _phonecontroller.text, _emailcontroller.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: 
                        Text('Contact added successfully..'))); 
                        Navigator.pop(context);
                      }
                      
                    }, child: Text("Add Contact", style: TextStyle(
                      fontSize: 20
                    ),)));
  }

  TextFormField emailfield() {
    return TextFormField(
                    
                    controller: _emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      label: Text('Email'),
                      hintText: 'Enter email here'
                    ),
                    
                  );
  }

  TextFormField phonenumberfield() {
    return TextFormField(
                    // validator: (value) => value!.isEmpty? "Phone number is required." : null,
                    validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Phone number must not be empty';
          } else if (!RegExp(r'03[0-9]{2}[0-9]{7}$').hasMatch(value)) {
            return 'Enter a valid Phone number';
          }
          return null;
        },
                    controller: _phonecontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      label: Text('Phone Number'),
                      hintText: 'Phone number (e.g., 033********)'
                    ),
                    
                  );
  }

  TextFormField namefield() {
    return TextFormField(
                keyboardType:TextInputType.name,
                    validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name must not be empty';
          } else if (!RegExp(r'^[A-Z][a-zA-Z]*$').hasMatch(value)) { 
            return 'Enter a name with atleast first letter capital';
          }
          return null;
        },
                    controller: _namecontroller,
                    
                    decoration: InputDecoration(
                      
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),),
                      label: Text('Name'),
                      hintText: 'John Doe'
                    ),
                    
                  );
  }
}