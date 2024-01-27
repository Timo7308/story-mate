import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:story_mate/profile/profile_chat_partner.dart';

class StoryChatPage extends StatefulWidget {
  final String loggedInUserId;
  final String secondUserId;
  final String chatId;
  final String storyTitle; // Add a variable to store the story title

  StoryChatPage({
    required this.loggedInUserId,
    required this.secondUserId,
    required this.chatId,
    required this.storyTitle,
  });

  @override
  _StoryChatPageState createState() => _StoryChatPageState();
}

class _StoryChatPageState extends State<StoryChatPage> {
  final List<types.Message> messages = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listenForMessages();
  }

  void _listenForMessages() {
    DatabaseReference chatRef = FirebaseDatabase.instance.ref('chats/${widget.chatId}');
    DatabaseReference messagesRef = chatRef.child('messages');

    messagesRef.onChildAdded.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final newMessage = types.TextMessage(
        author: types.User(id: data['senderId']),
        createdAt: data['timestamp'],
        id: event.snapshot.key ?? 'unknown-id',
        text: data['text'],
      );
      setState(() {
        messages.insert(0, newMessage);
      });
    });
  }

  void _sendMessage(String text, String senderId, String chatId) async {
    DatabaseReference chatRef = FirebaseDatabase.instance.ref('chats/$chatId');
    DatabaseReference messagesRef = chatRef.child('messages');

    await messagesRef.push().set({
      'senderId': senderId,
      'text': text,
      'timestamp': ServerValue.timestamp,
    }).catchError((error) {
      print('Error sending message: $error');
    });
  }

  Future<void> _handleSendPressed(types.PartialText text) async {
    final userText = text.text.trim();
    if (userText.isEmpty) return;

    // Add your logic for dynamicPrompt here

    String dynamicPrompt = '';
    // dynamicPrompt should be changed based on the selected story

    //final dynamicPrompt = 'Convert this message into a short part (50 words) of the a story which is "Pirate" themed. The purpose of this story is knowing each other. Do not repeat what the I say. Do not mention any proper names in the content. Put the content of the message in the story and If there are any questions, put them into the story in a question format too: ' + userText;

    // Pirate tale
     if (widget.storyTitle == "A Pirate Tale"){
       dynamicPrompt = 'Convert this message into a short part (50 words) of the a story which is "Pirate tale" themed. The purpose of this story is knowing each other. Do not repeat what the I say. Do not mention any proper names in the content. Put the content of the message in the story and If there are any questions, put them into the story in a question format too: ' + userText;
       //dynamicPromptForBeginning = '';
     }
    // Space Adventure
     else if(widget.storyTitle == "A Space Adventure"){
       dynamicPrompt = 'Convert this message into a short part (50 words) of the a story which is "Space Adventure" themed. The purpose of this story is knowing each other. Do not repeat what the I say. Do not mention any proper names in the content. Put the content of the message in the story and If there are any questions, put them into the story in a question format too: ' + userText;
       //dynamicPromptForBeginning = '';
     }
    // Medieval Story
     else if(widget.storyTitle == "A Medieval Story"){
       dynamicPrompt = 'Convert this message into a short part (50 words) of the a story which is "Medieval Story" themed. The purpose of this story is knowing each other. Do not repeat what the I say. Do not mention any proper names in the content. Put the content of the message in the story and If there are any questions, put them into the story in a question format too: ' + userText;
       //dynamicPromptForBeginning = '';
     }
    // Fairy Tale
     else if(widget.storyTitle == "A Fairy Tale"){
       dynamicPrompt = 'Convert this message into a short part (50 words) of the a story which is "Fairy Tale" themed. The purpose of this story is knowing each other. Do not repeat what the I say. Do not mention any proper names in the content. Put the content of the message in the story and If there are any questions, put them into the story in a question format too: ' + userText;
       //dynamicPromptForBeginning = '';
     }
    // Zombie Apocalypse
     else if(widget.storyTitle == "A Zombie Apocalypse"){
       dynamicPrompt = 'Convert this message into a short part (50 words) of the a story which is "Zombie Apocalypse" themed. The purpose of this story is knowing each other. Do not repeat what the I say. Do not mention any proper names in the content. Put the content of the message in the story and If there are any questions, put them into the story in a question format too: ' + userText;
       //dynamicPromptForBeginning = '';
     }
    print('Dynamic Prompt: $dynamicPrompt');

    _sendMessage(userText, widget.loggedInUserId, widget.chatId);
    await _getResponse(userText,dynamicPrompt);
  }
  Future<void> _getResponse(String userText, String dynamicPrompt) async {
    final apiKey = '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'; // Replace with your actual API key
    final endpoint = 'https://api.openai.com/v1/chat/completions';

    // Construct the messages list based on the selected story
    final messages = [
      {'role': 'user', 'content': userText},
      {'role': 'assistant', 'content': dynamicPrompt},
    ];


    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo-1106',
        'messages': messages,
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final aiText = data['choices'][0]['message']['content'].trim();
      _sendMessage(aiText, 'ai-id', widget.chatId); // Send AI response
    } else {
      // Handle error...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildChatBody(),
    );
  }

  AppBar _buildAppBar() {
    print('Story Title: ${widget.storyTitle}');
    return AppBar(
        automaticallyImplyLeading: false,
      title: Text(widget.storyTitle),
      actions: [_buildProfileButton()],
    );
  }

  IconButton _buildProfileButton() {
    return IconButton(
      padding: const EdgeInsets.only(right: 15),
      icon: const Icon(Icons.account_circle, size: 35),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileChatPartner(secondUserId: widget.secondUserId),
          ),
        );

      },
    );
  }

