import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_mate/registration/login.dart';

import '../registration/welcome.dart';

class CheckProfile extends StatefulWidget {
  const CheckProfile({Key? key}) : super(key: key);

  @override
  _CheckProfileState createState() => _CheckProfileState();
}

class _CheckProfileState extends State<CheckProfile> {
  String? _profileImageUrl;
  String? _gender;
  String? _about;
  String? _username;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _profileImage(),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  _userNameSection(),
                  const SizedBox(height: 40),
                  _genderSection(),
                  const SizedBox(height: 30),
                  _aboutSection(),
                ],
              ),
            ),
          ),
          _logoutButton(),
        ],
      ),
    );
  }

  Future<void> _loadProfileData() async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Get profile image URL from Firestore
      String imageUrl = userSnapshot['profileImageUrl'];

      // Use the fetched image URL
      setState(() {
        _profileImageUrl = imageUrl;
        _gender = userSnapshot['gender'];
        _about = userSnapshot['about'];
        _username = userSnapshot['username'];
      });
    } catch (e) {
      print('Error loading profile data: $e');
      // Handle errors
    }
  }

  Future<String> _getDownloadUrl(String gsUrl) async {
    // Convert the 'gs://' URL to a downloadable URL
    try {
      final ref = FirebaseStorage.instance.refFromURL(gsUrl);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error getting download URL: $e');
      return gsUrl; // Return the original URL in case of an error
    }
  }

  Widget _profileImage() {
    if (_profileImageUrl != null) {
      print("Profile Image URL: $_profileImageUrl"); // Add this line
      return ClipOval(
        child: Image.network(
          _profileImageUrl!,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const ClipOval(
        child: Icon(Icons.account_circle, size: 150),
      );
    }
  }

  Widget _genderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Gender:',
          style: Theme.of(context).textTheme.subtitle1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          _gender ?? 'Loading...',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _userNameSection() {
    return Text(
      _username ?? 'Loading...',
      style: Theme.of(context).textTheme.displayLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _aboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'About:',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 10),
        if (_about != null) ...[
          TextField(
            controller: TextEditingController(text: _about),
            readOnly: true,
            maxLines: null, // Display multiple lines
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 10),
          _editAboutButton(),
        ] else ...[
          SizedBox(), // Placeholder to ensure proper layout
          _addAboutButton(),
        ],
      ],
    );
  }


  Widget _editAboutButton() {
    return GestureDetector(
      onTap: () {
        _editAboutSection();
      },
      child: Text(
        'Edit',
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _addAboutButton() {
    return GestureDetector(
      onTap: () {
        _editAboutSection();
      },
      child: Text(
        'Add About',
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Future<void> _editAboutSection() async {
    _aboutController.text = _about ?? ''; // Set the initial value in the text field

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(_about != null ? 'Edit About' : 'Add About'),
          content: TextField(
            controller: _aboutController,
            maxLines: 5,
            decoration: InputDecoration(labelText: 'About'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newAbout = _aboutController.text.trim();
                Navigator.of(context).pop();

                // Update 'about' field in Firestore
                await _updateAbout(newAbout);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateAbout(String newAbout) async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update 'about' field in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'about': newAbout});

      // Update state with the new 'about' value
      setState(() {
        _about = newAbout;
      });
    } catch (e) {
      print('Error updating about section: $e');
      // Handle errors
    }
  }

  Widget _logoutButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: TextButton.icon(
        onPressed: () {
          _showLogoutConfirmationDialog();
        },
        icon: Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Log Out',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Logout Confirmation'),
          content: Text('Do you really want to log out of your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _logout(); // Implement your logout functionality
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
  void _logout() async {
    try {
      // Set the user's login status to offline (you need to have a field for loginStatus in your Firestore document)
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'loginStatus': 'offline'});

      // Sign out the user
      await FirebaseAuth.instance.signOut();

      // Navigate to the login page and clear the navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomePage()),
            (route) => false,
      );
    } catch (e) {
      print(e); // Handle errors
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: WelcomePage(),
  ));
}
