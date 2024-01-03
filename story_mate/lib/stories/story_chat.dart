import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoryChatPage extends StatefulWidget {
  @override
  _StoryChatPageState createState() => _StoryChatPageState();
}

class _StoryChatPageState extends State<StoryChatPage> {
  final List<types.Message> messages = [];
  final TextEditingController _textController = TextEditingController();
  final String apiKey = "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"; // Replace with your actual API key

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
  }

  void _addInitialMessage() {
    final initialMessage = types.TextMessage(
      author: types.User(id: 'ai-id'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: 'initial-message-id',
      text: "Ahoy! I'm the Pirate AI, ready to chat!",
    );
    messages.add(initialMessage);
  }

  void _handleSendPressed() async {
    final userText = _textController.text.trim();
    if (userText.isEmpty) return;

    _sendMessage(userText, 'user-id'); // Send user message
    _textController.clear();
    await _getResponse(userText);
  }

  void _sendMessage(String text, String authorId) {
    final message = types.TextMessage(
      author: types.User(id: authorId),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
    );
    setState(() => messages.insert(0, message));
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
            user: const types.User(id: 'user-id'),
            theme: _buildChatTheme(),
            showUserNames: true,
            customBottomWidget: _buildInputField(),
            onSendPressed: (PartialText) {},
          ),
        ),
      ],
    );
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
            onPressed: _handleSendPressed,
          ),
        ],
      ),
    );
  }
}





