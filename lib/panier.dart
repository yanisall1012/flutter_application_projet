import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class panier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('panier').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return Center(
              child: Text('Vous devez être connecté pour voir votre panier.'),
            );
          }

          final activitesPanier = snapshot.data!.docs
              .map((doc) => ActivitePanier.fromDocument(doc))
              .where((activite) => activite.idUser == user.uid)
              .toList();
          double totalGeneral = activitesPanier.fold(0, (sum, activite) => sum + activite.prix);

          if (activitesPanier.isEmpty) {
            return Center(
              child: Text('Votre panier est vide'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: activitesPanier.length,
                  itemBuilder: (context, index) {
                    final activite = activitesPanier[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            activite.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          activite.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${activite.lieu}, ${activite.prix} euros'),
                        trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            // Supprimer l'activité du panier
                            _supprimerDuPanier(activite.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Affichage du total général
              Container(
                color: Colors.red,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total général : $totalGeneral euros',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _supprimerDuPanier(String idActivite) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('panier').doc(idActivite);
    documentReference.delete();
  }
}

class ActivitePanier {
  final String id;
  final String idUser;
  final String title;
  final String lieu;
  final double prix;
  final String imageUrl;

  ActivitePanier({
    required this.id,
    required this.idUser,
    required this.title,
    required this.lieu,
    required this.prix,
    required this.imageUrl,
  });

  factory ActivitePanier.fromDocument(DocumentSnapshot doc) {
    return ActivitePanier(
      id: doc.id,
      idUser: doc['idUser'],
      title: doc['titre'],
      lieu: doc['lieu'],
      prix: doc['prix'],
      imageUrl: doc['image'],
    );
  }

  // Méthode statique pour ajouter une activité au panier avec l'ID de l'utilisateur
  static Future<void> ajouterAuPanier(String idUser, String title, String lieu, double prix, String imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("L'utilisateur n'est pas connecté.");
    }

    final panierRef = FirebaseFirestore.instance.collection('panier');
    await panierRef.add({
      'idUser': user.uid,
      'titre': title,
      'lieu': lieu,
      'prix': prix,
      'image': imageUrl,
    });
  }
}
