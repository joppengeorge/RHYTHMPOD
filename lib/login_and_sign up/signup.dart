import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../main.dart';




class Authpage extends StatefulWidget {
  const Authpage({super.key});


  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  bool isLogin=true;
  @override
  Widget build(BuildContext context) =>
  isLogin? LoginPage(onClickedSignup: toggle) : 
           SignUpPage(onClickedSignIn: toggle);

    void toggle()=>setState(() => isLogin=!isLogin);
}


class SignUpPage extends StatefulWidget {
    final Function() onClickedSignIn;

   const SignUpPage({Key? key,required this.onClickedSignIn}) :super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _name=TextEditingController();

  final emailController=TextEditingController();

  final _phone=TextEditingController();

  final passwordconfirm=TextEditingController();

  final passwordController=TextEditingController();

   final _formkey=GlobalKey<FormState>();


   @override
     void dispose()
  {
    emailController.dispose();
    passwordController.dispose();
    _name.dispose();
    _phone.dispose();
    passwordconfirm.dispose();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome',style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 71, 68, 214),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _name,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: 'Name',
                  ),
                  validator: (value)
                    {
                      if(value==null || value.isEmpty)
                      {
                        return 'Empty';
                      }
                      else
                      {
                        return null;
                      }

                    }
                ),
                const SizedBox(height: 20),
          
                TextFormField(
                  controller: emailController,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: 'Email',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email)  =>
                    email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid email'
                    : null,
                    
                ),
                const SizedBox(height: 20),
          
                TextFormField(
                  controller: _phone,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: 'Phone',
                  ),
                  validator: (value)
                    {
                      if(value==null || value.isEmpty)
                      {
                        return 'Empty';
                      }
                      else if (!RegExp(r'^\d{10}$').hasMatch(value)) 
                      {
                        return 'Enter a valid phone number';
                      }
                      else
                      {
                        return null;
                      }

                    }
                ),
                const SizedBox(height: 20),
          
                TextFormField(
                  controller: passwordController,
                  obscureText:true,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: 'Password',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value)  =>
                    value != null && value.length<6
                    ? 'Enter min. 6 characters'
                    : null,
                ),
                const SizedBox(height: 20),
          
                TextFormField(
                  controller: passwordconfirm,
                  obscureText:true,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: 'Confirm Password',
                  ),
                  validator: (value)
                    {
                      if(value==null || value.isEmpty)
                      {
                        return 'Empty';
                      }
                      else if(passwordController.text != passwordconfirm.text)
                      {
                        return 'Password does not match';
                      }
                      else
                      {
                        return null;
                      }

                    }
                ),
                const SizedBox(height: 20),
          
                ElevatedButton(
                  
                  onPressed: ()
                    {
                       _formkey.currentState!.validate();
                     signup();
                    // TODO: Handle sign-up logic
                    },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 71, 68, 214),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(10,50)),
                  child: const Text('Sign Up',style: TextStyle(fontSize: 20),),
                  
                ),
                const SizedBox(height: 100),
                RichText(
                  text: TextSpan(style: const TextStyle(color: Colors.black,fontSize: 20,),
                  text: 'Already have an account?    ',
                  children:[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                      ..onTap=widget.onClickedSignIn,
                      text: 'Log In',
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color.fromARGB(255, 71, 68, 214)
                      )
                    )
                  ]
                  )
                ),
                 
              ],
            ),
          ),
        ),
      ),
    );
  }

 Future signup() async{
  final isValid =_formkey.currentState!.validate();
  if(!isValid) return;

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) =>const Center(child: CircularProgressIndicator())
      );


    try{
         await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(), 
      password: passwordController.text.trim(),
      );

      addUserDetails(
        _name.text.trim(),
        emailController.text.trim(),
        _phone.text.trim()
      );


    } on FirebaseAuthException catch(e)
    {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Email is already used by another account'),
      duration: Duration(seconds: 5),));
    }
    navigatorKey.currentState!.popUntil((route)=>route.isFirst);
 }


 Future addUserDetails(String name,String email,String phone) async
 {
    FirebaseAuth auth =FirebaseAuth.instance;
    String uid =auth.currentUser!.uid.toString();
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {
        'Name' :name,
        'Email' : email,
        'Phone' : phone,
        'uid'   : uid

      }
    );

 }

 
}



