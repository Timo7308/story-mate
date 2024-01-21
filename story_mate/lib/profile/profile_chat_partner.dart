import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileChatPartnerScreen extends StatefulWidget {
  final String partnerUserId;

  const ProfileChatPartnerScreen({Key? key, required this.partnerUserId})
      : super(key: key);

  @override
  _ProfileChatPartnerScreenState createState() =>
      _ProfileChatPartnerScreenState();
}

class _ProfileChatPartnerScreenState extends State<ProfileChatPartnerScreen> {
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
        title: const Text('Chat Partner Profile'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
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
    );
  }

  Future<void> _loadProfileData() async {
    try {
      // Fetch user data from Firestore using the partnerUserId
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.partnerUserId)
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
          Text(
            _about!,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ] else ...[
          SizedBox(), // Placeholder to ensure proper layout
          Text(
            'No information available.',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileChatPartnerScreen(
        partnerUserId:
            '123'), // Replace '123' with the actual partner's user ID
  ));
}
