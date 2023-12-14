import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setup.dart'; // Ensure this is your correct import

enum Gender { male, female, other }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profileImageUrl;
  Gender? _selectedGender;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup your profile'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Center(child: _profileImage()),
                  const SizedBox(height: 20),
                  _uploadButton(),
                  _genderChoiceTile(Gender.male, 'Male'),
                  _genderChoiceTile(Gender.female, 'Female'),
                  _genderChoiceTile(Gender.other, 'Other'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _finishSetupButton(),
        ],
      ),
    );
  }
  Widget _profileImage() {
    if (_profileImageUrl != null) {
      return Image.network(
        _profileImageUrl!,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(Icons.account_circle, size: 150);
    }
  }

  Widget _uploadButton() {
    return Center(
      child: SizedBox(
        width: 300, // Set the width as per your requirement
        child: ElevatedButton(
          onPressed: () => _pickAndUploadImage(),
          style: ElevatedButton.styleFrom(
            // If you want to adjust the padding inside the button
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          child: const Text('Upload Profile Picture'),
        ),
      ),
    );
  }
  Widget _genderChoiceTile(Gender gender, String text) {
    return ListTile(
      title: Text(text),
      leading: Radio<Gender>(
        value: gender,
        groupValue: _selectedGender,
        onChanged: (Gender? value) {
          setState(() {
            _selectedGender = value;
          });
          _saveGenderToFirebase(text.toLowerCase());
        },
      ),
    );
  }

  Positioned _finishSetupButton() {
    return Positioned(
      bottom: 10, // Reduced value to move the button higher
      left: 15,
      right: 15,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // Adjust width as needed
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20), // Add padding to move the button up
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SetupPage()),
              );
            },
            child: const Text('Finish Setup'),
          ),
        ),
      ),
    );
  }


  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);

      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        final firebaseStorageRef = FirebaseStorage.instance.ref().child('profile_pics/$userId');
        final uploadTask = firebaseStorageRef.putFile(file);
        final taskSnapshot = await uploadTask;
        final imageUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          _profileImageUrl = imageUrl;
        });
      } catch (e) {
        print(e); // Handle errors
      }
    }
  }

  void _saveGenderToFirebase(String gender) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'gender': gender,
    }).then((_) {
      print('Gender updated to $gender');
    }).catchError((error) {
      print('Error updating gender: $error');
    });
  }
}
