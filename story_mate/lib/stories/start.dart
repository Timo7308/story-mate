import 'package:flutter/material.dart';

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
    );
  }
}
