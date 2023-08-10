import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/CRUD/add_client.dart';
import 'package:ejemploaa/CRUD/client.dart';
import 'package:ejemploaa/CRUD/edit_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final controller =TextEditingController();

  @override
  Widget build(BuildContext context)=> Scaffold(
      appBar: AppBar(
        title: const Text("All Users"),  
      ),
      body: StreamBuilder<List<Client>>(
        stream: readUsers(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            final users= snapshot.data!;

            return ListView(
              children: users.map(buildUser).toList(),
            );
          } 
          if (snapshot.hasError){
            return const Center(child: Text("Something was wrong"),);
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const UserPage(title: 'Add User'),
            ));
        },
      ),
    );


    Widget buildUser(Client user) =>ListTile(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Text(user.username),
          const SizedBox(width: 5),
          Text(user.lastname),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: (){
              Get.to(()=>const EditPage(),
              arguments: {
                "name": user.username,
                "id": user.id,
                "lastname":user.lastname,
                "birthday":user.birthday,
                "password":user.password,
              });
            },
            child: const Icon(Icons.edit)), 
          const SizedBox(width: 10),
          const Icon(Icons.delete),
        ],
      ),
    );

    Stream<List<Client>> readUsers() => FirebaseFirestore.instance
    .collection("users").snapshots()
    .map((snapshot) => snapshot.docs.map((doc)=>Client.fromJson(doc.data())).toList());
}