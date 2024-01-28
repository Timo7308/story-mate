import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'match.dart';

class ChoicePage extends StatefulWidget {
  @override
  _ChoicePageState createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  String? selectedChoice;
  late String selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/start', (route) => false);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16.0),
            Text(
              'Choose your story',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  buildChoiceButton(
                    text: 'A Pirate Tale',
                    icon: Icons.flag,
                    onPressed: () => selectChoice('A Pirate Tale'),
                    selected: selectedChoice == 'A Pirate Tale',
                  ),
                  buildChoiceButton(
                    text: 'A Space Adventure',
                    icon: Icons.rocket,
                    onPressed: () => selectChoice('A Space Adventure'),
                    selected: selectedChoice == 'A Space Adventure',
                  ),
                  buildChoiceButton(
                    text: 'A Medieval Story',
                    icon: Icons.fort,
                    onPressed: () => selectChoice('A Medieval Story'),
                    selected: selectedChoice == 'A Medieval Story',
                  ),
                  buildChoiceButton(
                    text: 'A Fairy Tale',
                    icon: Icons.book,
                    onPressed: () => selectChoice('A Fairy Tale'),
                    selected: selectedChoice == 'A Fairy Tale',
                  ),
                  buildChoiceButton(
                    text: 'A Zombie Apocalypse',
                    icon: Icons.warning,
                    onPressed: () => selectChoice('A Zombie Apocalypse'),
                    selected: selectedChoice == 'A Zombie Apocalypse',
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'You will be assigned to a partner that picked the same story as you',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedChoice != null) {
                  // Store the selected choice in Firebase Firestore
                  storeSelectedChoiceInFirestore(selectedChoice!);

                  // Navigate to the MatchPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MatchPage(
                            selectedChoiceId: selectedChoice!,
                            storyTitle: selectedChoice!,
                          ),
                    ),
                  );
                } else {
                  // Handle the case where selectedChoice is null.
                  // You can show an error message, navigate to a default page, etc.
                }
              },
              style: ElevatedButton.styleFrom(
                primary: selectedChoice != null
                    ? Color(0xFF0A2342)
                    : Color(0xFFF7F7FC),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check,
                      color:
                      selectedChoice != null ? Colors.white : Colors.black),
                  SizedBox(width: 8.0),
                  Text('Start',
                      style: TextStyle(
                          color: selectedChoice != null
                              ? Colors.white
                              : Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChoiceButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required bool selected,
  }) {
    Color buttonColor = selected ? Color(0xFF2CA58D) : Color(0xFFF7F7FC);
    Color textColor =
    buttonColor == Color(0xFFF7F7FC) ? Colors.black : Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (selected) Icon(Icons.check, color: textColor),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor),
              ),
            ),
            Icon(icon, color: textColor),
          ],
        ),
      ),
    );
  }

  void selectChoice(String choice) {
    setState(() {
      selectedChoice = choice;
    });
  }

  void storeSelectedChoiceInFirestore(String choice) {
    try {
      // Replace 'user' with the actual user identifier
      String userId = FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'selectedChoice': choice,
      }).then((_) {
        print('Choice updated');
      }).catchError((error) {
        print('Error updating selected choice: $error');
      });
    } catch (e) {
      print('Error storing selected choice in Firestore: $e');
    }
  }
}