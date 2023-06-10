import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final oldPassword = TextEditingController();

  final newpassword = TextEditingController();

  final passwordconfirm = TextEditingController();

  @override
  void dispose() {
    oldPassword.dispose();
    newpassword.dispose();
    passwordconfirm.dispose();

    super.dispose();
  }

  changePassword({oldPassword, newpassword}) async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user!.email;

    // Reauthenticate user with current password
    final credential =
        EmailAuthProvider.credential(email: email!, password: oldPassword);
    try {
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      // Show error message if reauthentication fails
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid Old Password')));
      return;
    }

    // Change password to new password
    try {
      await user.updatePassword(newpassword);
    } catch (e) {
      // Show error message if password update fails
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error Occured')));
      return;
    }

    // Show success message and navigate back to previous page
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Password Changed Successfully'),
      duration: Duration(seconds: 2),
    ));

    FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        title: const Text("Change Password",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: oldPassword,
                    decoration:
                        const InputDecoration(labelText: "Old Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Old password is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: newpassword,
                    decoration:
                        const InputDecoration(labelText: "New Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 6
                        ? 'Enter min. 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordconfirm,
                    decoration:
                        const InputDecoration(labelText: "Confirm Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your new password";
                      } else if (newpassword.text != passwordconfirm.text) {
                        return "Passwords do not match";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.validate();
                      changePassword(
                          oldPassword: oldPassword.text,
                          newpassword: newpassword.text);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      backgroundColor: const Color.fromARGB(234, 11, 11, 11),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
