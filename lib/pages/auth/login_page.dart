import 'package:chat_system/pages/auth/register_page.dart';
import 'package:chat_system/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Groupie',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Login to see what they are talking!',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                Image.asset('assets/login.png'),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                      debugPrint(email);
                    });
                  },
                  validator: (value) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!)
                        ? null
                        : 'Enter a valid Email';
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                      debugPrint(password);
                    });
                  },
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Password must be atleast 6 characters';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      login();
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                          text: 'Create account',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, RegisterPage());
                            }),
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() {
    if (formKey.currentState!.validate()) {}
  }
}
