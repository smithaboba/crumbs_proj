import 'package:crumbs_flutter_1/Widgets/my_textfield.dart';
import 'package:crumbs_flutter_1/screens/ReviewPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/item_model.dart';
import 'itemReviewPage.dart';
import '../models/categories.dart';
import '../models/locations.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.title, required this.user});

  final String title;
  GoogleSignInAccount? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

var googleAuth = null;

class _HomePageState extends State<HomePage> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final TextEditingController _updatePriceController = TextEditingController();
  late TextEditingController _searchController = TextEditingController();

  final TextEditingController categoryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  Category? selectedCategory;
  Location? selectedLocation;

  DatabaseReference favRef = FirebaseDatabase.instance.reference().child('Favorites');
  final List<DropdownMenuEntry<Category>> categories =
      <DropdownMenuEntry<Category>>[];
  final List<DropdownMenuEntry<Location>> locations =
      <DropdownMenuEntry<Location>>[];

  List<Item> itemsList = [];
  List<String> optionsList = [];
  List<Item> filteredItemsList = [];
  List<Image> imageIconList = [];
  var IconDict = {
    "Fresh Produce":    Image.asset('assets/images/vegetables.png'),
    "Dairy and Eggs":    Image.asset('assets/images/milk.png'),
    "Bakery":    Image.asset('assets/images/bakery.png'),
    "Meat and Seafood":    Image.asset('assets/images/meat.png'),
    "Frozen Foods":    Image.asset('assets/images/ice.png'),
    "Canned and Jarred Goods":    Image.asset('assets/images/bento.png'),
    "Pasta Rice and Grains":    Image.asset('assets/images/wheat.png'),
    "Baking and Cooking Supplies":    Image.asset('assets/images/whisk.png'),
    "Condiments and Sauces":    Image.asset('assets/images/sauce.png'),
    "Snacks":    Image.asset('assets/images/chips.png'),
    "Beverages":     Image.asset('assets/images/soda.png'),
    "Cereal and Breakfast Foods":    Image.asset('assets/images/cereal.png'),
    "Canned and Packaged Meals":    Image.asset('assets/images/can.png'),
    "Household and Cleaning Supplies":    Image.asset('assets/images/broom.png'),
    "Personal Care and Health":    Image.asset('assets/images/first_aid.png'),
    "Pet Supplies":    Image.asset('assets/images/pets.png'),
    "Alcohol":    Image.asset('assets/images/wine.png'),
    "International Foods":    Image.asset('assets/images/worldwide.png'),
    "Organic and Health Foods":    Image.asset('assets/images/organic.png'),
  };

  late int currentQueryINT;

  void filterItemsList(String query) {
    filteredItemsList = itemsList
        .where((entry) =>
            entry.itemData!.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    retrieveItemData();
    updateItemData();
    filteredItemsList = itemsList;
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    //Directory dir = Directory('.');
    // execute an action on each entry
    //dir.list(recursive: false).forEach((f) {
    //  print(f);
    //});
    categories.clear();
    locations.clear();
    for (final Category cat in Category.values) {
      categories.add(DropdownMenuEntry<Category>(value: cat, label: cat.label));
    }
    for (final Location loc in Location.values) {
      locations.add(DropdownMenuEntry<Location>(value: loc, label: loc.label));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Items")),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Autocomplete<Item>(
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
                    hintText: "Search for an item",
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
                        trailing: 
                        IconDict[option.itemData!.category!],
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
                  _searchController.text = selectedItem.itemData!.name!;
                });
                _focusNode.unfocus();
              },
            ),
          ),

          //Uncomment below if you want to see a row containing all the icons
          /*
          Padding(padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Image.asset('assets/images/vegetables.png'),
                Image.asset('assets/images/milk.png'),
                Image.asset('assets/images/bakery.png'),
                Image.asset('assets/images/meat.png'),
                Image.asset('assets/images/ice.png'),
                Image.asset('assets/images/bento.png'),
                Image.asset('assets/images/wheat.png'),
                Image.asset('assets/images/whisk.png'),
                Image.asset('assets/images/sauce.png'),
                Image.asset('assets/images/chips.png'),
                Image.asset('assets/images/wine.png'),
                Image.asset('assets/images/cereal.png'),
                Image.asset('assets/images/can.png'),
                Image.asset('assets/images/broom.png'),
                Image.asset('assets/images/first_aid.png'),
                Image.asset('assets/images/pets.png'),
                Image.asset('assets/images/wine.png'),
                Image.asset('assets/images/worldwide.png'),
                Image.asset('assets/images/organic.png'),
                Image.asset('assets/images/grocery-store.png')
              ],
            ),
          ),),*/
          if (filteredItemsList.isNotEmpty)
            for (int i = 0; i < filteredItemsList.length; i++)
              if (itemSatisfiesFilter(filteredItemsList[i]))
                itemWidget(filteredItemsList[i]),
            SizedBox(height:30),
          if (filteredItemsList.isEmpty)
            Center(child: Text("No items available")),
        ],
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            filterItemsDialog();
          },
          child: const Icon(Icons.filter_list)),
    );
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

  void filterItemsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: DropdownMenu<Category>(
                          dropdownMenuEntries: categories,
                          width: 250,
                          controller: categoryController,
                          label: const Text('Category'),
                          onSelected: (Category? cat) {
                            setState(() {
                              selectedCategory = cat;
                            });
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      child: DropdownMenu<Location>(
                          width: 250,
                          dropdownMenuEntries: locations,
                          controller: locationController,
                          label: const Text('Location'),
                          onSelected: (Location? loc) {
                            setState(() {
                              selectedLocation = loc;
                            });
                          }),
                    ),
                  ],
                )),
          ));
        });
  }

  void retrieveItemData() {
    dbRef.child("Items").onChildAdded.listen((data) {
      ItemData itemData = ItemData.fromJson(data.snapshot.value as Map);
      Item item = Item(key: data.snapshot.key, itemData: itemData);
      itemsList.add(item);
      optionsList = itemsList.map((entry) => entry.itemData!.name!).toList();
      filteredItemsList =
          itemsList.where((e) => itemSatisfiesFilter(e)).toList();
      setState(() {});
    });
  }

  void updateItemData() {
    dbRef.child("Items").onChildChanged.listen((data) {
      int index =
          itemsList.indexWhere((element) => element.key == data.snapshot.key);
      itemsList.removeAt(index);
      ItemData itemData = ItemData.fromJson(data.snapshot.value as Map);
      Item item = Item(key: data.snapshot.key, itemData: itemData);
      itemsList.insert(index, item);
      optionsList = itemsList.map((entry) => entry.itemData!.name!).toList();
      filteredItemsList =
          itemsList.where((e) => itemSatisfiesFilter(e)).toList();
      setState(() {});
    });
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
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Update Price', 'Add Review', 'More Info']
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
}