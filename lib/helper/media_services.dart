import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices{
  static StorageServices storageServices = StorageServices._();
  StorageServices._();

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadMediaFile(File file) async {
    try{
      String fileName = 'images/${DateTime.now().microsecondsSinceEpoch}.jpg';
      Reference reference = firebaseStorage.ref().child(fileName);
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }catch(r){
      print('Error uploading file: $r');
      return null;
    }
  }
}