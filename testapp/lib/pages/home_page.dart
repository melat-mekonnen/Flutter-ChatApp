import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:testapp/models/user_profile.dart';
import 'package:testapp/pages/chat_page.dart';
import 'package:testapp/services/auth_service.dart';
import 'package:testapp/services/databse_service.dart';
import 'package:testapp/services/navigation_service.dart';
import 'package:testapp/services/alert_service.dart';
import 'package:testapp/widgets/chat_tile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
              onPressed: () async {
                bool result = await _authService.logOut();
                if (result) {
                  _alertService.showToast(
                    text: "You have been logged out successfully",
                    icon: Icons.check,
                  );
                  _navigationService.pushReplacementNamed("/login");
                }
              },
              color: Colors.red,
              icon: const Icon(Icons.logout))
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 20.0,
      ),
      child: _chatList(),
    ));
  }

  Widget _chatList() {
    return StreamBuilder(
        stream: _databaseService.getUserProfiles(),
        builder: (context, snapshot) {
          //If an error occurs, display error message
          if (snapshot.hasError) {
            return const Center(
              child: Text("Unable to load data."),
            );
          }

          //If the snapshot has data and the data is not null, display the chat list
          if (snapshot.hasData && snapshot.data != null) {
            final listOfUsers = snapshot.data!.docs;
            return ListView.builder(
                itemCount: listOfUsers.length,
                itemBuilder: (context, index) {
                  UserProfile user = listOfUsers[index].data();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ChatTile(
                        userProfile: user,
                        onTap: () async {
                          final chatExists =
                              await _databaseService.checkChatExists(
                                  _authService.user!.uid, user.uid!);
                          if (!chatExists) {
                            await _databaseService.createNewChat(
                                _authService.user!.uid, user.uid!);
                          }

                          _navigationService.push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ChatPage(chatUser: user);
                              },
                            ),
                          );

                        }),
                  );
                });
          }

          //Normally display a loading screen
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
