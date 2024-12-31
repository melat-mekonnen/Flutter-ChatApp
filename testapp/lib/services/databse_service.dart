import "package:cloud_firestore/cloud_firestore.dart";
import "package:get_it/get_it.dart";
import "package:testapp/models/chat.dart";
import "package:testapp/models/message.dart";
import "package:testapp/models/user_profile.dart";
import "package:testapp/services/auth_service.dart";
import "package:testapp/utils.dart";

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _usersCollection;
  CollectionReference? _chatCollection;

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
    _chatCollection = _firebaseFirestore.collection("Chat").withConverter<Chat>(
          fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
          toFirestore: (chat, _) => chat.toJson(),
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

  //Function to check if a chat between 2 users already exists
  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatId = generateChatId(uid1, uid2);

    final result = await _chatCollection?.doc(chatId).get();

    if (result != null) {
      return result.exists;
    }

    return false;
  }

  //Function to create a new chat between 2 users

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatId = generateChatId(uid1, uid2);

    // Creates a reference to the Firestore document for the given chatId.
    final docRef = _chatCollection!.doc(chatId);

    final newChat = Chat(id: chatId, participants: [uid1, uid2], messages: []);

    await docRef.set(newChat);
  }

  //Function to save the message to the database

  Future<void> sendChatmessage(
      String uid1, String uid2, Message message) async {
    String chatId = generateChatId(uid1, uid2);
    final docRef = _chatCollection!.doc(chatId);
    await docRef.update(
      {
        "messages": FieldValue.arrayUnion(
          [
            message.toJson(),
          ],
        ),
      },
    );
  }

  //Function to get the chat from db

   Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) {
    String chatId = generateChatId(uid1, uid2);
    return _chatCollection?.doc(chatId).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }
}
