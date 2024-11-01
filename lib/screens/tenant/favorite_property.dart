import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/screens/tenant/property_detailscreen.dart';

class FavoriteProperty extends StatefulWidget {
  const FavoriteProperty({super.key});

  @override
  State<FavoriteProperty> createState() => _FavoritePropertyState();
}

class _FavoritePropertyState extends State<FavoriteProperty> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Favorite Properties',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: user != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('favorites')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final favoriteDocs = snapshot.data!.docs;
                if (favoriteDocs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No favorite properties yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteDocs.length,
                  itemBuilder: (context, index) {
                    final favorite = favoriteDocs[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                            () => PropertyDetailsScreen(
                                  propertyId: favorite.id,
                                  title: favorite['title'],
                                  location: favorite['location'],
                                  imageURL: favorite['imageURLs'],
                                  price: '',
                                  area: '',
                                  bhk: '',
                                  isVerified: true,
                                  owner: '',
                                  // Pass additional fields here as needed
                                ),
                            transition: Transition.fade);
                      },
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  favorite['imageURLs'],
                                  
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      favorite['title'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      favorite['location'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .collection('favorites')
                                      .doc(favorite.id)
                                      .delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : const Center(
              child: Text(
                'You must be logged in to see favorites',
                style: TextStyle(fontSize: 16),
              ),
            ),
    );
  }
}
