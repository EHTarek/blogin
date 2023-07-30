import 'package:flutter/material.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Image.network(
                          'https://nawon.com.vn/wp-content/uploads/2020/11/Orange-Juice-Drink-is-a-healthy-natural-product-500ml-Bottle-Brand-Nawon.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Divider(color: Colors.black38),
                      const Text(
                        'Juice 250 ml',
                        textAlign: TextAlign.center,
                      ),
                      const Text('Stock: 10'),
                      const Text('25.00 Cr'),
                      const Text(
                        '25.00 tk',
                        style:
                            TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.maxFinite,
                        child: MaterialButton(
                          color: Colors.blueAccent,
                          onPressed: () {},
                          child: const Text('Add Cart',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
                childCount: 10,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                mainAxisExtent: 250,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
