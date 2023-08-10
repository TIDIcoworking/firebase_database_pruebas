import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/crud_two/add_user.dart';
import 'package:ejemploaa/crud_two/edit_user.dart';
import 'package:ejemploaa/crud_two/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final CollectionReference<Map<String, dynamic>> _users= FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        centerTitle: true,
      ),
      body: StreamBuilder(
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        IconButton(
                          color: Colors.black,
                          onPressed: (){
                            Get.to(()=>const EditUser(),
                            arguments: {
                              "id": _users.id,
                            });
                          }, 
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context)=>const AddUser()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildUser(Users users)=>ListTile(
    shape: RoundedRectangleBorder(
        side: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Text(users.name),
          const SizedBox(width: 5),
          Text(users.lastname),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: (){
              Get.to(()=>const EditUser(),
              arguments: {
                "id": users.id,
                "name": users.name,
                "lastname":users.lastname,
                "email":users.email,
                "password":users.password,
                "birthday":users.birthday,
                "gender":users.gender,
              });
            },
            child: const Icon(Icons.edit)), 
          const SizedBox(width: 10),
          const Icon(Icons.delete),
        ],
      ),
  );

  Stream<List<Users>> readUsers() => FirebaseFirestore.instance.collection("users")
    .snapshots().map((snapshot) => snapshot.docs.map(
      (doc)=>Users.fromJson(doc.data())).toList());

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
          builder: (context)=>const MainPage()), 
          (route) => false
      );
    }
  }
}