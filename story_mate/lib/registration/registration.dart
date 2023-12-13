import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile.dart'; // Ensure this is the correct path to your login page

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  void _registerUser() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      String userId = userCredential.user?.uid ?? '';
      if (userId.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'username': _usernameController.text,
          'email': _emailController.text,
        });

        // Navigate to ProfilePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
      } else {
        print('User ID is empty, Firestore operation aborted.');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.message}');
      // Optionally, show an error message to the user
    } catch (e) {
      print('Error: $e');
      // Optionally, show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup for Storymate'),
      ),
      body: SingleChildScrollView(
        // Allows for scrolling when keyboard is visible
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Center the Column in the SingleChildScrollView
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // Minimize the space the column takes
            mainAxisAlignment: MainAxisAlignment.center,
            // Center the content vertically
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.2), // Increase space at the top
              // Username input field
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Email input field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Password input field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Register button
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Register'),
              ),
              const SizedBox(height: 10),
              // The button for navigating to login page has been removed
            ],
          ),
        ),
      ),
    );
  }
}
