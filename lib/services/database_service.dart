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

  // Get user Groups:
  getUserGroups() async {
    return usersCollection.doc(uid).snapshots();
  }

  // Creating the Group:

  // id : is the user id:
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupsCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId":
          "", // This will be generate after the execution of this method so we have to update this after this method
      "recentMessage": "",
      "recentMessageSender": ""
    });

    // Update the members:
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    // Update the group in Users Collections Also:
    DocumentReference userDocumentReference = usersCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // getting the Chats;
  getChat(String groupId) async {
    return groupsCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  // getting the group Admin:
  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupsCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group Members:
  getGroupMembers(String groupId) async {
    return groupsCollection.doc(groupId).snapshots();
  }
}
