import "package:cloud_firestore/cloud_firestore.dart";
import "package:testapp/models/user_profile.dart";


class DatabaseService {
  DatabaseService() {
    _setupCollectionReferences();
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _usersCollection;

  void _setupCollectionReferences() {
    _usersCollection =
        _firebaseFirestore.collection("Users").withConverter<UserProfile>(
              fromFirestore: (snapshots, _) =>
                  UserProfile.fromJson(snapshots.data()!),
              toFirestore: (userProfile, _) => userProfile.toJson(),
            );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    _usersCollection?.doc(userProfile.uid).set(userProfile);
  }
}
