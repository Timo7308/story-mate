import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class CheckProfile extends StatefulWidget {
  const CheckProfile({Key? key}) : super(key: key);

  @override
  _CheckProfileState createState() => _CheckProfileState();
}

class _CheckProfileState extends State<CheckProfile> {
  String? _profileImageUrl;
  String? _gender;
  final ImagePicker _picker = ImagePicker();

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
                  _changeProfileImageButton(),
                  const SizedBox(height: 30),
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

  // Widget methods...

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

      // Check if the URL starts with 'gs://', convert it to a downloadable URL
      if (imageUrl.startsWith('gs://')) {
        imageUrl = await _getDownloadUrl(imageUrl);
      }

      // Update state with fetched data
      setState(() {
        _profileImageUrl = imageUrl;
        _gender = userSnapshot['gender'];
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

  Future<void> _pickAndUploadImage() async {
    // Implement the same method as in your ProfilePage for picking and uploading images
    // Placeholder: Implement this method using _picker and Firebase Storage
  }

  // Other methods...

  Widget _profileImage() {
    if (_profileImageUrl != null) {
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

  Widget _changeProfileImageButton() {
    return InkWell(
      onTap: () => _pickAndUploadImage(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Profile Image ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender:',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 10),
        Text(
          _gender ?? 'Loading...',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget _aboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About:',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            // Handle edit about section
          },
          child: const Text(
            'Edit',
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
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

  void _logout() {
    // Implement your logout functionality here
    // For example, you can use FirebaseAuth.instance.signOut()
  }
}

void main() {
  runApp(MaterialApp(
    home: CheckProfile(),
  ));
}
