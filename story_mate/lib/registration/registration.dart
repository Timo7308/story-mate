import 'package:flutter/material.dart';
import 'login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform registration logic here
                String username = _usernameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;

                // Add your registration logic here, e.g., call an API
                // For simplicity, just print the registration details
                print('Username: $username');
                print('Email: $email');
                print('Password: $password');
              },
              child: const Text('Register'),
            ),
            const SizedBox(height: 10), // Add some spacing
            ElevatedButton(
             onPressed: () {
             Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login page
             );
             },


            child: const Text('Already have an account? Login')

            )],
        ),
      ),
    );
  }
}