import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crumbs_flutter_1/models/review_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/item_model.dart';
import 'package:crumbs_flutter_1/screens/ReviewPage.dart';
import 'package:crumbs_flutter_1/screens/itemReviewPage.dart';
import 'package:crumbs_flutter_1/models/locations.dart';
import 'package:crumbs_flutter_1/models/categories.dart';




class PersonalFavoritePage extends StatefulWidget{
  final String name;
  GoogleSignInAccount? user;
  PersonalFavoritePage ({
    super.key,
    required this.name,
    required this.user,
    //required this.link,
  });
  @override
  State<PersonalFavoritePage> createState() => _PersonalFavoritePageState();
}
class _PersonalFavoritePageState extends State<PersonalFavoritePage> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  late TextEditingController _searchController = TextEditingController();
  final TextEditingController _updatePriceController = TextEditingController();

  Category? selectedCategory;
  Location? selectedLocation;


  
  double Ratings = 0;
  List<double> listRatings = [];
  FocusNode _focusNode = FocusNode();
  List<String> itemsIDList = [];
  List<Item> itemsList = [];
  List<Item> filteredItemsList = [];
  //Map<String, String> id_name_map = {};


  @override
  void initState() {
    super.initState();
    fetchItemsForUser();
    retrieveItemData();
    filteredItemsList = itemsList;
    setState(() {});
  }

  void fetchItemsForUser() {
    //print("HELLOOO");
    //dbRef.child("Favorites").child(widget.user!.id).onChildAdded.listen((data) {
    itemsIDList.clear();
    dbRef.child("Favorites").child(widget.user!.id).onChildAdded.listen((data) {
      //print("11111111");

      String key = data.snapshot.key!;
      itemsIDList.add(key);
      //print("KEYYYYYYYYYYYYY = " + key!);
      //print("VALUUEEE = " + data.snapshot.value.toString());
      //print("UIDDD = " + widget.user!.id);  
    });

    
    
    /*dbRef.child("Items").onChildAdded.listen((data) {
      ItemData itemData = ItemData.fromJson(data.snapshot.value as Map);
      Item item = Item(key: data.snapshot.key, itemData: itemData);
      if (itemsIDList.contains(data.snapshot.key)) {
        itemsList.add(item);
      }
      setState(() {});
    });*/

  }
  void filterItemsList(String query) {
    filteredItemsList = itemsList
        .where((entry) =>
          entry.itemData!.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }
  void retrieveItemData() {
    itemsList.clear();
    dbRef.child("Items").onChildAdded.listen((data) {
      ItemData itemData = ItemData.fromJson(data.snapshot.value as Map);
      Item item = Item(key: data.snapshot.key, itemData: itemData);
      if (itemsIDList.contains(data.snapshot.key)) {
        itemsList.add(item);
      }
      filteredItemsList =
          itemsList.where((e) => itemSatisfiesFilter(e)).toList();
      setState(() {});
    });
    
  }
  bool itemSatisfiesFilter(Item item) {
    bool correctCategory = item.itemData?.category == selectedCategory?.label ||
        selectedCategory?.label == 'Any' ||
        selectedCategory == null;
    bool correctLocation = item.itemData?.location == selectedLocation?.label ||
        selectedLocation?.label == 'Any' ||
        selectedLocation == null;
    return correctCategory && correctLocation;
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

  Widget ItemWidget2(Item item) {
    //Map<String, String> id_name_map = {};
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
                Text("Item: " + item!.itemData!.name!),
                SizedBox(height: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemWidget3(Item item) {
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
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 18.0,
                    unratedColor: Colors.grey[300],
                    direction: Axis.horizontal,
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
          "Your Favorite Items",
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
            Autocomplete<Item>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Item>.empty();
                  } else {
                    return filteredItemsList.where((element) => element.itemData!.name!
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
                      hintText: "Search for favorited items by name",
                      prefixIcon: const Icon(Icons.search),
                    ),
                  );
                },
                optionsViewBuilder:
                    (context, Function(Item) onSelected, options) {
      
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
                            option.itemData!.name!,
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
                onSelected: (selectedItem) {
                  filterItemsList(selectedItem.itemData!.name!);
                  setState(() {
                    _searchController.text = selectedItem.itemData!.name!!;
                  });
                  _focusNode.unfocus();
                },
              ),
            if (filteredItemsList.isNotEmpty)
                for (int i = 0; i < filteredItemsList.length; i++)
                  itemWidget(filteredItemsList[i]),
            if (filteredItemsList.isEmpty)
              Center(child: Text("No Favorited Items available")),
            
          ],
        ),
      ),),
    );
  }

  Widget itemWidget(Item item) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.itemData!.name!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(item.itemData!.price!, overflow: TextOverflow.ellipsis),
                  Text(item.itemData!.category!,
                      overflow: TextOverflow.ellipsis),
                  Text(item.itemData!.description!,
                      overflow: TextOverflow.ellipsis),
                  /* Text(item.itemData!.location!.contains(',')
                      ? item.itemData!.location!
                          .substring(0, item.itemData!.location!.indexOf(','))
                      : item.itemData!.location!)
                  */
                  Text(item.itemData!.location!,
                      overflow: TextOverflow.ellipsis)
                ],
              ),
            ),
            Column(
              children: [
                PopupMenuButton<String>(
                  onSelected: (choice) {
                    if (choice == 'Update Price') {
                      updatePriceDialog(key: item.key);
                    } else if (choice == 'Add Review') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(
                            title: "Review",
                            user: widget.user,
                            itemID: item.key!,
                            itemName: item.itemData!.name!,
                          ),
                        ),
                      );
                    } else if (choice == 'More Info') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemReviewPage(
                                item: item, userID: widget.user!.id),
                          ));
                    } else if (choice == 'Unfavorite') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Unfavorite Item',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              'Do you want to unfavorite ' + item.itemData!.name! + '?',
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
                                  dbRef.child('Favorites').child(widget.user!.id).child(item.key!).remove();
                                  setState(() {
                                  });
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
                                          item.itemData!.name! + ' has been successfully unfavorited.',
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
                                  fetchItemsForUser();
                                  retrieveItemData();
                                  setState(() {});
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Update Price', 'Add Review', 'More Info', 'Unfavorite']
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ],
        ));
  }

  void updatePriceDialog({String? key}) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _updatePriceController,
                        decoration:
                            const InputDecoration(labelText: 'Updated Price'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_updatePriceController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Missing Price"),
                                    content: const Text(
                                        "Please enter an item price."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK')),
                                    ],
                                  );
                                },
                              );
                            } else if (double.tryParse(
                                    _updatePriceController.text) ==
                                null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Invalid Price"),
                                    content: const Text(
                                        "Please enter a valid number for price."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK')),
                                    ],
                                  );
                                },
                              );
                            } else if (double.tryParse(
                                    _updatePriceController.text)! <
                                0.0) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Invalid Price"),
                                    content: const Text(
                                        "Please enter a valid number for price."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK')),
                                    ],
                                  );
                                },
                              );
                            } else {
                              dbRef
                                  .child("Items")
                                  .child(key!)
                                  .child("price")
                                  .set(double.tryParse(
                                          _updatePriceController.text)!
                                      .toStringAsFixed(2))
                                  .then((value) {
                                setState(() {});
                                Navigator.of(context).pop();
                              });
                            }
                          },
                          child: const Text("Update Price")),
                    ],
                  )));
        });
    _updatePriceController.clear();
    filteredItemsList = itemsList.where((e) => itemSatisfiesFilter(e)).toList();
  }
}