enum Category {
  any('Any'),
  dairy('Dairy and Eggs'),
  bakery('Bakery'),
  meat('Meat and Seafood'),
  frozen('Frozen Foods'),
  canned('Canned and Jarred Goods'),
  grains('Pasta Rice and Grains'),
  supplies("Baking and Cooking Supplies"),
  sauces("Condiments and Sauces"),
  snacks("Snacks"),
  beverages("Beverages"),
  cereals("Cereal and Breakfast Foods"),
  meals("Canned and Packaged Meals"),
  household("Household and Cleaning Supplies"),
  care("Personal Care and Health"),
  pets("Pet Supplies"),
  alcohol("Alcohol"),
  international("International Foods"),
  organic("Organic and Health Foods");

  const Category(this.label);
  final String label;
}
