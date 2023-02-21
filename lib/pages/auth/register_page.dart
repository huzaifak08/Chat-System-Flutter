import 'package:chat_system/helper/helper_function.dart';
import 'package:chat_system/pages/auth/login_page.dart';
import 'package:chat_system/pages/home_page.dart';
import 'package:chat_system/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Groupie',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('Create your account now to chat and explore!',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                Image.asset('assets/register.png'),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Full Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      fullName = value;
                      debugPrint(fullName);
                    });
                  },
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return 'Name cannot be empty';
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                const SizedBox(height: 20),
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
                      register();
                    },
                    child: _isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, const LoginPage());
                            }),
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  register() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      authService
          .registerWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared Preferences state:

          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserNameSF(fullName);
          await HelperFunction.saveUSerEmailSF(email);

          nextScreenReplace(context, const HomePage());
        } else {
          setState(() {
            _isLoading = false;
          });

          toastMessage('The error you got is $value');
        }
      });
    }
  }
}
