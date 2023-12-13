import 'package:flutter/material.dart';
import 'login.dart';
import 'registration.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: <Widget>[
          // Text "Story Mate" at the top
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Text(
                'STORYMATE',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Literata',
                  // color: Colors.black,
                  shadows: [
                    Shadow(
                      color: Color.fromARGB(255, 228, 228, 228),
                      offset: Offset(10, 10),
                      blurRadius: 0.0,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expanded section for the Welcome Image and Text
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/WelcomeImage.png',
                  //fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  'Make new friends,\nwrite new stories',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 40),
                Text(
                  'Empowered by AI',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),

          // Buttons at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Button to navigate to the Login page
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 199, 199, 199), // Set the button color to grey
                    ),
                    child: const Text(
                      'Login',
                    ),
                  ),
                ),
                const SizedBox(height: 5), // Space between buttons

                // Button to navigate to the Registration page
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationPage(),
                        ),
                      );
                    },
                    child: Text('Create Account'),
                  ),
                ),
                const SizedBox(height: 10), // Space at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}
