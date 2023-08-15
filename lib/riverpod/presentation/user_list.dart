// ignore_for_file: avoid_print, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/riverpod/aplication/search_term.dart';
import 'package:ejemploaa/riverpod/aplication/user_service.dart';
import 'package:ejemploaa/riverpod/presentation/add_user.dart';
import 'package:ejemploaa/riverpod/presentation/edit_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersListPage extends ConsumerWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchTerm = ref.watch(searchTermProvider);
    final userService = ref.read(userServiceProvider);
    final searchController = TextEditingController(text: searchTerm);
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchController.text.length));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      if (value.length >= 3) {
                        ref.read(searchTermProvider.notifier).setSearchTerm(value);
                      } else {
                        ref.read(searchTermProvider.notifier).setSearchTerm('');
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Buscar',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    ref.read(searchTermProvider.notifier).setSearchTerm('');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: userService.getUsers(searchTerm),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error al cargar los datos');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final searchTermValue = searchTerm.toLowerCase();

                final results = snapshot.data!.docs.where((doc) {
                  final name = doc['name'].toString().toLowerCase();
                  final lastname = doc['lastname'].toString().toLowerCase();
                  final gender = doc['gender'].toString().toLowerCase();
                  return name.contains(searchTermValue) ||
                      lastname.contains(searchTermValue) ||
                      gender.contains(searchTermValue);
                }).toList();

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final document = results[index];
                    return ListTile(
                      title: Row(
                        children: [
                          Text(document['name']),
                          const SizedBox(width: 3,),
                          Text(document['lastname']),
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
                                        userService.deleteUser(document.id);
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
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUsersPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}