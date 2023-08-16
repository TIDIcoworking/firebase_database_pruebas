// ignore_for_file: avoid_print, library_private_types_in_public_api, use_build_context_synchronously

import 'package:ejemploaa/auth/presentation/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';

class PinInputScreen extends StatefulWidget {
  final String verificationId;
  const PinInputScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  _PinInputScreenState createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithCredential(String pin) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: pin,
      );
      await _auth.signInWithCredential(credential);
      print('User signed in successfully!');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(),
        ),
      );

    } catch (e) {
      print('Sign In failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Verification Pin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Pinput(
              length: 6,
              onChanged: (pin) {
                print('Changed PIN is: $pin');
              },
              onCompleted: (pin) {
                print('Completed PIN is: $pin');
                signInWithCredential(pin);
              },
            ),
          ],
        ),
      ),
    );
  }
}
