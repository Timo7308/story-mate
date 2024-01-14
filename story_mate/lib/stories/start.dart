import 'package:flutter/material.dart';
import 'match.dart';
import 'package:story_mate/profile/profile_check.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Journeys'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 40.0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckProfile()),
              );
              // Add functionality for profile button
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Opacity(
                  opacity: 0.5, // 50% opacity
                  child: Image.asset(
                    'assets/HomeImage.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Ready, Set, Go!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Click the big button below to start your first chat or find out how it works.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  // Add functionality for "How It Works?" button
                },
                child: Text(
                  'How It Works?',
                  style: TextStyle(
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 380.0,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchPage(),
              ),
            );
          },
          label: Row(
            children: [
              Text('New Adventure'),
              Icon(Icons.shuffle),
            ],
          ),
        ),
      ),
    );
  }
}
