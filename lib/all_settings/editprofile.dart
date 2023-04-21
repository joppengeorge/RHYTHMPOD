import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ui/all_settings/changepassword.dart';
import 'package:ui/all_settings/userprofile.dart';

class EditUserDetailsPage extends StatefulWidget {
  const EditUserDetailsPage({super.key});

  @override
  _EditUserDetailsPageState createState() => _EditUserDetailsPageState();
}

class _EditUserDetailsPageState extends State<EditUserDetailsPage> {
  String name = "";
  String phone = "";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> updateUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "Name": nameController.text,
      "Phone": phoneController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(255, 71, 68, 214),
        title: const Text("Edit User Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              /*TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  return null;
                },
              ),*/
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required";
                  }
                   else if (!RegExp(r'^\d{10}$').hasMatch(value)) 
                      {
                        return 'Enter a valid phone number';
                      }
                      else
                      {
                        return null;
                      }
                  
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await updateUserDetails();
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Userdetails()));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 71, 68, 214)),
                child: const Text("Save Changes"),
              ),
              const SizedBox(height: 100),
               GestureDetector(
                    child: const Text('Change Password',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 71, 68, 214),
                      fontSize: 20,
                    ),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChangePasswordPage(),
                    )),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
