import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          // Implement logout functionality
        },
        icon: Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Log Out',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Future<void> _loadProfileData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      setState(() {
        _profileImageUrl = userSnapshot['profileImageUrl'];
        _gender = userSnapshot['gender'];
      });
    } catch (e) {
      print(e); // Handle errors
    }
  }

  Future<void> _pickAndUploadImage() async {
    // Implement the same method as in your ProfilePage for picking and uploading images
  }
}
