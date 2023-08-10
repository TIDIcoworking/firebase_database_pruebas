import 'package:ejemploaa/login/aplication/services/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationScreen extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: lastnameController,
            decoration: const InputDecoration(labelText: 'Lastname'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final lastname = lastnameController.text;
              final email = emailController.text;
              final password = passwordController.text;

              final userRepository = ref.read(userRepositoryProvider);
              final authRepository = ref.read(authRepositoryProvider);

              userRepository.createUser(
                name: name,
                lastname: lastname,
                email: email,
                password: password,
              );

              authRepository.signInWithPhoneNumber("+123456789");

              // Navigate to the next screen
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}