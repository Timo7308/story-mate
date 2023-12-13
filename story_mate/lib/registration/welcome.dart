import 'package:flutter/material.dart';
import 'login.dart'; // Ensure this is the correct path to your login page
import 'registration.dart'; // Ensure this is the correct path to your registration page

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: <Widget>[
          // Text "Story Mate" in the upper half
          const Expanded(
            flex: 2, // Adjust the flex to control space distribution
            child: Center(
              child: Text(
                'Storymate',
                style: TextStyle(
                  fontSize: 40, // Adjust font size
                  fontWeight: FontWeight.bold, // Makes the text bold
                  color: Colors.black, // Text color
                ),
              ),
            ),
          ),

          // Buttons in the lower half
          Expanded(
            flex: 1, // Adjust the flex to control space distribution
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Button to navigate to the Login page
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo[900], // Button color
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 50), // Makes the button wider and of fixed height
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space between buttons

                // Button to navigate to the Registration page
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[900], // Button color
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 50), // Makes the button wider and of fixed height
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Space at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}
