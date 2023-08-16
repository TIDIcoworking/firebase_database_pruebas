// ignore_for_file: dead_code, unnecessary_string_interpolations, library_private_types_in_public_api, use_build_context_synchronously, unnecessary_null_comparison, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemploaa/CRUD/list_page.dart';
import 'package:ejemploaa/app_crud.dart';
import 'package:ejemploaa/auth/presentation/auth_screen.dart';
import 'package:ejemploaa/crud_two/main_page.dart';
import 'package:ejemploaa/firebase_crud/home.dart';
import 'package:ejemploaa/riverpod/presentation/user_list.dart';
import 'package:ejemploaa/users/user_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Crud Example',
        initialRoute: 'read',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        routes: {
          //'read': (BuildContext context) => const UsersListPage(),
          'read': (BuildContext context) => const AuthScreen(),
          //'read': (BuildContext context) => UserListPage(),

        },
      ),
    );
  }
}