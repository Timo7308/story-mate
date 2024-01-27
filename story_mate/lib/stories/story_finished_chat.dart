import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:story_mate/profile/profile_chat_partner.dart';
import 'package:story_mate/stories/story_finished_chat.dart';
import 'package:flutter/material.dart';
import 'package:story_mate/stories/story_choice.dart';  // Import the StoryChoiceScreen or replace it with the actual destination page

class StoryFinishedChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Story Ended'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You left the story.',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);  // Pop the current screen (StoryFinishedChatScreen)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChoicePage()),
                );  // Push the StoryChoiceScreen
              },
              child: Text('Back to Story Choice page'),
            ),
          ],
        ),
      ),
    );
  }
}