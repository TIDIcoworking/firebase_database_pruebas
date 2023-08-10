// ignore_for_file: unnecessary_null_comparison, unused_element, constant_identifier_names, unused_local_variable, avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Gender{Male,Female,Other}

List<Gender> genderOptions=[Gender.Male,Gender.Female,Gender.Other];

class _HomePageState extends State<HomePage> {
  final TextEditingController idController= TextEditingController();
  final TextEditingController nameController= TextEditingController();
  final TextEditingController lastnameController= TextEditingController();
  final TextEditingController emailController= TextEditingController();
  final TextEditingController passwordController= TextEditingController();
  final TextEditingController birthdayController= TextEditingController();
  final TextEditingController sexController=TextEditingController();
  final _formKey=GlobalKey<FormState>();

  //String? _sexList;
  Gender? _sexList;

  final CollectionReference _users= FirebaseFirestore.instance.collection("users");


  Future<void> _create([DocumentSnapshot?documentSnapshot]) async{
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (BuildContext ctx){
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom+20,),
            child: SingleChildScrollView(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(
                    child: Text(
                      "Create user",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    ), 
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                      hintText: "Name"),
                    ),
                  const SizedBox(height: 16),
                  //LAST NAME
                  TextFormField(
                    controller: lastnameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Last Name",
                      hintText: "Last Name"),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  //PASSWORD
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      hintText: "Password"),
                  ),
                  const SizedBox(height: 16),
                  //Bithrday
                  TextFormField(
                    controller: birthdayController,
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
                              birthdayController.text = DateFormat("yyyy-MM-dd").format(pickeddate);
                            });
                          }
                      },
                  ),
                  const SizedBox(height: 16),
                  sexField(),
                  const SizedBox(height: 16,),
                  ElevatedButton(
                    onPressed: () async{
                      final id=idController.text;
                      final String name=nameController.text;
                      final String lastname=lastnameController.text;
                      final String email=emailController.text;
                      final String password=passwordController.text;
                      final String birthday=birthdayController.text;            
                      if(id!=null){
                        await _users.add({
                          "name":name,
                          "lastname":lastname,
                          "email":email,
                          "password":password,
                          "birthday":birthday,
                          "sex":_sexList.toString(),});
                        nameController.text="";
                        lastnameController.text="";
                        emailController.text="";
                        passwordController.text="";
                        birthdayController.text="";
                      }    
                      if(mounted){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("$name created.")));
                        Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(
                            builder: (context)=>const HomePage()
                          ),
                          (route) => false);
                      }
                    }, 
                    child: const Text("Create"))
                ],
              ),
            ),
          ),
        );
      });
  }

  Widget sexField(){  
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text("Male"),
            leading: Radio<Gender>(
              value: Gender.Male, 
            groupValue: _sexList, 
            onChanged: (Gender? value){
              setState(() {
               _sexList= value;
              });
            }),
            ),
          ListTile(
            title: const Text("Female"),
            leading: Radio<Gender>(
              value: Gender.Female, 
            groupValue: _sexList, 
            onChanged: (Gender? value){
              setState(() {
               _sexList= value;
              });
            }),
            ),
          ListTile(
            title: const Text("Other"),
            leading: Radio<Gender>(
              value: Gender.Other, 
            groupValue: _sexList, 
            onChanged: (Gender? value){
              setState(() {
               _sexList= value;
              });
            }),
            ),
        ],
      ),
      );
  }

  Future<void> _update([DocumentSnapshot?documentSnapshot]) async{
    if(documentSnapshot!=null){
      nameController.text=documentSnapshot["name"];
      lastnameController.text=documentSnapshot["lastname"];
      emailController.text=documentSnapshot["email"];
      passwordController.text=documentSnapshot["password"];
      birthdayController.text=documentSnapshot["birthday"];
      sexController.text=documentSnapshot["sex"];
    }
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (BuildContext ctx){
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom+20,),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Update user",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    ), 
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                      hintText: "Name"),
                    ),
                  const SizedBox(height: 16),
                  //LAST NAME
                  
                  TextFormField(
                    controller: lastnameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Last Name",
                      hintText: "Last Name"),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  //PASSWORD
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      hintText: "Password"),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: birthdayController,
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
                              birthdayController.text = DateFormat("yyyy-MM-dd").format(pickeddate);
                            });
                          }
                      },
                  ),
                  sexField(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async{
                      final id=idController.text;
                      final String name=nameController.text;
                      final String lastname=lastnameController.text;
                      final String email=emailController.text;
                      final String password=passwordController.text;
                      final String birthday= birthdayController.text;
                      if(id!= null){
                        await _users.doc(documentSnapshot!.id).update(
                          {
                          "name":name,
                          "lastname":lastname,
                          "email":email,
                          "password":password,
                          "birthday":birthday,
                          "sex":_sexList.toString()}
                        );
                        nameController.text="";
                        lastnameController.text="";
                        emailController.text="";
                        passwordController.text="";
                        birthdayController.text="";
                        sexController.text="";
                      }
                      if(mounted){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text("$name edited.")));
                        Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(
                            builder: (context)=>const HomePage()
                          ), 
                          (route) => false);
                      }
                    }, 
                    child: const Text("Update"))
                ],
              ),
            ),
          ),
        );
      });
  }

  Future<void> _delete(String productId)async{
    
    await _users.doc(productId).delete();
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("User Deleted Succesfully."))
      );
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(
          builder: (context)=>const HomePage()), 
          (route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _users.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
            if (streamSnapshot.hasData){
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index){
                  final DocumentSnapshot documentSnapshot= streamSnapshot.data!.docs[index];
                  return Card(
                    color: const Color.fromARGB(255, 88, 166, 190),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        documentSnapshot["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      ),
                      subtitle: Text(documentSnapshot["email"]),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(children: [
                          IconButton(
                            color: Colors.black,
                            onPressed: ()=> _update(documentSnapshot), 
                            icon: const Icon(Icons.edit)),
                          IconButton(
                            color: Colors.black,
                            onPressed: (){
                              showDialog(
                                  context: context, 
                                  builder: (context)=>AlertDialog(
                                    title: const Text("Alert Delete"),
                                    content: const Text("Are you sure to delete?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: (){
                                          _delete(documentSnapshot.id);
                                          
                                        },
                                        child: const Text("Delete"),
                                        
                                      ),
                                      TextButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        }, 
                                        child: const Text("Cancel")
                                      )
                                    ],
                                  )
                                );
                            }, 
                            icon: const Icon(Icons.delete)),
                        ],),
                      ),
                    ),
                  );
                }
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 88, 166, 190),
        child: const Icon(Icons.add),
        onPressed: ()=>_create()),
    );
  }
}