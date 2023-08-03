class ShoppingItemModel {
  int id;
  String img;
  String name;
  int stock;
  double credit;
  double tk;

  @override
  String toString() {
    return 'ShoppingItemModel{img: $img, name: $name, stock: $stock, credit: $credit, tk: $tk}';
  }

  ShoppingItemModel({
    required this.id,
    required this.img,
    required this.name,
    required this.stock,
    required this.credit,
    required this.tk,
  });

  factory ShoppingItemModel.fromJson(Map<String, dynamic> json) =>
      ShoppingItemModel(
        id: json['id'],
        img: json['img'],
        name: json['name'],
        stock: json['stock'],
        credit: json['credit'],
        tk: json['tk'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'img': img,
        'name': name,
        'stock': stock,
        'credit': credit,
        'tk': tk
      };

}
