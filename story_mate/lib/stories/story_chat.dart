import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:story_mate/profile/profile_chat_partner.dart';
import 'package:story_mate/stories/story_finished_chat.dart';

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

  String tellAStoryMessage = '';
  String aiBeginningText = '';

  @override
  void initState() {
    super.initState();
    _listenForMessages();
    _tellAStoryOnPageLoad(); // call the method when the page loads
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchBeginningResponse();
  }

  Future<void> _fetchBeginningResponse() async {
    if (aiBeginningText.isEmpty) {
      // Fetch beginning response only if it hasn't been fetched before
      aiBeginningText = await _getBeginningResponse(tellAStoryMessage);
      final systemMessage = types.SystemMessage(
        id: 'system_message', // You can use a unique identifier for system messages
        text: aiBeginningText,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      messages.insert(0, systemMessage);
      setState(() {}); // Trigger a rebuild after fetching
    }
  }

  // // new method to handle "Tell a story" on page load
  // void _tellAStoryOnPageLoad() async {

  //   tellAStoryMessage = 'What is a Pirate?';
  //   // if(widget.storyTitle == "A Pirate Tale"){
  //   //   tellAStoryMessage = 'What is a Pirate?';
  //   // }
  //   // if(widget.storyTitle == "A Zombie Apocalypse"){
  //   //   tellAStoryMessage = 'What is a Zombie?';
  //   // }
  //   await _getBeginningResponse(tellAStoryMessage); // empty dynamicPrompt
  // }

  void _tellAStoryOnPageLoad() async {
    // Pirate tale
    if (widget.storyTitle == "A Pirate Tale") {
      tellAStoryMessage = 'What is a Pirate?';
    }
    // Space Adventure
    else if (widget.storyTitle == "A Space Adventure") {
      tellAStoryMessage = 'What is a Space?';
    }
    // Medieval Story
    else if (widget.storyTitle == "A Medieval Story") {
      tellAStoryMessage = 'What is a Medieval?';
    }
    // Fairy Tale
    else if (widget.storyTitle == "A Fairy Tale") {
      tellAStoryMessage = 'What is a Fairy?';
    }
    // Zombie Apocalypse
    else if (widget.storyTitle == "A Zombie Apocalypse") {
      tellAStoryMessage = 'What is a Zombie?';
    }
    aiBeginningText = await _getBeginningResponse(tellAStoryMessage);
  }

  // // new button widget for "Tell a story"
  // IconButton _buildTellAStoryButton() {
  //   return IconButton(
  //     icon: const Icon(Icons.book),
  //     onPressed: _tellAStoryPressed,
  //   );
  // }

  void _finishChat() {
    // Clear the local messages list
    messages.clear();

    // Clear the text input field
    _textController.clear();

    // Update the state
    setState(() {});

    // Clear messages in Firebase Realtime Database
    DatabaseReference chatRef =
        FirebaseDatabase.instance.ref('chats/${widget.chatId}');
    DatabaseReference messagesRef = chatRef.child('messages');
    messagesRef.remove(); // Remove all messages from the current chat

    // Close the current chat screen
    Navigator.of(context).pop();

    // Navigate to the "StoryFinishedChatScreen" defined in story_finished_chat.dart
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => StoryFinishedChatScreen(),
      ),
    );
  }

  void _listenForMessages() {
    DatabaseReference chatRef =
        FirebaseDatabase.instance.ref('chats/${widget.chatId}');
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
    if (widget.storyTitle == "A Pirate Tale") {
      dynamicPrompt =
          'Convert this message into a short part (50 words) of the a story which is "Pirate tale" themed. The purpose of this story is knowing each other. Do not repeat what the I say. Do not mention any proper names in the content. Put the content of the message in the story and If there are any questions, put them into the story in a question format too: ' +
              userText;
      //dynamicPromptForBeginning = 'What is the result of 1 plus 3?';
    }
    // Space Adventure
    else if (widget.storyTitle == "A Space Adventure") {
      dynamicPrompt =
          'Stylize the following message to fit into the context of a space adventure, keep it first person: ' +
              userText;
      //dynamicPromptForBeginning = '';
    }
    // Medieval Story
    else if (widget.storyTitle == "A Medieval Story") {
      dynamicPrompt =
          'Convert this message into a short part (50 words) of the a story which is "Medieval Story" themed. The purpose of this story is knowing each other. Do not repeat what the I say. Do not mention any proper names in the content. Put the content of the message in the story and If there are any questions, put them into the story in a question format too: ' +
              userText;
      //dynamicPromptForBeginning = '';
    }
    // Fairy Tale
    else if (widget.storyTitle == "A Fairy Tale") {
      dynamicPrompt =
          'Stylize the following message to fit into the context of a fairy tale, keep it first person: ' +
              userText;
      //dynamicPromptForBeginning = '';
    }
    // Zombie Apocalypse
    else if (widget.storyTitle == "A Zombie Apocalypse") {
      dynamicPrompt =
          'Convert this message into a short part (50 words) of the a story which is "Zombie Apocalypse" themed. The purpose of this story is knowing each other. Do not repeat what the I say. Do not mention any proper names in the content. Put the content of the message in the story and If there are any questions, put them into the story in a question format too: ' +
              userText;
      //dynamicPromptForBeginning = '';
    }
    print('Dynamic Prompt: $dynamicPrompt');

    _sendMessage(userText, widget.loggedInUserId, widget.chatId);
    _textController.clear();
    await _getResponse(userText, dynamicPrompt);
  }

  Future<String> _getBeginningResponse(String tellAStoryMessage) async {
    final apiKey =
        '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'; // Replace with your actual API key
    final endpoint = 'https://api.openai.com/v1/chat/completions';

    // Construct the messages list based on the selected story
    final messages = [
      {'role': 'user', 'content': tellAStoryMessage},
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
    if (true) {
      final data = jsonDecode(response.body);
      final aiBeginningText = data['choices'][0]['message']['content'].trim();
      return aiBeginningText;
    }
  }

  Future<void> _getResponse(String userText, String dynamicPrompt) async {
    final apiKey =
        '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'; // Replace with your actual API key
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

      _sendMessage(
          aiText, widget.loggedInUserId, widget.chatId); // Send AI response
    } else {
      print('Error of OpenAI API');
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

  // AppBar _buildAppBar() {
  //   print('Story Title: ${widget.storyTitle}');
  //   return AppBar(
  //     leading: _buildBackButton(),
  //     title: Text(widget.storyTitle),
  //     actions: [
  //       _buildProfileButton(),
  //     ],
  //   );
  // }

  AppBar _buildAppBar() {
    print('Story Title: ${widget.storyTitle}');
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(widget.storyTitle),
      actions: [
        _buildFinishChatButton(),
        _buildProfileButton(),
      ],
    );
  }

  IconButton _buildFinishChatButton() {
    return IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: () {
        _showFinishChatDialog();
      },
    );
  }

  // IconButton _buildBackButton() {
  //   return IconButton(
  //     icon: const Icon(Icons.arrow_back_ios_new_outlined),
  //     onPressed: () {
  //       Navigator.maybePop(context);
  //     },
  //   );
  // }

  IconButton _buildProfileButton() {
    return IconButton(
      padding: const EdgeInsets.only(right: 15),
      icon: const Icon(Icons.account_circle, size: 35),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileChatPartner(secondUserId: widget.secondUserId),
          ),
        );
      },
    );
  }

  void _showFinishChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Leaving the story'),
          content: Text('Are you sure you want to leave the story?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Implement logic to finish the chat and navigate back
                Navigator.of(context).pop(); // Close the dialog
                _finishChat();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
// void _finishChat() {

//   // Close the current chat screen
//   Navigator.of(context).pop();

//   // Navigate back to the "story_choice.dart" screen
//   Navigator.pushReplacementNamed(context, '/story_choice.dart');
// }

// new chat body scheme including beginning of the stories

  Column _buildChatBody() {
    return Column(
      children: [
        if (aiBeginningText
            .isNotEmpty) // Check if AI beginning text is available
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // child: StoryTextSection(text: aiBeginningText),
            ),
          ),
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
              } else if (message is types.SystemMessage) {
                return _buildSystemMessage(message as types.SystemMessage);
              }
              return _buildDefaultMessageContainer(message, messageWidth);
            },
          ),
        ),
      ],
    );
  }

// Column _buildChatBody() {
//   return Column(
//     children: [
//       Align(
//         alignment: Alignment.topLeft,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: StoryTextSection(text: aiBeginningText ?? ""),
//         ),
//       ),
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

  Widget _buildCustomTextMessage(types.TextMessage message, int messageWidth) {
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

  Widget _buildSystemMessage(types.SystemMessage message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StoryTextSection(text: message.text),
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
      // decoration: BoxDecoration(
      //   color: Colors.green, // You can customize the color
      //   borderRadius: BorderRadius.circular(8.0),
      // ),
      child: Text(
        text,
        style: TextStyle(color: Color(0xFF0A2342)),
      ),
    );
  }
}
