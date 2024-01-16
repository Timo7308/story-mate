import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';


class StoryChatPage extends StatefulWidget {
  final String userId;
  final String partnerUserId;

  const StoryChatPage({
    super.key,
    required this.userId,
    required this.partnerUserId
  });

  @override
  _StoryChatPageState createState() => _StoryChatPageState();
}

class _StoryChatPageState extends State<StoryChatPage> {
  final List<types.Message> messages = [];
  final TextEditingController _textController = TextEditingController();
  final String apiKey = "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"; // Replace with your actual API key
  late String chatRoomId;

  @override
  void initState() {
    super.initState();
    chatRoomId = generateChatRoomId(widget.userId, widget.partnerUserId);
    _addInitialMessages();
    _listenForMessages();
  }

  String generateChatRoomId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();  // Sort the list in place
    return ids.join('_');  // Join the sorted IDs with an underscore and return
  }

  void _listenForMessages() {
    DatabaseReference messagesRef = FirebaseDatabase.instance.ref('chats/$chatRoomId/messages');
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

  void _addInitialMessages() {

  }


  void _handleSendPressed() async {
    final userText = _textController.text.trim();
    if (userText.isEmpty) return;

    _sendMessage(userText, widget.userId);
    _textController.clear();
    await _getResponse(userText);
  }

  void _sendMessage(String text, String senderId) async {
    // Reference to the messages in the specific chat room
    DatabaseReference messagesRef = FirebaseDatabase.instance.ref('chats/$chatRoomId/messages');

    // Generating a unique ID for the message within this chat room
    String messageId = messagesRef.push().key ?? 'default-id';

    // Set the message data in the chat room
    await messagesRef.child(messageId).set({
      'senderId': senderId,
      'text': text,
      'timestamp': ServerValue.timestamp, // Uses Firebase server's timestamp
    }).catchError((error) {
      // Handle any errors here
      print('Error sending message: $error');
    });
  }

  Future<void> _getResponse(String userText) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/engines/davinci/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({'prompt': userText, 'max_tokens': 150}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final aiText = data['choices'][0]['text'].trim();
      _sendMessage(aiText, 'ai-id'); // Send AI response
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
    return AppBar(
      leading: _buildBackButton(),
      title: const Text('Pirate Story'),
      actions: [_buildProfileButton()],
    );
  }

  IconButton _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_outlined),
      onPressed: () {
        Navigator.maybePop(context);
      },
    );
  }

  IconButton _buildProfileButton() {
    return IconButton(
      padding: const EdgeInsets.only(right: 15),
      icon: const Icon(Icons.account_circle, size: 35),
      onPressed: () {
        // Navigate to profile page...
      },
    );
  }

  Column _buildChatBody() {
    return Column(
      children: [
        Expanded(
          child: Chat(
            messages: messages,
            user: types.User(id: widget.userId),
            theme: _buildChatTheme(),
            showUserNames: true,
            customBottomWidget: _buildInputField(),
            onSendPressed: (types.PartialText message) {
              _handleSendPressed();
            },
            customMessageBuilder: (message, {required int messageWidth}) {
              return _buildMessage(message);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(types.Message message) {
    if (message is types.TextMessage) {
      final isUser = message.author.id == widget.userId;
      final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
      final backgroundColor = isUser
          ? Theme.of(context).primaryColor
          : Colors.grey[300];
      final textColor = isUser ? Colors.white : Colors.black;

      return Container(
        alignment: alignment,
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message.text ?? '',
            style: TextStyle(color: textColor),
          ),
        ),
      );
    } else {
      // Handle other message types or return an empty container
      return Container();
    }
  }

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
            onPressed: () => _handleSendPressed(),
          ),
        ],
      ),
    );
  }
}



