import 'package:chatapp_flutter/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

class UsersChat extends ChangeNotifier {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController search = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    isLoading = true;
    await _firestore
        .collection('users')
        .where("email", isEqualTo: search.text)
        .get()
        .then((value) {
      userMap = value.docs[0].data();
      isLoading = false;
      print(userMap);
    });
    notifyListeners();
  }

//Conversation b/w users
//Chat Room
  final TextEditingController message = TextEditingController();

  File? imageFile;

  Future getImage(chatRoomId) async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage(chatRoomId);
      }
    });
    notifyListeners();
  }

  Future uploadImage(chatRoomId) async {
    String fileName = Uuid().v1();

    int status = 1;

    await firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": auth.currentUser!.displayName,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
    notifyListeners();
  }

  void onSendMessage(chatRoomId) async {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": auth.currentUser!.displayName,
        "message": message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      message.clear();
      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
    notifyListeners();
  }
}
