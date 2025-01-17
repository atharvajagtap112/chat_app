import 'package:chat_app/Widgets/Chat_Messages.dart';
import 'package:chat_app/Widgets/New_Messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void setupPushNotifications() async{
      final fcm=FirebaseMessaging.instance;
      await fcm.requestPermission();
         
         final token=await fcm.getToken();
         print(token);
  }
   @override
   void initState(){
       super.initState();
       setupPushNotifications();
   }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          }, icon: const Icon(
            Icons.exit_to_app
          ))
        ],
        title:const Text("Chat Screen"),
      ),
      body: 
     const Column(
        children: [
          Expanded(child: ChatMessages()),
          NewMessages()
        ],
      ),);
    
  }
}