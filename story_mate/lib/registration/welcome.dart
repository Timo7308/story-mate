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
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'STORYMATE',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Literata',
                  color: Colors.black,
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
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Text(
                  'Make new friends,\nwrite new stories',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Literata',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Empowered by AI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Lato',
                    color: Colors.black,
                  ),
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
                    horizontal: 30,
                    vertical: 10,
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
                      primary: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      minimumSize: const Size(
                        double.infinity,
                        70,
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5), // Space between buttons

                // Button to navigate to the Registration page
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0A2342),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      minimumSize: const Size(
                        double.infinity,
                        70,
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Lato',
                      ),
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
