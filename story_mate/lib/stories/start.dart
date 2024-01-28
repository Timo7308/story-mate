import 'package:flutter/material.dart';
import 'match.dart';
import 'package:story_mate/profile/profile_check.dart';
import 'tutorial.dart';
import 'story_choice.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool showChats =
      false; // Flag to toggle between "New Adventure" and chat list

  Widget buildFloatingActionButton() {
    return SizedBox(
      width: 380.0,
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChoicePage(),
            ),
          );
        },
        label: Row(
          children: [
            Text('New Adventure'),
            Icon(Icons.shuffle),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable the back button
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              setState(() {
                showChats = showChats;
              });
            },
            child: const Text('Home'),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle, size: 40.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckProfile()),
                );
                // Add functionality for the profile button
              },
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (!showChats) ...[
                          Container(
                            // Add a fixed height for the image container
                            height: 350.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Opacity(
                                opacity: 0.5,
                                child: Image.asset(
                                  'assets/HomeImage.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Ready, Set, Go!',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Click the big button below to start your chat or find out how it works.',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TutorialPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Tutorial',
                              style: TextStyle(
                                fontSize: 16.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                        ],
                        if (showChats)
                          Container(
                            // Add a fixed height for the chat list container
                            height: constraints.maxHeight - 70.0,
                            child: ListView.builder(
                              itemCount: 20,
                              itemBuilder: (context, index) {
                                // Your chat list item code
                                String genreOfStory = 'A Pirate Tale';
                                String userName = 'User $index';
                                String lastMessage =
                                    'This is a very long last message. It goes beyond one line and will be truncated with ...';
                                bool hasNewMessage = index % 2 ==
                                    0; // Dummy condition for new message indicator

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/profile_image.png'),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$genreOfStory with $userName',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(Icons
                                          .chevron_right), // Add the right arrow icon here
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lastMessage.length > 50
                                            ? '${lastMessage.substring(0, 50)}...'
                                            : lastMessage,
                                      ),
                                      SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          if (hasNewMessage)
                                            Container(
                                              width: 10.0,
                                              height: 10.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFF2CA58D),
                                              ),
                                              margin:
                                                  EdgeInsets.only(right: 4.0),
                                            ),
                                          Text(
                                            '1h ago',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // Add navigation to the chat screen for the selected user
                                    // You may want to pass the user details to the chat screen
                                  },
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !showChats,
                  child: buildFloatingActionButton(),
                ),
                Visibility(
                  visible: showChats,
                  child: buildFloatingActionButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
