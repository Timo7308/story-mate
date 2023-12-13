import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { male, female, other }

class ProfilePage extends StatefulWidget {
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
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: _profileImage(),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _pickAndUploadImage(),
                child: Text('Upload Profile Picture'),
              ),
            ),
            ListTile(
              title: const Text('Male'),
              leading: Radio<Gender>(
                value: Gender.male,
                groupValue: _selectedGender,
                onChanged: (Gender? value) {
                  setState(() {
                    _selectedGender = value;
                  });
                  _saveGenderToFirebase('male');
                },
              ),
            ),
            ListTile(
              title: const Text('Female'),
              leading: Radio<Gender>(
                value: Gender.female,
                groupValue: _selectedGender,
                onChanged: (Gender? value) {
                  setState(() {
                    _selectedGender = value;
                  });
                  _saveGenderToFirebase('female');
                },
              ),
            ),
            ListTile(
              title: const Text('Other'),
              leading: Radio<Gender>(
                value: Gender.other,
                groupValue: _selectedGender,
                onChanged: (Gender? value) {
                  setState(() {
                    _selectedGender = value;
                  });
                  _saveGenderToFirebase('other');
                },
              ),
            ),
            // ... Additional widgets or content can be added here ...
          ],
        ),
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
      return Icon(Icons.account_circle, size: 150);
    }
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
