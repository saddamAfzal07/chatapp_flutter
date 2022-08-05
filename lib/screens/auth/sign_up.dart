import 'package:chatapp_flutter/provider/auth_provider.dart';
import 'package:chatapp_flutter/screens/Auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? passvalidation(value) {
    if (value == null || value.isEmpty) {
      return " Password is required";
    } else if (value.length < 6) {
      return " Password must be  6 Characters";
    } else if (value.length > 15) {
      return " Password is too Long";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthController>((context), listen: true);
    return Scaffold(
      backgroundColor: Color(0xff3c83f1),
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
                  "SIGN UP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(22),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Form(
                    key: state.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: state.username,
                          validator: RequiredValidator(
                              errorText: "Username is required"),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              prefix: SizedBox(
                                width: 5,
                              ),
                              labelText: "Username",
                              hintText: "Enter name",
                              suffixIcon: Icon(Icons.person)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: state.email,
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
                            hintText: "Enter  email",
                            suffixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: state.password,
                          validator: passvalidation,
                          obscureText: true,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefix: SizedBox(
                              width: 5,
                            ),
                            labelText: "Password",
                            hintText: "Enter  password",
                            suffixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 50),
                        state.isloading
                            ? const CircularProgressIndicator(
                                color: Color(0xFF4167b2),
                              )
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
                                    state.signup(context);
                                  },
                                  child: const Text(
                                    "SIGN UP",
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
                  "Already have an account? ",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text(
                    "LOGIN",
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
