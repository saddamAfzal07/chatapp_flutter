import 'package:chatapp_flutter/provider/auth_provider.dart';
import 'package:chatapp_flutter/provider/chat_provider.dart';
import 'package:chatapp_flutter/screens/Auth/login.dart';
import 'package:chatapp_flutter/screens/chat_screen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Map<String, dynamic>? userMap;
  // bool isLoading = false;
  // final TextEditingController _search = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  // void onSearch() async {
  //   FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //   setState(() {
  //     isLoading = true;
  //   });

  //   await _firestore
  //       .collection('users')
  //       .where("email", isEqualTo: _search.text)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       userMap = value.docs[0].data();
  //       isLoading = false;
  //     });
  //     print(userMap);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var state = Provider.of<UsersChat>((context), listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('username');
                await FirebaseAuth.instance.signOut();
                print("Log out");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              }),
        ],
      ),
      body: state.isLoading
          ? Center(
              child: SizedBox(
                height: size.height / 20,
                width: size.height / 20,
                child: const CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: state.search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    state.onSearch();
                  },
                  child: const Text("Search"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                state.userMap != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListTile(
                          onTap: () {
                            String roomId = chatRoomId(
                                state.auth.currentUser!.displayName!,
                                state.userMap!['name']);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                  chatRoomId: roomId,
                                  userMap: state.userMap!,
                                ),
                              ),
                            );
                          },
                          leading: const Icon(Icons.person,
                              size: 40, color: Colors.blue),
                          title: Text(
                            state.userMap!['name'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(state.userMap!['email']),
                          trailing: const Icon(Icons.chat, color: Colors.green),
                        ),
                      )
                    : Container(),
              ],
            ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.group),
      //   onPressed: () {},
      // ),
    );
  }
}
