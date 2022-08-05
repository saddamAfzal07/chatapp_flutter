import 'package:chatapp_flutter/screens/components/user_id.dart';
import 'package:chatapp_flutter/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:chatapp_flutter/screens/Auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends ChangeNotifier {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  bool isloading = false;

  final formKey = GlobalKey<FormState>();

  signup(BuildContext context) async {
    final isvalid = formKey.currentState!.validate();

    if (isvalid) {
      createAccount(username.text, email.text, password.text, context);
    } else {
      print("field empty");
    }
    notifyListeners();
  }

  Future<User?> createAccount(
      String name, String email, String password, context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      UserCredential userCrendetial = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Successfully Signup"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));

      userCrendetial.user!.updateDisplayName(name);

      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "name": name,
        "email": email,
        "status": "Unavalible",
        "uid": _auth.currentUser!.uid,
      });

      return userCrendetial.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///LOGIN_USER

  final loginformKey = GlobalKey<FormState>();
  bool loginLoading = false;
  login(String email, pass, context) async {
    loginLoading = true;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      Userdata.userId = credential.user!.uid;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const HomePage(),
        ),
        (route) => false,
      );
      loginLoading = false;
    } on FirebaseAuthException catch (e) {
      loginLoading = false;

      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("User not found"),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ));
      } else if (e.code == 'wrong-password') {
        loginLoading = false;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Wrong Password"),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
    notifyListeners();
  }
}
