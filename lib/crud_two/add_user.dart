// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/crud_two/main_page.dart';
import 'package:ejemploaa/crud_two/users.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  final TextEditingController idController= TextEditingController();
  final TextEditingController nameController= TextEditingController();
  final TextEditingController lastnameController= TextEditingController();
  final TextEditingController emailController= TextEditingController();
  final TextEditingController passwordController= TextEditingController();
  final TextEditingController birthdayController= TextEditingController();
  final TextEditingController sexController= TextEditingController();
  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
        centerTitle: true,),
        body: SingleChildScrollView(
          key: _formKey,
          child: Column(
            children: [
              getMyField(
                hintText: "Name", 
                textInputType: TextInputType.name, 
                obscureText:false,
                controller: nameController),
              getMyField(
                hintText: "Lastname",
                obscureText:false,
                controller: lastnameController),
              getMyField(
                hintText: "Email", 
                textInputType: TextInputType.emailAddress,
                obscureText:false,
                controller: emailController),
              getMyField(
                hintText: "Password", 
                obscureText:true,
                controller: passwordController),
              birthdayField(),
              sexField(),
              ElevatedButton(
                onPressed: (){
                  final users=Users(
                    name: nameController.text,
                    gender: sexController.text,
                    birthday: birthdayController.text, 
                    lastname: lastnameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  );    
                  createUser(users);
                  if(mounted){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("User created.")));
                        Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(
                            builder: (context)=>const MainPage()
                          ),
                          (route) => false);
                      }
                  //MaterialPageRoute(builder: (context) => const MainPage());
                  }, 
                child: const Text("Add User"))
            ]
          ),
        ),
    );
  }
  Future createUser(Users users) async{
    final docUser= FirebaseFirestore.instance.collection("users").doc();
    users.id=docUser.id;

    final json=users.toJson();
    await docUser.set(json);
  }

  Widget getMyField({
    required String hintText, 
    TextInputType textInputType= TextInputType.name, 
    required bool obscureText,
    required TextEditingController controller,
    //FocusNode? focusNode
    }){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: "Enter $hintText",
          labelText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
          )
        ),
      ),
    );
  }

  Widget birthdayField(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: birthdayController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          icon: Icon(Icons.calendar_today_rounded),
          labelText: "Birthday",
          ),
          onTap: () async{
            DateTime? pickeddate = await showDatePicker(
              context: context, 
              initialDate: DateTime.now(), 
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));            
              if(pickeddate !=null){
                setState(() {
                  birthdayController.text = DateFormat("yyyy-MM-dd").format(pickeddate);
                });
              }
          },
      ),
    );
  }
  
  Gender? _sexList;
  
  Widget sexField(){  
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RadioListTile<Gender>(
            value: Gender.Male, 
            groupValue: _sexList,
            title: Text(Gender.Male.name), 
            onChanged: (Gender? val){
              setState(() {
               _sexList= val;
              });
            }),
          RadioListTile<Gender>(
            value: Gender.Female, 
            groupValue: _sexList,
            title: Text(Gender.Female.name),
            onChanged: (Gender?  val){
              setState(() {
                _sexList= val;
              });
            }),
          RadioListTile<Gender>(
            value: Gender.Other, 
            groupValue: _sexList,
            title: Text(Gender.Other.name),
            onChanged: (Gender?  val){
              setState(() {
                _sexList= val;
              });
          }),
        ],
      ),
      );
  }
}

enum Gender{
  Male,Female,Other
}
