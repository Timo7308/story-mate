import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  late String loggedInUserId = ""; // Variable to store the logged-in userid
  late String secondUserId = ""; // Variable to store the second user's userid

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

    // Fetch and print the userId when the page initializes
    fetchAndPrintUserId();

    // Start the animation
    _animationController.repeat();
  }

  Future<void> fetchAndPrintUserId() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Assuming you store the userid in the Firebase user object
      setState(() {
        loggedInUserId = user.uid;
      });
      print('Logged-in user ID: $loggedInUserId');

      // Fetch the userid for another online user
      await fetchSecondUser();
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
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Selected Choice ID: ${widget.selectedChoiceId}',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Logged-in User ID: $loggedInUserId', // Display the loggedInUserId
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Second User ID: $secondUserId', // Display the secondUserId
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
