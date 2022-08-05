import 'package:chatapp_flutter/provider/auth_provider.dart';
import 'package:chatapp_flutter/screens/Auth/sign_up.dart';
import 'package:chatapp_flutter/screens/components/user_id.dart';
import 'package:chatapp_flutter/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? passvalidation(value) {
    if (value == null || value.isEmpty) {
      return " password is required";
    } else if (value.length < 5) {
      return " password must be  5 Characters";
    } else if (value.length > 15) {
      return " password is too Long";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthController>((context), listen: true);
    return Scaffold(
      backgroundColor: const Color(0xff3c83f1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.all(22),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Form(
                    key: state.loginformKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: state.loginEmail,
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "Email is required"),
                              EmailValidator(errorText: "Not a valid Email"),
                            ],
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefix: SizedBox(
                              width: 5,
                            ),
                            labelText: "Email",
                            hintText: "Enter your email",
                            suffixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                              child: Icon(Icons.email_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: state.loginPassword,
                          validator: passvalidation,
                          obscureText: true,
                          decoration: const InputDecoration(
                            prefix: SizedBox(
                              width: 5,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Password",
                            hintText: "Enter your password",
                            suffixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                              child: Icon(Icons.lock_outline),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade400,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        state.loginLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    primary: Colors.white,
                                    backgroundColor: const Color(0xFF4167b2),
                                  ),
                                  onPressed: () {
                                    final isvalid = state
                                        .loginformKey.currentState!
                                        .validate();
                                    if (isvalid) {
                                      state.login(state.loginEmail.text,
                                          state.loginPassword.text, context);
                                    } else {}
                                  },
                                  child: const Text(
                                    "SIGN IN",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don’t have an account? ",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()));
                  },
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
