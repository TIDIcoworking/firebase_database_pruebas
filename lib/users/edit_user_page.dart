// ignore_for_file: library_private_types_in_public_api, invalid_return_type_for_catch_error, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditUserPage extends StatefulWidget {
  final DocumentSnapshot document;

  const EditUserPage({super.key, required this.document});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    keyboardType: TextInputType.emailAddress,
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
                      icon: Icon(Icons.calendar_today_rounded),
                      labelText: "Birthday",),
                    onTap: () async{
                      DateTime? pickeddate = await showDatePicker(
                        context: context, 
                        initialDate: DateTime.now(), 
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));
                      if(pickeddate !=null){
                        setState(() {
                          _birthdayController.text = DateFormat("yyyy-MM-dd").format(pickeddate);
                        });
                      }
                    },
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

