import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sixcore/Models/db_refs.dart';
import 'package:sixcore/Models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  final User? _user = FirebaseAuth.instance.currentUser;

  QueryDocumentSnapshot<UserProfile>? _userProfile;

  Future<QueryDocumentSnapshot<UserProfile>?> get userProfile async {
    if (_user == null) {
      return null;
    }

    if (_userProfile != null) {
      return _userProfile;
    }

    List<QueryDocumentSnapshot<UserProfile>> p = await DbRefs.userProfileRef
        .where('userId', isEqualTo: _user?.uid)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs);

    _userProfile = p.first;

    return _userProfile;
  }

  User? get currentUser => _user;
  String? get usersName => _user?.displayName;
}
