import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_projet/firebase_options.dart';
import 'login_page.dart';
import 'activities.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  bool isLoggedIn() {
    // Votre logique de connexion ici
    return true; 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/login_page': (context) => LoginPage(),
        // Ajoutez la route pour la page de profil
      },
      home: isLoggedIn() ? LoginPage() : ActivitesPage(), // Remplacez Placeholder() par votre HomePage
    );
  }
}
