import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections:
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupsCollection =
      FirebaseFirestore.instance.collection('groups');

  // Updating the user data:

  Future saveUserDataInDatabase(
      String fullName, String email, String password) async {
    return await usersCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profile_pic": "",
      "uid": uid,
      "password": password
    });
  }

  // Saving the User Data:
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    return snapshot;
  }
}
