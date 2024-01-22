import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:story_mate/stories/story_chat.dart';

class MatchPage extends StatefulWidget {
  final String selectedChoiceId;

  MatchPage({required this.selectedChoiceId});

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late String loggedInUserId = "";
  late String secondUserId = "";
  late String chatId = ""; // New variable to store the chatId

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
  _onlineUsersSubscription;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    fetchAndPrintUserId();

    _animationController.repeat();
  }

  Future<void> fetchAndPrintUserId() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        loggedInUserId = user.uid;
      });
      print('Logged-in user ID: $loggedInUserId');

      // Fetch the userid for another online user
      await fetchSecondUser();

      // Subscribe to online user updates
      subscribeToOnlineUsers();
    } else {
      print('No user is currently logged in');
    }
  }

  Future<void> fetchSecondUser() async {
    // Delay to ensure that the login process is complete
    await Future.delayed(Duration(seconds: 2));

    DocumentSnapshot? secondUserSnapshot = await getRandomOnlineUser();

    if (secondUserSnapshot != null) {
      setState(() {
        secondUserId = secondUserSnapshot.id;
      });
      print('Second user ID: $secondUserId');

      // Generate chatId
      generateChatId();

      // Navigate to the chat page
      navigateToChatPage();
    } else {
      print('No matching second user found.');
    }
  }


  Future<DocumentSnapshot?> getRandomOnlineUser() async {
    // Query users based on the criteria
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('loginStatus', isEqualTo: 'online')
        .where('status', isEqualTo: 0) // To make sure the user is not assigned to any room
        .limit(1) // Limit to 1 document
        .get();

    // Check if there are any matching users
    if (querySnapshot.docs.isNotEmpty) {
      // Select the first (and only) document
      return querySnapshot.docs.first;
    } else {
      return null;
    }
  }

  void subscribeToOnlineUsers() {
    // Subscribe to updates on the online users collection
    _onlineUsersSubscription = FirebaseFirestore.instance
        .collection('users')
        .where('loginStatus', isEqualTo: 'online')
        .where('status', isEqualTo: 0)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      // Handle updates to the online user list
      print(
          'Online users updated: ${snapshot.docs.map((doc) => doc.id).toList()}');
      // Update the second user ID
      updateSecondUserId(snapshot);
    });
  }

  void updateSecondUserId(QuerySnapshot<Map<String, dynamic>> snapshot) {
    // Get the ID of the currently logged-in user
    String loggedInUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Exclude the logged-in user
    List<String> onlineUsers = snapshot.docs
        .map((doc) => doc.id)
        .where((userId) => userId != loggedInUserId)
        .toList();

    if (onlineUsers.isNotEmpty) {
      setState(() {
        secondUserId = onlineUsers.first;
      });
      print('Updated Second user ID: $secondUserId');

      // Check if both users are found, then generate chatId and navigate to the chat page
      if (loggedInUserId.isNotEmpty && secondUserId.isNotEmpty) {
        generateChatId();
        navigateToChatPage();
      }
    } else {
      // No matching second user found
      setState(() {
        secondUserId = '';
      });
      print('No matching second user found.');
    }
  }

  void generateChatId() {
    // Generate a chatId based on user IDs
    List<String> sortedUserIds = [loggedInUserId, secondUserId]..sort();
    chatId = sortedUserIds.join('_');
    print('Generated Chat ID: $chatId');
  }


  Future<void> navigateToChatPage() async {
    // Navigate to the chat page
    await Future.delayed(Duration(seconds: 3));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryChatPage(
          // Pass necessary information to the chat page
          loggedInUserId: loggedInUserId,
          secondUserId: secondUserId,
          chatId: chatId, // Pass the chatId to the chat page
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _onlineUsersSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 0),
        child: AppBar(
          automaticallyImplyLeading: false,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/SearchImage.png',
                width: 300.0,
                height: 300.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Connecting you...',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Selected Choice ID: ${widget.selectedChoiceId}',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Logged-in User ID: $loggedInUserId',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Second User ID: $secondUserId',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 30.0),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value * 2 * 3.14,
                  child: Image.asset(
                    'assets/LoadingCircle.png',
                    width: 50.0,
                    height: 50.0,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
