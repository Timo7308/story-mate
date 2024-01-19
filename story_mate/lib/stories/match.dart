import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class MatchPage extends StatefulWidget {
  final String selectedChoiceId;

  MatchPage({required this.selectedChoiceId});

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late String loggedInUserId = "";
  late String secondUserId = "";

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _onlineUsersSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

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
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      // Handle updates to the online user list
      print('Online users updated: ${snapshot.docs.map((doc) => doc.id).toList()}');
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
    } else {
      // No matching second user found
      setState(() {
        secondUserId = '';
      });
      print('No matching second user found.');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When the app is resumed, refetch online users
      fetchAndPrintUserId();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _onlineUsersSubscription.cancel();
    WidgetsBinding.instance?.removeObserver(this);
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