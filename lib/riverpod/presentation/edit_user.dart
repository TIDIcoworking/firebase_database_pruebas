// ignore_for_file: avoid_print, must_be_immutable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/riverpod/aplication/user_service.dart';
import 'package:ejemploaa/riverpod/domain/user.dart';
import 'package:ejemploaa/riverpod/presentation/user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EditUserPage extends ConsumerWidget {
  final DocumentSnapshot document;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdayController = TextEditingController();
  String? _selectedGender;

  EditUserPage({super.key, required this.document});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userService = ref.watch(userServiceProvider);

    _nameController.text = document['name'];
    _lastnameController.text = document['lastname'];
    _emailController.text=document["email"];
    _passwordController.text = document['password'];
    _birthdayController.text = document['birthday'];
    _selectedGender = document['gender'];

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
                        //setState(() {
                          _birthdayController.text = DateFormat("yyyy-MM-dd").format(pickeddate);
                        //});
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
                      //setState(() {
                        _selectedGender = newValue;
                      //});
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecciona el género';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updatedUser = User(
                          name: _nameController.text,
                          lastName: _lastnameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          birthday: _birthdayController.text,
                          gender: _selectedGender ?? '',
                        );

                        await userService.updateUser(document.id, updatedUser.toJson());

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.amber,
                            content: Text('Usuario actualizado.'),
                          ),
                        );

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsersListPage(),
                          ),
                          (route) => false,
                        );
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
