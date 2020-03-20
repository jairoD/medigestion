import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
class FirebaseUserProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
 /*  String grou
  FirebaseUserProvider.dataMessage(); */

//SignInWithCredentials
  Future<AuthResult> signInWithCredentials(
      String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

//signUp
  Future<AuthResult> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

//Está logueado
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Stream<String> get authState {
    return _firebaseAuth.onAuthStateChanged.map((user) => user?.uid);
  }

//Obtener informacion del usuario
  Future<FirebaseUser> getUser() async {
    final user = await _firebaseAuth.currentUser();
    return user;
  }

//Salir de la session
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

//Añadir usuario a CloudFireStore
  Future updateUserData(FirebaseUser user) async{
    DocumentReference ref = _db.collection('users').document(user.uid);
    return await ref.setData({
      'uid' : user.uid,
      'email' : user.email,
      'lastSeen' : DateTime.now(),
    }, merge: true);
  }

  

//Que hacer, cuando le da al boton de enviar
  Future onSendMessage({@required String content,@required int type,@required String groupChatId,@required String id,@required String peerId}) async{
    DocumentReference documentReference = _db
            .collection('messages')
            .document(groupChatId)
            .collection(groupChatId)
            .document(DateTime.now().millisecondsSinceEpoch.toString());

    _db.runTransaction((transaction) async{
       await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
    });
  }

//Añadir usuarios que estan chateando con un doctor
Future updateDoctorListChat(String doctorID, String patientID, String patientEmail, Map<String, dynamic> json) async{
    DocumentReference ref = _db.collection('doctors').document(doctorID).collection('chattingWith').document(patientID);
    return await ref.setData(json);
  }

//Añadir informacion adicional del usuario
  Future<bool> updateUserProfile(Map<String,dynamic> json) async{
      _db.collection('users').document(json['uid']).updateData(json);
     return true;
  }

  /* Stream<QuerySnapshot> get dataMessage(){
    return  _db.collection('messages').document(groupChatId).collection(groupChatId).orderBy('timestamp', descending: true).limit(20).snapshots();
  } */
}
