import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:story_mate/stories/story_chat.dart';
import 'package:story_mate/stories/start.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode(); // Add this line
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  void _loginUser() async {
    try {
      setState(() {
        _loading = true;
      });

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        // Successful login
        await _updateLoginStatus('online'); // Set loginStatus to 'online'

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/start', // Assuming you have a named route for StartPage
              (route) => false, // Remove all previous routes
        );
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.message}');
      _showErrorSnackbar("Incorrect login information. Please try again.");
    } catch (e) {
      print('Error: $e');
      _showErrorSnackbar("Error during login. Please try again.");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
  Future<void> _updateLoginStatus(String status) async {
    try {
      String userId = _auth.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'loginStatus': 'online'}); // Replace 'online' with your desired value
    } catch (e) {
      print('Error updating login status: $e');
      // Handle error
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to your account'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email input field
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus, // Add this line
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        autofocus: true, // Set autofocus to true
                      ),
                      const SizedBox(height: 20),
                      // Password input field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Login button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _loading ? null : _loginUser,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
