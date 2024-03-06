import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crumbs_flutter_1/models/review_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/item_model.dart';



class PersonalReviewPage extends StatefulWidget{
  final String name;
  final String userId;
  PersonalReviewPage ({
    super.key,
    required this.name,
    required this.userId,

    //required this.link,
  });
  @override
  State<PersonalReviewPage> createState() => _PersonalReviewPageState();
}
class _PersonalReviewPageState extends State<PersonalReviewPage> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  late TextEditingController _searchController = TextEditingController();

  
  double Ratings = 0;
  List<double> listRatings = [];
  FocusNode _focusNode = FocusNode();
  List<Review> reviewsList = [];
  List<Review> filteredReviewsList = [];
  List<String> itemsIDList = [];
  List<Item> itemsList2 = [];
  Map<String, String> id_name_map = {};


  @override
  void initState() {
    super.initState();
    fetchReviewsForUser();
    fetchItemsForUser();
    Map<String, String> id_name_map = {};
    filteredReviewsList = reviewsList;
    setState(() {});
  }

  void fetchReviewsForUser() {
    reviewsList.clear();
    dbRef.child("Reviews").onChildAdded.listen((data) {
      ReviewData reviewData = ReviewData.fromJson(data.snapshot.value as Map);
      Review review = Review(key: data.snapshot.key, reviewData: reviewData);
      if (review.reviewData!.Uid == widget.userId) {
        itemsIDList.add(review.reviewData!.Iid!);
        reviewsList.add(review);
        
        Ratings += double.parse(review.reviewData!.Rating!);
      }
      setState(() {});
    });
  }

  void fetchItemsForUser() {
    
    dbRef.child("Items").onChildAdded.listen((data) {
      ItemData itemData = ItemData.fromJson(data.snapshot.value as Map);
      Item item = Item(key: data.snapshot.key, itemData: itemData);
      id_name_map[item.key!] = item.itemData!.name!;
      itemsList2.add(item);
      setState(() {});
    });
  }

  /*void filterItemsList(String query) {
    filteredReviewsList = reviewsList
        .where((entry) =>
            entry.reviewData!.Text!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }*/
  void filterItemsList(String query) {
    filteredReviewsList = reviewsList
        .where((entry) =>
          id_name_map[entry.reviewData!.Iid!]!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }

  Widget _buildItemInfo(String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(
              '$title ',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
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
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (id_name_map[review.reviewData!.Iid!] != null)
                      Text("Item: " + id_name_map[review.reviewData!.Iid!]!),
                    if (id_name_map[review.reviewData!.Iid!] == null)
                      Text("This item has been deleted", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                    Text('Username: ' + review.reviewData!.Uname!,
                        style: TextStyle(fontSize: 12)),
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
                        Text(' ${rating.toStringAsFixed(1)}',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(review.reviewData!.Text!),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 12,
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.green[900],
                size: 20,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Delete Review',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'Do you want to delete the review for ${id_name_map[review.reviewData!.Iid!] != null ? id_name_map[review.reviewData!.Iid!]! : 'the deleted item'}?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () async {
                            dbRef.child('Reviews').child(review.key!).remove();
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Success',
                                    style: TextStyle(
                                      color: Colors.green[800],
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    'The review has been successfully deleted.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            Navigator.of(context).pop();
                            fetchReviewsForUser();
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  },
                );
              },
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
      margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              _buildItemInfo('Item name:', item.itemData!.name!),
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
              _buildItemInfo('Item price:', item.itemData!.price!),
              _buildItemInfo('Item category:', item.itemData!.category!),
              _buildItemInfo('Item description:', item.itemData!.description!),
              _buildItemInfo('Item location:', item.itemData!.location!),
            ],
          ),
          Column()
        ],
      ),
    );
  }

  @override
  Widget build (BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Your Reviews",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Padding(padding: EdgeInsets.all(2),

      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            Autocomplete<Review>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Review>.empty();
                  } else {
                    return filteredReviewsList.where((element) => id_name_map[element.reviewData!.Iid!]!
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  }
                },
                fieldViewBuilder: (context,
                    TextEditingController fieldTextEditingController,
                    FocusNode focusNode,
                    onFieldSubmitted) {
                  _focusNode = focusNode;
                  _searchController = fieldTextEditingController;
                  return TextField(
                    onChanged: (value) => filterItemsList(value),
                    controller: fieldTextEditingController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.green[200]!)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.green[200]!)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.red[200]!)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.green[500]!)),
                      hintText: "Search for a review by item name",
                      prefixIcon: const Icon(Icons.search),
                    ),
                  );
                },
                optionsViewBuilder:
                    (context, Function(Review) onSelected, options) {
      
                  return Material(
                    elevation: 4,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          //Below is maybe placeholder? Maybe we can try to match icons with a list of icons that match item's category
                          leading: const Icon(Icons.exit_to_app_outlined),
                          visualDensity:
                              const VisualDensity(horizontal: 2, vertical: -1),
                          //Or perhaps add a category icon here (to the right)
                          minLeadingWidth: 20,
                          //trailing: IconDict[option.itemData!.category!],
                          tileColor: Colors.lightGreen[100],
                          onTap: () {
                            //onSelected(option.toString());
                            onSelected(option);
                          },
                          title: Text(
                            id_name_map[option.reviewData!.Iid!]!,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: options.length,
                    ),
                  );
                },
                /*onSelected: (selectedItem) {
                  filterItemsList(selectedItem.reviewData!.Text!);
                  setState(() {
                    _searchController.text = selectedItem.reviewData!.Text!;
                  });
                  _focusNode.unfocus();
                },*/
                onSelected: (selectedItem) {
                  filterItemsList(id_name_map[selectedItem.reviewData!.Iid!]!);
                  setState(() {
                    _searchController.text = id_name_map[selectedItem.reviewData!.Iid!]!;
                  });
                  _focusNode.unfocus();
                },
              ),
            SizedBox(height: 5),
            if (filteredReviewsList.isNotEmpty)
                for (int i = 0; i < filteredReviewsList.length; i++)
                  ReviewWidget(filteredReviewsList[i]),
            if (filteredReviewsList.isEmpty)
              Center(child: Text("No reviews available")),
            SizedBox(height: 10),
          ],
        ),
      ),),
    );
  }
}