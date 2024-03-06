class Review {
  String? key;
  ReviewData? reviewData;

  Review({this.key, this.reviewData});
}

class ReviewData {
  String? Iid;
  String? Rating;
  String? Text;
  String? Uid;
  String? Uname;

  ReviewData(
      {this.Iid, this.Rating, this.Text, this.Uid, this.Uname});
  ReviewData.fromJson(Map<dynamic, dynamic> json) {
    Iid = json["Iid"].toString();
    Rating = json["Rating"].toString();
    Text = json["Text"].toString();
    Uid = json["Uid"].toString();
    Uname = json["Uname"].toString();
  }
}