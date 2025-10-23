import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService{
  final db = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;


// Add a new document with a generated ID
   addData(Map<String, dynamic> user){
    db.collection("users").add(user).then((DocumentReference doc) {
      log('Document added successful');
      log('DocumentSnapshot added with ID: ${doc.id}');
    }

    );}

   getAllUsers()async{
    var count = 0;
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        count++;
        log('Document loaded successful');
        log("${doc.id} => ${doc.data()}");
      }
      log('Total documents: $count');

    });
  }


   searchUser(String name,String newName){
    db.collection('users').where('first',isEqualTo: name).get().then((event){
      for (var doc in event.docs) {
        log('Search successfully');
        log("${doc.id} => ${doc.data()}");
      }
    });
  }

   updateUser(String name,String newName)async{
    await db.collection('users').where('first',isEqualTo: name).get().then((event){
      for (var doc in event.docs) {
        db.collection('users').doc(doc.id).update({'first':newName});
        log("${doc.id} => ${doc.data()}");
      }
    });
  }

   deleteUser(){
    db.collection("users").doc('viJes2kRFsDZxr1O5JxK').delete();
  }


  signUp(String email, String password)async{
    try {
      final user = await auth.createUserWithEmailAndPassword(email: email, password: password);
      log(user.user!.uid);
      log(user.user!.email!);
    }catch (e) {
      log(e.toString());
    }
  }

  signIN(String email, String password)async{
    try {
      final user = await auth.signInWithEmailAndPassword(email: email, password: password);
      log(user.user!.uid);
      log(user.user!.email!);
    }catch (e) {
      log(e.toString());
    }
  }


  signOut()async{
     await auth.signOut();
  }


  checkState(){
     auth.authStateChanges().listen((user){
       if(user == null){
         log('User is currently signed out');
       }else{
         log('user is signed in');
       }});
  }

}