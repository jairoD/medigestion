import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medigestion/src/models/user_model.dart';
import 'package:medigestion/src/providers/firebaseUser_provider.dart';

class ProfileProvider{
final  firebaseUserProvider = new FirebaseUserProvider();
Map<String, dynamic> patient = new Map();
String linkFirebase;
Future<bool> handleInfo(User user) async{
  patient['uid']      = user.uid;
  patient['email']    = user.email;
  patient['name']     = user.name;
  patient['lastName'] = user.lastName; 
  firebaseUserProvider.updateUserProfile(patient);
  return true;
}

Future<String> uploadFile(File imageFile, String uid) async {
    String fileName = 'PROFILE:$uid-${DateTime.now().millisecondsSinceEpoch.toString()}';
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      Firestore.instance.collection('users').document(uid).updateData({'photoUrl':downloadUrl});
      linkFirebase = downloadUrl;
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'No se pudo subir imagen');
    });
    return linkFirebase;
  }


}