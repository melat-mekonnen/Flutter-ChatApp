import "package:cloud_firestore/cloud_firestore.dart";
import "package:get_it/get_it.dart";
import "package:testapp/models/user_profile.dart";
import "package:testapp/services/auth_service.dart";

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _usersCollection;

  late AuthService _authService;
  final GetIt _getIt = GetIt.instance;

  //Constructor
  DatabaseService() {
    _setupCollectionReferences();
    _authService = _getIt.get<AuthService>();
  }

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

  //Function to read all the users data except the one logged in
  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    return _usersCollection
        ?.where("uid", isNotEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  


}
