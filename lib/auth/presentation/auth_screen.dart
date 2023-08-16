// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:ejemploaa/auth/presentation/pinput_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  String _verificationId = '';

  Future<void> verifyPhoneNumber() async {
    final String phoneNumber = '+593${_phoneNumberController.text}';
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Auto-retrieve the verification code on some devices.
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
      },
      codeSent: (String? verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId!;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PinInputScreen(verificationId: _verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout.
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: verifyPhoneNumber,
              child: const Text('Verify Phone Number'),
            ),
          ],
        ),
      ),
    );
  }
}
