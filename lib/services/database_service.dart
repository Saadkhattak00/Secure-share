import 'package:cloud_firestore/cloud_firestore.dart';

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

  Stream gettinguserData() {
    return userCollection.doc(uid).snapshots();
  }

  Stream gettingmyupload() {
    return userCollection.doc(uid).collection('uploads').doc(uid).snapshots();
  }

  Future savingFile(String fileUrl, String filename) async {
    return await userCollection.doc(uid).collection('uploads').doc(uid).set({
      'fileurl': fileUrl,
      'name': filename,
      'time': DateTime.now(),
    });
  }
}
