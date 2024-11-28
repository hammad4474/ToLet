import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends StatefulWidget {
  final String propertyId;

  ReviewScreen({required this.propertyId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String? currentUserName;
  String? currentUserId;
  bool hasReviewed = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        currentUserId = user.uid;

        // Fetch user details from Firestore (assuming user data is stored here)
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            currentUserName = userDoc['firstname'] ?? 'Anonymous';
          });
        }
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  void _showAddReviewDialog() {
    final reviewController = TextEditingController();
    double rating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Write a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(labelText: 'Write a Review'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (reviewController.text.isNotEmpty && rating > 0) {
                  final newReview = {
                    'reviewId':
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    'reviewerName': currentUserName ?? 'Anonymous',
                    'userId': currentUserId,
                    'reviewText': reviewController.text,
                    'timestamp': Timestamp.now(),
                    'rating': rating,
                    'helpfulCount': 0,
                    'notHelpfulCount': 0,
                    'helpfulVoters': [],
                    'notHelpfulVoters': [],
                  };

                  try {
                    await FirebaseFirestore.instance
                        .collection('propertiesAll')
                        .doc(widget.propertyId)
                        .update({
                      'reviews': FieldValue.arrayUnion([newReview])
                    });

                    setState(() {
                      hasReviewed = true;
                    });

                    Navigator.pop(context);
                  } catch (e) {
                    print('Error adding review: $e');
                  }
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _updateVote(String reviewId, bool isHelpful) async {
    try {
      final propertyRef = FirebaseFirestore.instance
          .collection('propertiesAll')
          .doc(widget.propertyId);

      final propertySnapshot = await propertyRef.get();
      if (propertySnapshot.exists) {
        final List<dynamic> reviews = propertySnapshot['reviews'];
        final reviewIndex =
            reviews.indexWhere((review) => review['reviewId'] == reviewId);

        if (reviewIndex != -1) {
          final review = reviews[reviewIndex];
          final List<String> helpfulVoters =
              List<String>.from(review['helpfulVoters'] ?? []);
          final List<String> notHelpfulVoters =
              List<String>.from(review['notHelpfulVoters'] ?? []);

          if (isHelpful) {
            if (!helpfulVoters.contains(currentUserId)) {
              helpfulVoters.add(currentUserId.toString());
              review['helpfulCount'] += 1;

              // Prevent the user from voting both up and down
              notHelpfulVoters.remove(currentUserId);
              review['notHelpfulCount'] = notHelpfulVoters.length;
            }
          } else {
            if (!notHelpfulVoters.contains(currentUserId)) {
              notHelpfulVoters.add(currentUserId.toString());
              review['notHelpfulCount'] += 1;

              // Prevent the user from voting both up and down
              helpfulVoters.remove(currentUserId);
              review['helpfulCount'] = helpfulVoters.length;
            }
          }

          // Update the review in the list
          reviews[reviewIndex] = {
            ...review,
            'helpfulVoters': helpfulVoters,
            'notHelpfulVoters': notHelpfulVoters,
          };

          // Update Firestore
          await propertyRef.update({'reviews': reviews});
        }
      }
    } catch (e) {
      print('Error updating vote: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('propertiesAll')
            .doc(widget.propertyId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No reviews found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final reviews = (data['reviews'] as List<dynamic>?)
                  ?.map((e) => Map<String, dynamic>.from(e))
                  .toList() ??
              [];

          return Column(
            children: [
              Expanded(
                child: reviews.isEmpty
                    ? Center(
                        child: Text(
                            'No reviews yet. Be the first to write one!\nScroll up to see review button'))
                    : ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          final timestamp = review['timestamp'] as Timestamp;
                          final formattedTimestamp = DateFormat('yyyy-MM-dd')
                              .format(timestamp.toDate());

                          return buildReviewTile(
                            review['reviewId'],
                            review['reviewerName'] ?? 'Anonymous',
                            review['reviewText'] ?? 'No review provided.',
                            formattedTimestamp,
                            review['rating'] ?? 0.0,
                            review['helpfulCount'] ?? 0,
                            review['notHelpfulCount'] ?? 0,
                            List<String>.from(review['helpfulVoters'] ?? []),
                            List<String>.from(review['notHelpfulVoters'] ?? []),
                          );
                        },
                      ),
              ),
              if (!hasReviewed)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1c275a),
                    ),
                    onPressed: _showAddReviewDialog,
                    child: Text('Write a Review'),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'You have already reviewed this property.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildReviewTile(
    String reviewId,
    String reviewerName,
    String reviewText,
    String timestamp,
    double rating,
    int helpfulCount,
    int notHelpfulCount,
    List<String> helpfulVoters,
    List<String> notHelpfulVoters,
  ) {
    final isHelpfulVoted = helpfulVoters.contains(currentUserId);
    final isNotHelpfulVoted = notHelpfulVoters.contains(currentUserId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/dp.png'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          reviewerName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          timestamp,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      reviewText,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 4.0),
            child: Row(
              children: [
                buildStarRating(rating),
                SizedBox(width: 25),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        if (!isHelpfulVoted) {
                          _updateVote(reviewId, true); // Thumbs-up action
                        }
                      },
                      icon: Icon(
                        isHelpfulVoted
                            ? Icons.thumb_up
                            : Icons.thumb_up_alt_outlined,
                        size: 24,
                        color: isHelpfulVoted ? Colors.blue : Colors.black,
                      ),
                      label: Text(helpfulCount.toString()),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        if (!isNotHelpfulVoted) {
                          _updateVote(reviewId, false); // Thumbs-down action
                        }
                      },
                      icon: Icon(
                        isNotHelpfulVoted
                            ? Icons.thumb_down
                            : Icons.thumb_down_alt_outlined,
                        size: 24,
                        color: isNotHelpfulVoted ? Colors.red : Colors.black,
                      ),
                      label: Text(notHelpfulCount.toString()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStarRating(double rating) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: const Color.fromARGB(255, 178, 164, 45),
            size: 20,
          );
        }),
        SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}
