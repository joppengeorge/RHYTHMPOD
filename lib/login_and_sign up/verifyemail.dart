import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui/home_page.dart';
import 'package:lottie/lottie.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;

  bool canResendEmail = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    //call after email verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));

      setState(() => canResendEmail = true);
    } catch (e) {
      /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Error occured'),
      duration: Duration(seconds: 5),));*/
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage1()
      : Scaffold(
          backgroundColor: const Color.fromARGB(255, 11, 11, 11),
          appBar: AppBar(
            title: const Text(
              'Verify Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color.fromARGB(221, 11, 11, 11),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/email.json',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Verification email has been sent to your email!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                  icon: const Icon(
                    color: Colors.black,
                    Icons.email,
                    size: 32,
                  ),
                  label: const Text(
                    'Resend Email',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor:  const Color.fromARGB(197, 18, 253, 226),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 199, 199, 199),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
}
