import 'package:chatapp_flutter/provider/auth_provider.dart';
import 'package:chatapp_flutter/provider/chat_provider.dart';
import 'package:chatapp_flutter/screens/Auth/login.dart';
import 'package:chatapp_flutter/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthController(),
          ),
          ChangeNotifierProvider(
            create: (_) => UsersChat(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter chat app',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LoginScreen(),
        ));
  }
}
