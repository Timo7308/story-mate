import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setup.dart'; // Ensure this is your correct import

enum Gender { male, female, other }

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
                  const SizedBox(height: 50),
                  Text(
                    'Your Gender',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 30),
                  _genderSegmentedButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                if (_selectedGender == null) {
                  _saveGenderToFirebase('male');
                }

                // Set a default value for the about field, you can modify this as needed
                String about = "-";

                // Save the about field to Firebase
                _saveAboutToFirebase(about);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetupPage()),
                );
              },
              child: const Text('Finish Setup'),
            ),
          ),
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

  Widget _uploadButton() {
    return InkWell(
      onTap: () => _pickAndUploadImage(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Set the background color to light grey
          borderRadius: BorderRadius.circular(20), // Set border radius
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Upload Profile Picture ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.add, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _genderSegmentedButton() {
    return SegmentedButton<Gender>(
      segments: const <ButtonSegment<Gender>>[
        ButtonSegment<Gender>(value: Gender.male, label: Text('Male')),
        ButtonSegment<Gender>(value: Gender.female, label: Text('Female')),
        ButtonSegment<Gender>(value: Gender.other, label: Text('Other')),
      ],
      selected: _selectedGender != null
          ? <Gender>{_selectedGender!}
          : <Gender>{Gender.male}, // Default selection
      onSelectionChanged: (Set<Gender> newSelection) {
        setState(() {
          _selectedGender = newSelection.isNotEmpty
              ? newSelection.first
              : null; // Set to null if no selection is made
        });
        _saveGenderToFirebase(
            _selectedGender?.toString().split('.')[1] ?? 'male');
      },
    );
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);

      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        final firebaseStorageRef =
            FirebaseStorage.instance.ref().child('profile_pics/$userId');
        final uploadTask = firebaseStorageRef.putFile(file);
        final taskSnapshot = await uploadTask;
        final imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Store the image URL in the Firebase Firestore
        _saveImageUrlToFirebase(imageUrl);

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

    // Check if the user has made a selection, if not, default to 'male'
    if (gender.isEmpty) {
      gender = 'male';
    }

    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'gender': gender,
    }).then((_) {
      print('Gender updated to $gender');
    }).catchError((error) {
      print('Error updating gender: $error');
    });
  }

  void _saveImageUrlToFirebase(String imageUrl) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profileImageUrl': imageUrl,
    }).then((_) {
      print('Profile image URL updated to $imageUrl');
    }).catchError((error) {
      print('Error updating profile image URL: $error');
    });
  }

  void _saveAboutToFirebase(String about) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'about': about,
    }).then((_) {
      print('About updated to $about');
    }).catchError((error) {
      print('Error updating about: $error');
    });
  }
}
