import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/user_profile.dart';

class CloudFirestore {
  Future<List<QueryDocumentSnapshot<UserProfile>>?> getProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return null;
    }

    final profileRef = FirebaseFirestore.instance
        .collection('userProfile')
        .withConverter<UserProfile>(
          fromFirestore: (snapshot, _) =>
              UserProfile.fromJson(snapshot.data()!),
          toFirestore: (userProfile, _) => userProfile.toJson(),
        );
    List<QueryDocumentSnapshot<UserProfile>> userProfile = await profileRef
        .where('userId', isEqualTo: currentUser.uid)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs);

    return userProfile;
  }
}
