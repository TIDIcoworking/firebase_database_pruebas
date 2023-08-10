// ignore_for_file: invalid_return_type_for_catch_error, avoid_print, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String lastname;
  String email;
  String password;
  String birthday;
  String gender;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
    required this.birthday,
    required this.gender,
  });
}

class PersonListPage extends StatelessWidget {
  final CollectionReference peopleCollection =
      FirebaseFirestore.instance.collection('users');

  PersonListPage({super.key});

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
                title: Text(document['name']),
                subtitle: Text('Género: ${document['gender']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPersonPage(document: document),
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
              builder: (context) => const AddPersonPage(),
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

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  _AddPersonPageState createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdayController = TextEditingController();
  String? _selectedGender;

  CollectionReference peopleCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addPerson() {
    return peopleCollection
        .add({
          'name': _nameController.text,
          'lastname': _lastnameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'birthday': _birthdayController.text,
          'gender': _selectedGender,
        })
        .then((value) => {
              setState(() {
                _nameController.clear();
                _lastnameController.clear();
                _emailController.clear();
                _passwordController.clear();
                _birthdayController.clear();
                _selectedGender = null;
              })
            })
        .catchError((error) => print("Error al agregar la persona: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agregar Persona'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingresa el nombre';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingresa el apellido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingresa el correo electrónico';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingresa la contraseña';
                      } else if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _birthdayController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de nacimiento',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingresa la fecha de nacimiento';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Género',
                    ),
                    items: <String>['Masculino', 'Femenino', 'Otro']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecciona el género';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addPerson();
                      }
                    },
                    child: const Text('Agregar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditPersonPage extends StatefulWidget {
  final DocumentSnapshot document;

  const EditPersonPage({super.key, required this.document});

  @override
  _EditPersonPageState createState() => _EditPersonPageState();
}

class _EditPersonPageState extends State<EditPersonPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdayController = TextEditingController();
  String? _selectedGender;

  CollectionReference peopleCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.document['name'];
    _lastnameController.text = widget.document['lastname'];
    _emailController.text = widget.document['email'];
    _passwordController.text = widget.document['password'];
    _birthdayController.text = widget.document['birthday'];
    _selectedGender = widget.document['gender'];
  }

  Future<void> updatePerson() {
    return peopleCollection
        .doc(widget.document.id)
        .update({
          'name': _nameController.text,
          'lastname': _lastnameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'birthday': _birthdayController.text,
          'gender': _selectedGender,
        })
        .then((value) => {
              setState(() {
                Navigator.pop(context);
              })
            })
        .catchError((error) => print("Error al actualizar la persona: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Persona'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingresa el nombre';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingresa el apellido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingresa el correo electrónico';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingresa la contraseña';
                      } else if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _birthdayController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de nacimiento',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, ingresa la fecha de nacimiento';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Género',
                    ),
                    items: <String>['Masculino', 'Femenino', 'Otro']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecciona el género';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updatePerson();
                      }
                    },
                    child: const Text('Actualizar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

