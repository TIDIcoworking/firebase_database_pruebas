// ignore_for_file: dead_code, unnecessary_string_interpolations, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/CRUD/client.dart';
import 'package:ejemploaa/CRUD/list_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});
  final String title;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  final idController= TextEditingController();
  final nameController= TextEditingController();
  final lastnameController= TextEditingController();
  final emailController=TextEditingController();
  final passwordController= TextEditingController();
  final dateController= TextEditingController();
  final sexController= TextEditingController();

  @override
  Widget build(BuildContext context)=> Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          //NAME
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Name",
              hintText: "Name"),
          ),
          const SizedBox(height: 24),
          //LAST NAME
          TextFormField(
            controller: lastnameController,
            decoration: const InputDecoration(
              labelText: "Last Name",
              hintText: "Last Name"),
          ),
          const SizedBox(height: 24),
          //EMAIL
          TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "email@gmail.com",
                  border: OutlineInputBorder(),
                  labelText: "Email"
                ),
              ),
              const SizedBox(height: 24),
          //PASSWORD
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Password"),
          ),
          const SizedBox(height: 24),
          //BIRTHDAY
          TextFormField(
            controller: dateController,
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
          const SizedBox(height: 24),
          //SEX
          
              const SizedBox(height: 24),
          ElevatedButton(
            onPressed: ()async{
              final user=Client(
                username: nameController.text,
                id: idController.text,
                email: emailController.text,
                birthday: dateController.text, 
                lastname: lastnameController.text,
                password: passwordController.text,
              );
              createUser(user);
              Navigator.pop(context);
              //MaterialPageRoute(builder: (context) => const MainPage());
              if(mounted){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("${user.username} added.")));
                    Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(
                        builder: (context)=>const ListPage()
                      ), 
                      (route) => false);
                  }
            },
            child: const Text("Create"),
          )
        ],
      ),
    );

  Future createUser(Client user) async{
    final docUser= FirebaseFirestore.instance.collection("users").doc();
    user.id=docUser.id;

    final json=user.toJson();
    await docUser.set(json);
  }
}
