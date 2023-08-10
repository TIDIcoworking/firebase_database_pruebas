// ignore_for_file: unnecessary_string_interpolations, library_private_types_in_public_api

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/CRUD/list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final nameController= TextEditingController();
  final sexController= TextEditingController();
  final dateController= TextEditingController();
  final lastnameController= TextEditingController();
  final passwordController= TextEditingController();
  final idController= TextEditingController();

  @override
  Widget build(BuildContext context)=> Scaffold(
    appBar: AppBar(
      title: Text(
        Get.arguments["name"].toString()
      )
    ),
    body: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: nameController..text="${Get.arguments["name"].toString()}",
            decoration: const InputDecoration(
              labelText: "Name"),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: lastnameController..text="${Get.arguments["lastname"].toString()}",
            decoration: const InputDecoration(
              labelText: "Last Name"),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: dateController..text="${Get.arguments["birthday"].toString()}",
            decoration: const InputDecoration(
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
                      dateController.text = DateFormat("yyyy-MM-dd").format(pickeddate);
                    });
                  }
              },
          ),
          ElevatedButton(
            onPressed: ()async{
              await FirebaseFirestore.instance
              .collection("users")
              .doc(Get.arguments ["name"].toString())
              .update(
                {
                  "name":nameController.text.trim(),
                  "lastname":lastnameController.text.trim(),
                  "sex":sexController.text.trim(),
                  "birthday":dateController.text.trim(),
                },
              ).then((value) => {
                Get.offAll(()=>const ListPage()),
                log("Data Updated" as num),
              });
            },
            child: const Text("Update"),
          )
        ],
      ),
    ),


  );
}