import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:story_mate/registration/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:story_mate/registration/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBcpIdHXRuS2eLo4zmw3i_rhLVpxil78Zk",
      appId: "1:385510487289:android:c18d9d692e96c6c5805e28",
      messagingSenderId: "385510487289",
      projectId: "st-mate-3dcc6",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
