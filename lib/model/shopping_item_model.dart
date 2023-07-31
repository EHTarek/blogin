class ShoppingItemModel {
  String img;
  String name;
  int stock;
  double credit;
  double tk;

  ShoppingItemModel({required this.img,
    required this.name,
    required this.stock,
    required this.credit,
    required this.tk});

static List<ShoppingItemModel> shoppingItems = [
    ShoppingItemModel(
        img:
        'https://dr6svciluuqrd.cloudfront.net/products/gUWs7zKs77Gk8t0Jn9yy0u3VUDMWZ8Fdx6Yqm7Jq.png',
        name: '7UP Can 250 ml',
        stock: 10,
        credit: 25.00,
        tk: 25.00),
    ShoppingItemModel(
        img:
        'https://chaldn.com/_mpimage/mojo-can-250-ml?src=https%3A%2F%2Feggyolk.chaldal.com%2Fapi%2FPicture%2FRaw%3FpictureId%3D130799&q=best&v=1',
        name: 'Mojo Can 250 ml',
        stock: 10,
        credit: 25.00,
        tk: 25.00),
    ShoppingItemModel(
        img: 'https://m.media-amazon.com/images/I/61slsTqQruL.jpg',
        name: 'Sprite Can 250 ml',
        stock: 10,
        credit: 25.00,
        tk: 25.00),
    ShoppingItemModel(
        img:
        'https://chaldn.com/_mpimage/mountain-dew-can-250-ml?src=https%3A%2F%2Feggyolk.chaldal.com%2Fapi%2FPicture%2FRaw%3FpictureId%3D130891&q=best&v=1',
        name: 'Mountain Dew Can 250 ml',
        stock: 10,
        credit: 25.00,
        tk: 25.00),
    ShoppingItemModel(
        img:
        'https://springs.com.pk/cdn/shop/files/5449000008046.jpg?v=1686566601',
        name: 'Coca-Cola Can Slim 250 ml',
        stock: 10,
        credit: 25.00,
        tk: 25.00),
    ShoppingItemModel(
        img:
        'https://chaldn.com/_mpimage/speed-can-250-ml?src=https%3A%2F%2Feggyolk.chaldal.com%2Fapi%2FPicture%2FRaw%3FpictureId%3D134962&q=best&v=1',
        name: 'Speed Can 250 ml',
        stock: 10,
        credit: 25.00,
        tk: 25.00),
  ];

}