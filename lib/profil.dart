import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late User _currentUser;
  late TextEditingController _emailController;
  late TextEditingController _adresseController;
  late TextEditingController _birthdayController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _emailController = TextEditingController(text: _currentUser.email);
    _adresseController = TextEditingController();
    _birthdayController = TextEditingController();
    _cityController = TextEditingController();
    _postalCodeController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();

    // Récupérer les données de l'utilisateur actuellement connecté
    _chargerDonneesUtilisateur();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Profil'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          TextFormField(
            controller: _emailController,
            readOnly: true, // L'email est en lecture seule
            decoration: InputDecoration(
              labelText: 'Adresse e-mail',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _adresseController,
            decoration: InputDecoration(
              labelText: 'Adresse',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _birthdayController,
            decoration: InputDecoration(
              labelText: 'Date de naissance',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: 'Ville',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _postalCodeController,
            decoration: InputDecoration(
              labelText: 'Code postal',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _currentPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mot de passe actuel',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Nouveau mot de passe',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: sauvegarderDonnees,
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 167, 10, 198), // Couleur d'arrière-plan personnalisée
              onPrimary: Colors.white, // Couleur du texte
            ),
            child: Text('Valider'),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () => deconnexion(context),
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 167, 10, 198), // Couleur d'arrière-plan personnalisée
              onPrimary: Colors.white, // Couleur du texte
            ),
            child: Text('Se déconnecter'),
          ),
        ],
      ),
    ),
  );
}

  void _chargerDonneesUtilisateur() async {
    try {
      // Récupérer les données de l'utilisateur depuis Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(_currentUser.uid)
          .get();

      if (userSnapshot.exists) {
        // Mettre à jour les contrôleurs de texte avec les données de l'utilisateur
        setState(() {
          _adresseController.text = userSnapshot['address'] ?? '';
          _birthdayController.text = userSnapshot['birthday'] ?? '';
          _cityController.text = userSnapshot['city'] ?? '';
          _postalCodeController.text = userSnapshot['postalCode'] ?? '';
        });
      }
    } catch (error) {
      print('Erreur lors du chargement des données utilisateur: $error');
    }
  }

  void sauvegarderDonnees() async {
    try {
      // Mettre à jour les données de l'utilisateur dans Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(_currentUser.uid)
          .update({
        'address': _adresseController.text,
        'birthday': _birthdayController.text,
        'city': _cityController.text,
        'postalCode': _postalCodeController.text,
      });

      // Mettre à jour l'adresse e-mail si elle a été modifiée
      if (_emailController.text != _currentUser.email) {
        await _currentUser.updateEmail(_emailController.text);
      }

      // Mettre à jour le mot de passe si un nouveau mot de passe a été saisi
      if (_newPasswordController.text.isNotEmpty) {
        await _currentUser.updatePassword(_newPasswordController.text);
      }

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Données sauvegardées avec succès')),
      );
    } catch (error) {
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sauvegarde des données: $error')),
      );
    }
  }

  void deconnexion(BuildContext context) async {
    try {
      // Se déconnecter de Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // Naviguer vers la page de login
      Navigator.pushReplacementNamed(context, '/login_page');
    } catch (error) {
      print('Erreur lors de la déconnexion: $error');
    }
  }
}
