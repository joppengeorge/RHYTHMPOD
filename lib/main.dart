//import 'dart:js';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'login_and_sign up/signup.dart';
//import 'package:just_audio/just_audio.dart';
import 'login_and_sign up/verifyemail.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true
  );

  runApp(  const   MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Music and Podcast Streaming App',
      home: AnimatedSplashScreen(splash: 
         Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
       
          children: 
              [Column(
                children: 
                 const [ 
                  ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(bottom:8.0),
                      child: Text('RHYTHMPOD',textAlign: TextAlign.center,style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: Colors.white),),
                    ),
                    
                    subtitle: Text('Streaming the beats of the world to your ears',textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w100,color: Colors.red),),
                    
                  )
                  ]
              )
            ],
          
        ),
      ),
      duration: 3000,
      splashTransition: SplashTransition.slideTransition,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
   
      nextScreen: const HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting)
          {
              return const Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError)
          {
              return const Center(child: Text('Something went wrong'));
          }
          else if(snapshot.hasData)
          {
            return const VerifyEmailPage();
          }
          else
          {
            return const Authpage();
          }
        },
    ));
  }
}




class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignup;

 const LoginPage({Key? key,required this.onClickedSignup}) :super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 255, 255, 255),
              ],
            ),
          ),
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/3.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: emailController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.grey),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Enter a valid email'
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            _formkey.currentState!.validate();
                            signIn();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              backgroundColor: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(
                                  text: 'No account? ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal)),
                              TextSpan(
                                text: 'Sign Up',
                                style: const TextStyle(
                                    fontSize: 17,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = widget.onClickedSignup,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()),
                          ),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 300,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No account found with corresponding email and password'),
        duration: Duration(seconds: 5),
      ));
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final formkey=GlobalKey<FormState>();
  final emailController=TextEditingController();
  
  @override
  void dispose()
  {
    emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 71, 68, 214),
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Receive an email to\n reset your password',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                      controller: emailController,
                      decoration:  const InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                       autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email)  =>
                    email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid email'
                    : null,
                    ),
               const SizedBox(height: 20,),
               ElevatedButton.icon(onPressed: resetPassword, 
               icon: const Icon(Icons.email_outlined), 
               label: const Text('Reset Password',style: TextStyle(fontSize: 24),),
               style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 71, 68, 214))
               )

            ],
          )
           ), 
        ),
    );
  }
  Future resetPassword() async{

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) =>const Center(child: CircularProgressIndicator())
      );

    try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Password Reset Email Sent'),
      duration: Duration(seconds: 5),));
      navigatorKey.currentState!.popUntil((route)=>route.isFirst);
    }on FirebaseAuthException catch(e)
    {
      print(e);
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Error Ocurred'),
      duration: Duration(seconds: 5),));
      Navigator.of(context).pop();
    }


  }
}






