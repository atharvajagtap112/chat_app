import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final  _messageController=TextEditingController();
  
  
  void _submitMessage()async{
    final enterdMessage=_messageController.text;
    if(enterdMessage.trim().isEmpty) return;
     _messageController.clear();
     FocusScope.of(context).unfocus();
      final user=FirebaseAuth.instance.currentUser;
       final userData= await FirebaseFirestore.instance.collection('users').doc(user!.uid).get(); 
    FirebaseFirestore.instance.collection('chat').add(
      {
        'text':enterdMessage,
        'createdAt':Timestamp.now(),
        'userId':user.uid,
        'username':userData.data()!['username'],
        'userImage':userData.data()!['image_url']
      }
    );

    
  }
  @override
  void dispose() {
    _messageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding:const EdgeInsets.only(left: 15,right:1,bottom: 14), 
    child:Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: const InputDecoration(labelText: 'Send a message..'),
          ),
        ),
        IconButton(color: Theme.of(context).colorScheme.primary,
          onPressed: _submitMessage,
           icon: const Icon(Icons.send))
      ],
    ) , );
  }
}