import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Example of a destination page class
// class StoryChatPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pirate Story'),
//       ),
//       body: Center(
//         child: Text('Welcome to the Pirate Story chat page!'),
//       ),
//       MyHomePage(),
//     );
//   }
// }

class StoryChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textInputController = TextEditingController();
  String _response = "";

  Future<void> _sendMessage() async {
    final String apiKey = "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";
    final String inputText = _textInputController.text;
    final String resultText = "Rewrite the following sentence/question just like pirate's converation in stories: " + inputText;


    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'), 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'text-davinci-003', // Use "text-davinci-003" engine ver
          'prompt': resultText,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _response = data['choices'][0]['text'];
        });
      } else {
        setState(() {
          _response = 'Error: ${response.statusCode}, ${response.body}';
        });
      }
    } catch (error) {
      setState(() {
        _response = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pirate Story'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textInputController,
              decoration: InputDecoration(
                labelText: 'Enter your message',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
            SizedBox(height: 16),
            Text('ChatGPT Response: $_response'),
          ],
        ),
      ),
    );
  }
}
