import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile/profile.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode(); // Add this line
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _usernameFocus.requestFocus(); // Set focus to the username field
  }

  void _registerUser() async {
    if (!_isValidUsername(_usernameController.text) ||
        !_isValidEmail(_emailController.text) ||
        !_isValidPassword(_passwordController.text)) {
      _showErrorSnackbar("Invalid username, email, or password format.");
      return;
    }

    try {
      setState(() {
        _loading = true;
      });

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
          'status': 0,
          'loginStatus': 'online',
        });

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
      _showErrorSnackbar("Error during registration: ${e.message}");
    } catch (e) {
      print('Error: $e');
      _showErrorSnackbar("Error during registration: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  bool _isValidUsername(String username) {
    return username.isNotEmpty;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
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
        title: const Text('Signup for Storymate'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _usernameController,
                        //focusNode: _usernameFocus, // Add this line
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _loading ? null : _registerUser,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text('Register'),
            ),
          ),
        ],
      ),
    );
  }
}
