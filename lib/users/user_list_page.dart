
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/users/add_user_page.dart';
import 'package:ejemploaa/users/edit_user_page.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  final CollectionReference peopleCollection =
      FirebaseFirestore.instance.collection('users');

  UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Personas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: peopleCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Error al cargar los datos');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return ListTile(
                title: Row(
                  children: [
                    Text(document['name']),
                    const SizedBox(width: 5),
                    Text(document["lastname"])
                  ],
                ),
                subtitle: Text(document['gender']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserPage(document: document),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context, 
                          builder: (context)=>AlertDialog(
                            title: const Text("Alert Delete"),
                            content: const Text("Are you sure to delete?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: (){
                                  deletePerson(document.id);
                                  Navigator.of(context).pop();
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
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUserPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> deletePerson(String personId) {
    return peopleCollection
        .doc(personId)
        .delete()
        .then((value) => print("Persona eliminada"))
        .catchError((error) => print("Error al eliminar la persona: $error"));
  }
  
}

