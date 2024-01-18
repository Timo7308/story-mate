import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchPage extends StatefulWidget {
  final String selectedChoiceId;

  MatchPage({required this.selectedChoiceId});

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late String userId = ""; // Variable to store the userid

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

    // Fetch and print the userid when the page initializes
    fetchAndPrintUserId();

    // Start the animation
    _animationController.repeat();
  }

  Future<void> fetchAndPrintUserId() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Assuming you store the userid in the Firebase user object
      userId = user.uid;
      print('Logged-in user ID: $userId');
    } else {
      print('No user is currently logged in');
    }
  }

  Future<DocumentSnapshot?> getRandomOnlineUser() async {
    // Query users based on the criteria
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('loginStatus', isEqualTo: 'online')
        .where('status', isEqualTo: 1)
        //.where('id', isNotEqualTo: userId)
        .get();

    // Check if there are any matching users
    if (querySnapshot.docs.isNotEmpty) {
      // Select a random user
      final int randomIndex = Random().nextInt(querySnapshot.docs.length);
      return querySnapshot.docs[randomIndex];
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
              style: Theme.of(context).textTheme.display1,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Selected Choice ID: ${widget.selectedChoiceId}',
              style: Theme.of(context).textTheme.body1,
            ),
            const SizedBox(height: 10.0),
            FutureBuilder<DocumentSnapshot?>(
              future: getRandomOnlineUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    // Display the selected user's ID
                    return Text(
                      'Selected User ID: ${snapshot.data!['id']}',
                      style: Theme.of(context).textTheme.body1,
                    );
                  } else {
                    return Text('No matching users found.');
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
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
