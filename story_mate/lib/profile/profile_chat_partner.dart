import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileChatPartner extends StatefulWidget {
  const ProfileChatPartner({super.key, required this.secondUserId});
  final String secondUserId;

  @override
  _ProfileChatPartnerState createState() => _ProfileChatPartnerState();
}

class _ProfileChatPartnerState extends State<ProfileChatPartner> {
  String? _profileImageUrl;
  String? _gender;
  String? _about;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Chatpartner'),
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
                  _userNameSection(),
                  const SizedBox(height: 30),
                  _genderSection(),
                  const SizedBox(height: 40),
                  _aboutSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadProfileData() async {
    try {
      String userId = widget.secondUserId;
      // Get the current user's ID

      // Fetch user data from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if the document exists and contains the "profileImageUrl" field
      if (userSnapshot.exists && userSnapshot.data() is Map<String, dynamic>) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        if (userData.containsKey('profileImageUrl')) {
          // Get profile image URL from Firestore
          String imageUrl = userData['profileImageUrl'];

          // Use the fetched image URL
          setState(() {
            _profileImageUrl = imageUrl;
            _gender = userData['gender'];
            _about = userData['about'];
            _username = userData['username'];
          });
        } else {
          // Handle the case where the field is missing
          print('Profile image URL not found in the document.');
        }
      } else {
        // Handle the case where the document is missing or has unexpected data
        print('Invalid document or data type.');
      }
    } catch (e) {
      print('Error loading profile data: $e');
      // Handle errors
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic, // Specify the baseline type
        children: [
          Text(
            'Gender: ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 10), // Adjust the width as needed for spacing
          Text(
            _gender ?? 'Loading...',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _userNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the top
          children: [
            Text(
              'Username:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 10),
            Transform.translate(
              offset: const Offset(0, -5), // Adjust the vertical offset as needed
              child: Text(
                _username ?? 'Loading...',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _aboutSection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About:',
            style: Theme
                .of(context)
                .textTheme
                .titleMedium, // Adjust the font size as needed
          ),
          const SizedBox(height: 15), // Adjust the height as needed
          if (_about != null) ...[
            TextField(
              controller: TextEditingController(text: _about),
              readOnly: true,
              maxLines: null,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 15), // Adjust the height as needed

          ] else
            ...[
              const SizedBox(),
            ],
        ],
      ),
    );
  }
}

