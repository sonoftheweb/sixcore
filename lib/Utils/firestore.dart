import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sixcore/Models/db_refs.dart';

import '../Models/user_profile.dart';

class CloudFirestore {
  Future<List<QueryDocumentSnapshot<UserProfile>>?> getProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return null;
    }

    List<QueryDocumentSnapshot<UserProfile>> userProfile = await DbRefs
        .userProfileRef
        .where('userId', isEqualTo: currentUser.uid)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs);

    return userProfile;
  }
}
