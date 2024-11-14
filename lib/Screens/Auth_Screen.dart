import 'dart:io';

import 'package:chat_app/Widgets/User_Image_Picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
final _firebase=FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

 var isLogin=true;
 var enteredEmail="";
 var enterdPassword="";
 File? selectedImage;
 var isAuthenticating=false;
 var enterdUsername="";
 final _form=GlobalKey<FormState>();
 
 
 void _submit() async{
  final isValid=_form.currentState!.validate();
  if(!isValid||(!isLogin&&selectedImage==null)){
      return;
  }
  _form.currentState!.save();
 try {
  setState(() {
    isAuthenticating=true;
  });
if(isLogin) {
   final UserCredential=await _firebase.signInWithEmailAndPassword(email: enteredEmail, password: enterdPassword);
}
else{
 
  final UserCredential= await _firebase.createUserWithEmailAndPassword(email: enteredEmail, password: enterdPassword);
       final storageRef=FirebaseStorage.instance.ref().child('user_images').child('${UserCredential.user!.uid }.jpg');   
        await storageRef.putFile(selectedImage!);
        final imageUrl=await storageRef.getDownloadURL();
        print(imageUrl);
        FirebaseFirestore.instance.collection('users').doc(UserCredential.user!.uid).
        set({
          'username':enterdUsername,
          'email':enteredEmail,
          'image_url':imageUrl
        }
        );
  }
   }
   on FirebaseAuthException catch (error){
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.message?? 'Authentication failed'))
    );
    setState(() {
      isAuthenticating=false;
    });
  }
}

  @override
 


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin:const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        if(!isLogin)
                          UserImagePicker(onPickedImage: (SelectedImage){
                            selectedImage=SelectedImage;
                          },)
                        ,
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Email Address')
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if(value==null||value.trim().isEmpty||!value.contains('@')){
                              return 'Please enter a valid email address';
                            }
                            return null;

                          },
                          onSaved: (newValue) {
                            enteredEmail=newValue!;
                          },
                        ),
                      if(!isLogin)
                          TextFormField(
                          decoration: const InputDecoration(labelText: "Username"),
                          enableSuggestions: false
                          ,
                        validator: (value) {
                          if(value==null||value.isEmpty||value.trim().length<4){
                            return "Please enter at least 4 characters";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          enterdUsername=newValue!;
                        },
                        ),
                      
                         TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Password')
                          ),
                          obscureText: true,
                          validator: (value) {
                            if(value==null||value.trim().isEmpty||value.trim().length>6){
                              return 'password must be at least 6 characters long';
                            }
                            return null;

                          },
                          onSaved: (newValue) {
                            enterdPassword=newValue!;
                          },
                          
                        ),
                        const SizedBox(height:12),
                        if(isAuthenticating)
                         const  CircularProgressIndicator(),
                        
                        if(!isAuthenticating)
                          ElevatedButton(onPressed:_submit, style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer

                        ), child:Text(isLogin?'Login':'Signup') ),
                        
                        if(!isAuthenticating)
                          TextButton(onPressed:(){ 
                        setState(() {
                          isLogin=!isLogin;
                        });},
                         child: Text(isLogin? 'Create an account':'I already have an account'))
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}