class Item {
  String? key;
  ItemData? itemData;

  Item({this.key, this.itemData});
}

class ItemData {
  String? name;
  String? category;
  String? description;
  String? location;
  String? price;
  String? lat;
  String? long;
  String? Uid;
  ItemData(
      {this.name, this.category, this.description, this.location, this.price});
  ItemData.fromJson(Map<dynamic, dynamic> json) {
    name = json["name"].toString();
    category = json["category"].toString();
    description = json["description"].toString();
    location = json["location"].toString();
    price = json["price"].toString();
    lat = json["lat"].toString();
    long = json['long'].toString();
    Uid = json["Uid"].toString();
  }
}
