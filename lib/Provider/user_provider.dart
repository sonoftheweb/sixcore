import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sixcore/Models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  User? _user = FirebaseAuth.instance.currentUser;
  final _profileRef = FirebaseFirestore.instance
      .collection('userProfile')
      .withConverter<UserProfile>(
        fromFirestore: (snapshot, _) => UserProfile.fromJson(snapshot.data()!),
        toFirestore: (userProfile, _) => userProfile.toJson(),
      );

  List<QueryDocumentSnapshot<UserProfile>>? _userProfile;

  Future<List<QueryDocumentSnapshot<UserProfile>>?> get userProfile async {
    if (_user == null) {
      return null;
    }

    if (_userProfile != null) {
      return _userProfile;
    }

    _userProfile = await _profileRef
        .where('userId', isEqualTo: _user?.uid)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs);

    return _userProfile;
  }

  User? get currentUser => _user;
}
