import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_application_projet/panier.dart';
import 'package:flutter_application_projet/profil.dart';

class ActivitesPage extends StatefulWidget {
  @override
  _ActivitesPageState createState() => _ActivitesPageState();
}

class _ActivitesPageState extends State<ActivitesPage> {
  String _selectedCategory = 'Toutes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activités'),
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Activities').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final activites = snapshot.data!.docs.map((doc) => Activite.fromDocument(doc)).where((activite) {
                  return _selectedCategory == 'Toutes' || activite.categorie == _selectedCategory;
                }).toList();
                return ListView.builder(
                  itemCount: activites.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            activites[index].image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          activites[index].title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${activites[index].lieu}, ${activites[index].prix} €',
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailActivitePage(activite: activites[index]),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            // Ajouter l'activité au panier de l'utilisateur
                            ajouterAuPanier(context, activites[index]);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Activités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            // Naviguer vers la page du panier
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => panier()),
            );
          } else if (index == 2) {
            // Naviguer vers la page du profil
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilPage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryTab('Toutes'),
          _buildCategoryTab('Sport'),
          _buildCategoryTab('Jeux'),
          _buildCategoryTab('Culture'),
          _buildCategoryTab('Bénévolat'),
          _buildCategoryTab('Randonnées'),
          _buildCategoryTab('Éducation'),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String category) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _selectedCategory == category ? Color.fromARGB(255, 132, 1, 158) : Colors.grey),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: _selectedCategory == category ? Color.fromARGB(255, 132, 1, 158) : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
class DetailActivitePage extends StatelessWidget {
  final Activite activite;

  DetailActivitePage({required this.activite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activite.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMoyenneEvaluation(activite.id),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 200.0),
                        child: Container(
                          height: 400, // Hauteur maximale de l'image
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              activite.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: 200,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          color: Colors.grey.withOpacity(0.5),
                          child: _buildCommentairesList(activite.id),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    activite.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${activite.lieu}, ${activite.prix} €',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nombre de personnes maximum: ${activite.nombrePersonneMaximum}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Catégorie: ${activite.categorie}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alignement des boutons sur le même niveau
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Ajouter l'activité au panier de l'utilisateur
                          ajouterAuPanier(context, activite);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 167, 10, 198), // Couleur personnalisée pour le bouton
                        ),
                        child: Text('Ajouter au panier',style: TextStyle(color: Colors.white),),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Naviguer vers la page d'ajout de commentaire
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AjoutCommentairePage(activite: activite)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 167, 10, 198), // Couleur personnalisée pour le bouton
                        ),
                        child: Text('Ajouter un commentaire',style: TextStyle(color: Colors.white),),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Retourner à la page précédente
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 167, 10, 198), // Couleur personnalisée pour le bouton
                        ),
                        child: Text('Retour',style: TextStyle(color: Colors.white),)
                        ,
                        
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoyenneEvaluation(String activiteId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Commentaires').where('activiteID', isEqualTo: activiteId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SizedBox(); // Rien à afficher
        }
        var totalNotes = snapshot.data!.docs.map((doc) => doc['note'] as double).reduce((a, b) => a + b);
        var moyenne = totalNotes / snapshot.data!.docs.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Moyenne des évaluations :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RatingBarIndicator(
              rating: moyenne,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 30,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentairesList(String activiteId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Commentaires').where('activiteID', isEqualTo: activiteId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('Pas de commentaires'); // Aucun commentaire à afficher
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commentaires :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var commentaire = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(commentaire['texte']),
                    subtitle: RatingBarIndicator(
                      rating: commentaire['note'],
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class AjoutCommentairePage extends StatefulWidget {
  final Activite activite;

  AjoutCommentairePage({required this.activite});

  @override
  _AjoutCommentairePageState createState() => _AjoutCommentairePageState();
}

class _AjoutCommentairePageState extends State<AjoutCommentairePage> {
  double _rating = 0;
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un commentaire'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notez cette activité :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 0,
              maxRating: 5,
              itemSize: 40,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Ajoutez un commentaire :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Votre commentaire ici...',
                border: OutlineInputBorder(),
              ),
              minLines: 3,
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Appel de la fonction pour ajouter le commentaire et la notation
                ajouterCommentaire(widget.activite.id, FirebaseAuth.instance.currentUser!.uid, _commentController.text, _rating);
                // Retourner à la page précédente
                Navigator.pop(context);
              },
              child: Text('Ajouter le commentaire'),
            ),
          ],
        ),
      ),
    );
  }
}

class Activite {
  final String id;
  final String title;
  final String image;
  final String lieu;
  final double prix;
  final double nombrePersonneMaximum;
  final String categorie;

  Activite({
    required this.id,
    required this.title,
    required this.image,
    required this.lieu,
    required this.prix,
    required this.nombrePersonneMaximum,
    required this.categorie,
  });

  factory Activite.fromDocument(DocumentSnapshot doc) {
    return Activite(
      id: doc.id,
      title: doc['titre'],
      image: doc['image'],
      lieu: doc['lieu'],
      prix: doc['prix'],
      nombrePersonneMaximum: doc['nombrePersonneMaximum'],
      categorie: doc['categorie'],
    );
  }
}

void ajouterAuPanier(BuildContext context, Activite activite) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vous devez être connecté pour ajouter une activité au panier')),
    );
    return;
  }

  FirebaseFirestore.instance.collection('panier').add({
    'idUser': user.uid, // Ajout de l'ID de l'utilisateur
    'titre': activite.title,
    'image': activite.image,
    'lieu': activite.lieu,
    'prix': activite.prix,
  }).then((value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Activité ajoutée au panier')),
    );
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de l\'ajout au panier: $error')),
    );
  });
}
void ajouterCommentaire(String activiteId, String userId, String texte, double note) {
  FirebaseFirestore.instance.collection('Commentaires').add({
    'activiteID': activiteId,
    'userID': userId,
    'texte': texte,
    'note': note,
  }).then((value) {
    print('Commentaire ajouté avec succès');
  }).catchError((error) {
    print('Erreur lors de l\'ajout du commentaire: $error');
  });
}
