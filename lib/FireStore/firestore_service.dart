import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{
  final db = FirebaseFirestore.instance;



// Add a new document with a generated ID
  dynamic addData(Map<String, dynamic> user){
    db.collection("users").add(user).then((DocumentReference doc) {
      log('Document added successful');
      log('DocumentSnapshot added with ID: ${doc.id}');
    }

    );}

  dynamic getAllUsers()async{
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


  dynamic searchUser(String name,String newName){
    db.collection('users').where('first',isEqualTo: name).get().then((event){
      for (var doc in event.docs) {
        log('Search successfully');
        log("${doc.id} => ${doc.data()}");
      }
    });
  }

  dynamic updateUser(String name,String newName)async{
    await db.collection('users').where('first',isEqualTo: name).get().then((event){
      for (var doc in event.docs) {
        db.collection('users').doc(doc.id).update({'first':newName});
        log("${doc.id} => ${doc.data()}");
      }
    });
  }

  dynamic deleteUser(){
    db.collection("users").doc('viJes2kRFsDZxr1O5JxK').delete();
  }

}