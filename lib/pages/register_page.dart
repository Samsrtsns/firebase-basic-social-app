import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/components/my_buttons.dart';
import 'package:socialapp/components/my_textfield.dart';
import 'package:socialapp/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPwController = TextEditingController();

  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CupertinoActivityIndicator(),
      ),
    );

    if (passwordController.text != confirmPwController.text) {
      Navigator.pop(context);
      displayMessageToUser("Password don't match!", context);
    } else {
      try {
        // Create the user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Add to firestore
        createUserDocument(userCredential);

        if (context.mounted) Navigator.pop(context);
        displayMessageToUser('Success!!', context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        displayMessageToUser(e.code, context);
      }
    }
    setState(() {
      usernameController.text = '';
      emailController.text = '';
      passwordController.text = '';
      confirmPwController.text = '';
    });
  }
  // // Create a user document and collect in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person,
                size: 80,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'REGISTER',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 50,
              ),
              MyTextField(
                hintText: 'Username',
                obscureText: false,
                controller: usernameController,
                hasPasswordLine: false,
              ),
              const SizedBox(
                height: 12,
              ),
              MyTextField(
                hintText: 'Email',
                obscureText: false,
                controller: emailController,
                hasPasswordLine: false,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                hintText: 'Password',
                obscureText: true,
                controller: passwordController,
                hasPasswordLine: true,
              ),
              const SizedBox(
                height: 12,
              ),
              MyTextField(
                hintText: 'Password Confirm',
                obscureText: true,
                controller: confirmPwController,
                hasPasswordLine: true,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 25,
              ),
              MyButton(
                text: 'Register',
                onTap: registerUser,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Login Here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
