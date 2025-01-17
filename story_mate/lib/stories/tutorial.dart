import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  late ScrollController _scrollController;
  double _scale = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scale = 1 - _scrollController.offset / 1000;
          if (_scale < 0.3) _scale = 0.3;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorial'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Centered Image
            Transform.scale(
              scale: _scale,
              child: Center(
                child: Image.asset(
                  'assets/TutorialScreen.png', // Replace with your image asset path
                  width: 600.0,
                  height: 300.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Welcome Text
            Text(
              'This is how it works:',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            // Body Text
            Text(
              'Storymate let\'s you meet new people and make new friends by exploring stories together. \n \nJust click the New Adventure button on the bottom of the home screen and choose the genre of the story you want  to embark on. Then you will be assigned another person that picked the same story and both of you will be introduced to the plot. \n \nNow it is your turn! All the messages you send to the chat will be automatically stylized to fit the scenario of the story. \n\n That means if you are in the midst of a Pirate story, your chat input will automatically be adjusted to sound more like it comes from a pirate (arrrr). And the same goes for all the other genres as well of course.\nThat means your partner will not see your original message but the stylized version of it. Work together to create new stories, push the plot forward and ask questions so you can get to know each other.\n \nEnough talk! Go back to the homepage, choose your story and venture off to meet new people and make new friends.\n\nEnjoy!  ',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.left,
            ),

            // Add more text widgets or other content as needed
          ],
        ),
      ),
    );
  }
}
