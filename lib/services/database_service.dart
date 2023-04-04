import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secureshare/models/fileModel.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  //saving User data
  Future savingUserData(String name, String email, String phone) async {
    return await userCollection.doc(uid).set(
      {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'profilepic': '',
      },
    );
  }

// getting user data.
  Stream gettinguserData() {
    return userCollection.doc(uid).snapshots();
  }

// saving user file to database
  Future savingFile(String fileUrl, String filename) async {
    var filemodel = FileModel(
      filename: filename,
      url: fileUrl,
      dateTime: DateTime.now(),
    );
    return await userCollection.doc(uid).collection('uploads').doc().set(
          filemodel.toMap(),
        );
  }

  // getting file data (details)
  Stream gettingfile() {
    return userCollection.doc(uid).collection('uploads').snapshots();
  }

// deleting file
  Future deleteFile(String id) async {
    var ref = await userCollection.doc(uid).collection('uploads').doc(id);
    return ref
        .delete()
        .then((value) => print("File deleted"))
        .catchError((err) {
      print("Failed to delete user $err");
    });
  }

  // updating file name
  Future updateName(String id, String name) async {
    return userCollection
        .doc(uid)
        .collection('uploads')
        .doc(id)
        .update({
          'filename': name,
        })
        .then((value) => print("Updated name"))
        .catchError((err) {
          print("Error");
        });
  }
}
