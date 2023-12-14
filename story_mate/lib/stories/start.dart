import 'package:flutter/material.dart';
import 'story_chat.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Journeys'),
      ),
      body: const Center(
        child: Text('Random connection or choose story'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to another page when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StoryChatPage()), // Replace 'NextPage' with your destination page class
          );
        },
        child: const Icon(Icons.navigate_next), // Icon for the button
      ),
    );
  }
}

