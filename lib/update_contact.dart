// ignore_for_file: camel_case_types, prefer_final_fields, unused_field, prefer_const_constructors

import 'package:contact/controller/crud_services.dart';
import 'package:flutter/material.dart';

class updatecontact extends StatefulWidget {
  const updatecontact({super.key, required this.docId, required this.name, required this.email, required this.phone});
  final String docId,name,email,phone;

  @override
  State<updatecontact> createState() => _updatecontactState();
}

class _updatecontactState extends State<updatecontact> {
  final formkey = GlobalKey<FormState>();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();

  @override
  void initState() {
    _emailcontroller.text = widget.email;
    _phonecontroller.text = widget.phone;
    _namecontroller.text = widget.name;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: appbar(context),

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
                  
                  
                  
                  
                  
                    updatebutton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }




  AppBar appbar(BuildContext context) {
    return AppBar(
      elevation: 4,
      actions: [
        
        
        TextButton(onPressed: (){

          showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title:  Text("Confirm delete"),
                
                content: Text("Are you sure you want to delete?"),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text("Cancel")),


                  TextButton(onPressed: (){
                    CRUDservices().deletecontact(widget.docId);
                    Navigator.pushNamed(context, '/home');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: 
                      Text('Contact deleted successfully..'))); 
                    


                  }, child: Text("Delete"))
                ],
              );
            });
          // CRUDservices().deletecontact(widget.docId);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: 
          //   Text('Contact deleted successfully..'))); 
          //   Navigator.pop(context);

         
          
        }, child: Text("Delete", style: TextStyle(
          fontSize: 16
        ),))
        
      ],
      title: Text("Update Contact"),
      centerTitle: true,
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

  TextFormField phonenumberfield() {
    return TextFormField(
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






  SizedBox updatebutton(BuildContext context) {
    return SizedBox(
                    height: 48,
                    width: MediaQuery.of(context).size.width * .9,
                    child: ElevatedButton(onPressed: (){
                      if (formkey.currentState!.validate()){
                        CRUDservices().updateContact(
                          _namecontroller.text, 
                          _phonecontroller.text, 
                          _emailcontroller.text,widget.docId);
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: 
                        Text('Contact updated successfully..'))); 
                        Navigator.pushNamed(context, '/home');
                      }
                      
                    }, child: Text("Update", style: TextStyle(
                      fontSize: 20
                    ),)));
  }
}