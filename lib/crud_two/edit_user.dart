// ignore_for_file: constant_identifier_names,, unnecessary_string_interpolations
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/crud_two/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditUser extends StatefulWidget {

  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {

  final nameController= TextEditingController();
  final lastnameController= TextEditingController();
  final emailController= TextEditingController();
  final passwordController= TextEditingController();
  final birthdayController= TextEditingController();
  final sexController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update User"),
        centerTitle: true,),
        body: SingleChildScrollView(
          child: Column(
            children: [
              getMyField(
                hintText: "Name", 
                textInputType: TextInputType.name, 
                obscureText:false,
                controller: nameController..text="${Get.arguments[("name")].toString()}",),
              getMyField(
                hintText: "Lastname",
                obscureText:false,
                controller: lastnameController..text="${Get.arguments["lastname"].toString()}"),
              getMyField(
                hintText: "Email", 
                textInputType: TextInputType.emailAddress,
                obscureText:false,
                controller: emailController..text="${Get.arguments["email"].toString()}"),
              getMyField(
                hintText: "Password""${Get.arguments["password"].toString()}", 
                obscureText:true,
                controller: passwordController),
              birthdayField(),
              sexField(),
              ElevatedButton(
                      onPressed: ()async{
              await FirebaseFirestore.instance
              .collection("users")
              .doc(Get.arguments ["name"].toString())
              .update(
                {
                  "name":nameController.text.trim(),
                  "lastname":lastnameController.text.trim(),
                  "email":emailController.text.trim(),
                  "password":passwordController.text.trim(),
                  "birthday":birthdayController.text.trim(),
                },
              ).then((value) => {
                Get.offAll(()=>const MainPage()),
                log("Data Updated"),
              });
              if(mounted){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text("User edited.")));
                        Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(
                            builder: (context)=>const MainPage()
                          ), 
                          (route) => false);
                      }
            }, 
                      child: const Text("Edit User"))
            ]),
        ),
    );
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
        controller: birthdayController..text="${Get.arguments["birthday"].toString()}",
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
                //setState(() {
                  birthdayController.text = DateFormat("yyyy-MM-dd").format(pickeddate);
                //});
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
              //setState(() {
               _sexList= val;
              //});
            }),
          RadioListTile<Gender>(
            value: Gender.Female, 
            groupValue: _sexList,
            title: Text(Gender.Female.name),
            onChanged: (Gender?  val){
              //setState(() {
                _sexList= val;
              //});
            }),
          RadioListTile<Gender>(
            value: Gender.Other, 
            groupValue: _sexList,
            title: Text(Gender.Other.name),
            onChanged: (Gender?  val){
              //setState(() {
                _sexList= val;
              //});
          }),
        ],
      ),
      );
  }
}

enum Gender{
  Male, 
  Female, 
  Other}