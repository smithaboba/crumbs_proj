import 'package:crumbs_flutter_1/models/review_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/item_model.dart';

class ItemReviewPage extends StatefulWidget {
  final Item item;
  String userID;

  ItemReviewPage({
    required this.item,
    required this.userID,
  });

  @override
  _ItemReviewPageState createState() => _ItemReviewPageState();
}

class _ItemReviewPageState extends State<ItemReviewPage> {
  List<Review> reviewsList = [];
  double Ratings = 0;
  late DatabaseReference favRef = FirebaseDatabase.instance.reference().child('Favorites');
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
    fetchReviewsForItem();
  }

  void fetchReviewsForItem() {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    String itemId = widget.item.key!;

    dbRef.child("Reviews").onChildAdded.listen((data) {
      ReviewData reviewData = ReviewData.fromJson(data.snapshot.value as Map);
      Review review = Review(key: data.snapshot.key, reviewData: reviewData);
      if (review.reviewData!.Iid == itemId) {
        reviewsList.add(review);
        Ratings += double.parse(review.reviewData!.Rating!);
      }
      setState(() {});
    });
  }

  Future<void> checkIfFavorite() async {
    favRef.child(widget.userID).child(widget.item.key!).once().then((event) {
      if (event.snapshot.value != null) {
        isFavorite = true;
        setState(() {});
      }
    });
  }

  void toggleFavorite() {
    if (isFavorite) {
      favRef.child(widget.userID).child(widget.item.key!).remove();
    } else {
      favRef.child(widget.userID).child(widget.item.key!).set(true);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }


  Widget _buildItemInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemWidget(Item item) {
    double averageRating = reviewsList.isNotEmpty ? Ratings / reviewsList.length : 0.0;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Column(
        children: [
          _buildItemInfo('Item name', item.itemData!.name!),
          Row(
            children: [
              RatingBarIndicator(
                rating: averageRating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 18.0,
                unratedColor: Colors.grey[300],
                direction: Axis.horizontal,
              ),
              Text(
                ' ${averageRating.toStringAsFixed(1)}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
          _buildItemInfo('Item price', item.itemData!.price!),
          _buildItemInfo('Item category', item.itemData!.category!),
          _buildItemInfo('Item description', item.itemData!.description!),
          _buildItemInfo('Item location', item.itemData!.location!),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.green : Colors.green[700],
                ),
                onPressed: () {
                  toggleFavorite();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget ReviewWidget(Review review) {
    double rating = double.parse(review.reviewData!.Rating!);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ' + review.reviewData!.Uname!, style: TextStyle(fontSize: 12)),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 18.0,
                      unratedColor: Colors.grey[300],
                      direction: Axis.horizontal,
                    ),
                    Text(' ${rating.toStringAsFixed(1)}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
                SizedBox(height: 3),
                Text(review.reviewData!.Text!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //double positiveRatio = .8;
    String itemName = widget.item.itemData!.name!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "$itemName",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'About this item',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: itemWidget(widget.item),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'User reviews',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),

            SizedBox(height: 20),

            if (reviewsList.isNotEmpty)
              for (int i = 0; i < reviewsList.length; i++)
                ReviewWidget(reviewsList[i]),
            if (reviewsList.isEmpty)
              Center(child: Text("No reviews available")),

            // Center(
            //   child: ReviewRatioVisualizer(positiveRatio: positiveRatio),
            // ),
            // Container(
            //   margin: EdgeInsets.only(top: 32.0),
            //   child: Text(
            //     "stub",
            //     style: TextStyle(
            //       color: Colors.green,
            //       fontSize: 18.0,
            //     ),
            //   ),
            // ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
