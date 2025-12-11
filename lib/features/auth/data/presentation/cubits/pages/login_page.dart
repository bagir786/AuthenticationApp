import 'dart:math';

import 'package:app_auth/features/auth/data/presentation/components/goggle_sign_in_button.dart';
import 'package:app_auth/features/auth/data/presentation/components/my_button.dart';
import 'package:app_auth/features/auth/data/presentation/components/my_textfield.dart';
import 'package:app_auth/features/auth/data/presentation/components/apple_sign_in_button.dart';
import 'package:app_auth/features/auth/data/presentation/cubits/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';


class LoginPage extends StatefulWidget {
  final void Function()? togglePages;

  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controller
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  //auth cubit
  late final authCubit = context.read<AuthCubit>();

  // login button pressed
  void login() {
    //pressed email & pw
    final String email = emailController.text;
    final String pw = pwController.text;

    //ensure that the fields are filled
    if (email.isNotEmpty && pw.isNotEmpty) {
      // login!
      authCubit.login(email, pw);
    }
    // fields are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email & pasword")),
      );
    }
  }

  // forgot password box

  void openForgotPasswordBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Forgot Password"),
        content: MyTextfield(
          controller: emailController,
          hintText: "Enter email..",
          obscureText: false,
        ),
        actions: [
          // cancelk button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          //reset button
          TextButton(
            onPressed: () async {
              String message = await authCubit.forgotPassword(
                emailController.text,
              );

              if (message == "Password reset email sent! Check your inbox") {
                Navigator.pop(context);
                emailController.clear();
              }

              ScaffoldMessenger.of(context)
               .showSnackBar(SnackBar(content: Text(message)));
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  // Build Ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Login"), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //logo
                Icon(
                  Icons.lock_open,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
        
                const SizedBox(height: 25),
        
                // nama aplikasi
                Text(
                  "Authentication App",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
        
                const SizedBox(height: 25),
        
                // email textfield
                MyTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
        
                const SizedBox(height: 10),
        
                // pw textfield
                MyTextfield(
                  controller: pwController,
                  hintText: "Password",
                  obscureText: true,
                ),
        
                //forgot pw
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => openForgotPasswordBox(),
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
        
                const SizedBox(height: 10),
        
                // login button
                MyButton(onTap: login, text: "LOGIN"),
        
                const SizedBox(height: 25),
                Row(children: [
                  Expanded(
                    child: Divider(
                    color : Theme.of(context).colorScheme.tertiary,
                  ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text("Or Sign Up With")),
                  Expanded(
                    child: Divider(
                    color : Theme.of(context).colorScheme.tertiary,
                  ),
                  ),
                ],),
        
                const SizedBox(height: 25,),
        
                //oath sign later..  (google + apple)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //apple button
                   MyAppleSignInButton(onTap: () {
                     
                   },),
                   const SizedBox(width: 10,),
        
                   // gogle button
                   MyGoogleSignInButton(onTap: () {
                     authCubit.signInWithGoogle();
                   },)
                  ],
                ),
        
                const SizedBox(height: 25,),
                
        
                // don't have an account? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have  an accont?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        "Register now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
