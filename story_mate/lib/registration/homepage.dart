import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),

        // Remove the automatically implied leading back button
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Welcome! You are logged in.'),
      ),
    );
  }
}

//the start.dart has the actual homescreen for now, lets ignore this one!


