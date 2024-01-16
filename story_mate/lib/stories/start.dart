import 'package:flutter/material.dart';
import 'story_chat.dart';

class StartPage extends StatelessWidget {
  final String userId;

  StartPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Journeys'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            // Navigate to the chat page when the rectangle is clicked
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StoryChatPage(
                  userId: 'user1',
                  partnerUserId: 'user2', // You need to set the partner's ID here
                ),
              ),
            );
          },
          child: Container(
            width: 400.0, // Set the width as needed
            height: 100.0, // Set the height as needed
            color: Colors.blue, // Set the color as needed
            child: Center(
              child: Text(
                'Pirate Story',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to another page when the button is pressed
          // For now, let's just print the user ID
          print('Current User ID: $userId');
        },
        child: const Icon(Icons.navigate_next), // Icon for the button
      ),
    );
  }
}

