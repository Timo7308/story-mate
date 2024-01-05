import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:story_mate/registration/welcome.dart';
import 'package:story_mate/stories/story_chat.dart';

//FOR DEBUGGING TURN TO TRUE
bool Debug = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBcpIdHXRuS2eLo4zmw3i_rhLVpxil78Zk",
          appId: "1:385510487289:android:c18d9d692e96c6c5805e28",
          messagingSenderId: "385510487289",
          projectId: "st-mate-3dcc6",
          databaseURL: 'https://st-mate-3dcc6-default-rtdb.europe-west1.firebasedatabase.app'
      ),
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // Function that creates a swatch based on our primary color.
  // Derived from: https://medium.com/@nickysong/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A2342);
    return MaterialApp(
      //change initial page for bootup here

      home: StoryChatPage(),

      //home: MyHomePage(), // make the openAI page as the default page after login
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(primaryColor),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Literata',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Literata',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Lato',
            fontSize: 16,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Literata',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          // Customize the appearance of text input fields
          filled: true,
          fillColor: const Color.fromARGB(
              255, 216, 216, 216), // Set the background color
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Adjust the corner radius
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(
            color: primaryColor,
            fontFamily: 'Lato',
          ),
          floatingLabelBehavior:
              FloatingLabelBehavior.never, // Hide the hint text on typing
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF0A2342),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            minimumSize: const Size(
              double.infinity,
              60,
            ),
            textStyle: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 20,
              color: Colors.white,

              //  ),
            ),
          ),
        ),

        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white, // white background
      ),
    );
  }
}
