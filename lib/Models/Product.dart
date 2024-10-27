class Product {
  String productName;
  int productPrice;
  String productDescription;
  String catergory;
  String productImg;
  int _sales;
  int rating = 0;

  Product({
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.productImg,
    required this.catergory,
  }) : this._sales = 1;


  int get sales => _sales;

  set sales(int value) {
    _sales = value;
  }
}
