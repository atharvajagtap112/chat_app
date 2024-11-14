import 'package:chat_app/Widgets/Message_Bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentUserId=FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.
      collection('chat').
      orderBy('createdAt',descending: true).snapshots(), 
      builder: (ctx,chatSnapshort){
         if(chatSnapshort.connectionState==ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
         }
         
         if(!chatSnapshort.hasData||chatSnapshort.data!.docs.isEmpty){
          return const Center(child: Text('No message found'),);
         }
         if(chatSnapshort.hasError){
          return const Center(child: Text('Something went wrong'),);
         }
         final loadMessage=chatSnapshort.data!.docs;

         return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40,left: 13,right: 13),
          reverse: true,
          itemCount:loadMessage.length,
         itemBuilder: (ctx,index)
         {
          final chatMessage=loadMessage[index].data();
          final nextChatMessage=index+1<loadMessage.length? loadMessage[index+1].data():null;

          final currentMessageUserId=chatMessage['userId'];
          final nextMessageUserId=nextChatMessage!=null? nextChatMessage['userId']:null;

          final nextUserIsSame=currentMessageUserId==nextMessageUserId;
           
          if(nextUserIsSame){
            return MessageBubble.next(isMe:currentMessageUserId==CurrentUserId ,
                               message: chatMessage['text'], 
                                                               );
          }
          
          else{
            return  MessageBubble.first(
                userImage: chatMessage['userImage'],
                 username: chatMessage['username'], 
                 message: chatMessage['text'], 
                 isMe: currentMessageUserId==CurrentUserId);
          }
         });
         

    }
    ) ;
  }
}