import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../registration/welcome.dart';

class CheckProfile extends StatefulWidget {
  const CheckProfile({super.key});

  @override
  _CheckProfileState createState() => _CheckProfileState();
}

class _CheckProfileState extends State<CheckProfile> {
  String? _profileImageUrl;
  String? _gender;
  String? _about;
  String? _username;
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
                crossAxisAlignment: CrossAxisAlignment.center, // Center content
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

      // Check if the document exists and contains the "profileImageUrl" field
      if (userSnapshot.exists && userSnapshot.data() is Map<String, dynamic>) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

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
          SizedBox(width: 10), // Adjust the width as needed for spacing
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
              offset:
                  const Offset(0, -5), // Adjust the vertical offset as needed
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
            style: Theme.of(context)
                .textTheme
                .titleMedium, // Adjust the font size as needed
          ),
          const SizedBox(height: 15), // Adjust the height as needed
          if (_about != null) ...[
            TextField(
              controller: TextEditingController(text: _about),
              readOnly: true,
              maxLines: null,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 15), // Adjust the height as needed
            _editAboutButton(),
          ] else ...[
            const SizedBox(),
          ],
        ],
      ),
    );
  }

  Widget _editAboutButton() {
    return SizedBox(
      width: 80, // Adjust the width as needed
      height: 40, // Adjust the height as needed
      child: OutlinedButton(
        onPressed: () {
          _editAboutSection();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xFF0A2342), // Set the background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8.0), // Adjust the border radius as needed
          ),
        ),
        child: const Text(
          'Edit',
          style: TextStyle(
            color: Colors.white, // Set the text color
            fontSize: 16, // Adjust the font size as needed
          ),
        ),
      ),
    );
  }

  Future<void> _editAboutSection() async {
    _aboutController.text =
        _about ?? ''; // Set the initial value in the text field

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(_about != null ? 'Edit About' : 'Add About'),
          content: TextField(
            controller: _aboutController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'About'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newAbout = _aboutController.text.trim();
                Navigator.of(context).pop();

                // Update 'about' field in Firestore
                await _updateAbout(newAbout);
              },
              child: const Text('Save'),
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
    return TextButton.icon(
      onPressed: () {
        _showLogoutConfirmationDialog();
      },
      icon: Icon(Icons.logout, color: Colors.red), // Use your preferred icon
      label: Text(
        'Log Out',
        style: TextStyle(
          color: Colors.red, // Set the text color to red
          fontSize: 16, // Adjust the font size as needed
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
          title: const Text('Logout Confirmation'),
          content: const Text('Do you really want to log out of your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _logout(); // Implement your logout functionality
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes'),
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
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (route) => false,
      );
    } catch (e) {
      print(e); // Handle errors
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: WelcomePage(),
  ));
}