// new chat body scheme including beginning of the stories
  Column _buildChatBody() {
    return Column(
      children: [
        Expanded(
          child: Chat(
            messages: messages,
            user: types.User(id: widget.loggedInUserId),
            theme: _buildChatTheme(),
            showUserNames: true,
            customBottomWidget: _buildInputField(),
            onSendPressed: _handleSendPressed,
            customMessageBuilder: (message, {required int messageWidth}) {
              if (message is types.TextMessage) {
                return _buildCustomTextMessage(
                    message as types.TextMessage, messageWidth);
              }
              return _buildDefaultMessageContainer(message, messageWidth);
            },
          ),
        ),
       // StoryTextSection(text: 'Beginning of the Stories'),
      ],
    );
  }

  // Column _buildChatBody() {
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: Chat(
  //           messages: messages,
  //           user: types.User(id: widget.loggedInUserId),
  //           theme: _buildChatTheme(),
  //           showUserNames: true,
  //           customBottomWidget: _buildInputField(),
  //           onSendPressed: _handleSendPressed,
  //           customMessageBuilder: (message, {required int messageWidth}) {
  //             if (message is types.TextMessage) {
  //               return _buildCustomTextMessage(
  //                   message as types.TextMessage, messageWidth);
  //             }
  //             return _buildDefaultMessageContainer(message, messageWidth);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  DefaultChatTheme _buildChatTheme() {
    return DefaultChatTheme(
      primaryColor: const Color(0xFF0A2342),
      secondaryColor: Colors.teal,
      dateDividerTextStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
      inputTextDecoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
        hintText: "Type a message",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF0A2342)),
            onPressed: () => _handleSendPressed(
                types.PartialText(text: _textController.value.text)),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextMessage(
      types.TextMessage message, int messageWidth) {
    return Container(
      alignment: message.author.id == widget.loggedInUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: message.author.id == widget.loggedInUserId
              ? Colors.blue
              : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDefaultMessageContainer(
      types.CustomMessage message, int messageWidth) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        'Unsupported message type',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

// shows the beginning of the stories
class StoryTextSection extends StatelessWidget {
  final String text;

  StoryTextSection({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.green, // You can customize the color
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
