import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_item/cart_item_bloc.dart';
import '../model/shopping_item_model.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping'),
        actions: [
          BlocBuilder<CartItemBloc, CartItemState>(
            builder: (context, itemState) {
              if (itemState is CartItemUpdateState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Badge(
                    label: Text(itemState.cartItem.length.toString()),
                    child: const Icon(Icons.add_shopping_cart),
                  ),
                );
              }

              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.add_shopping_cart),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => CartItem(index: index),
                childCount: ShoppingItemModel.shoppingItems.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                mainAxisExtent: 290,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final int index;

  const CartItem({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartItemBloc, CartItemState>(
      builder: (context, cartItemState) {
        return Card(
          color: Colors.white,
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                    width: double.maxFinite,
                    child: Image.network(
                      ShoppingItemModel.shoppingItems[index].img,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(color: Colors.black38),
                      Text(
                        ShoppingItemModel.shoppingItems[index].name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                          'Stock: ${ShoppingItemModel.shoppingItems[index].stock}'),
                      Text(
                          '${ShoppingItemModel.shoppingItems[index].credit.toStringAsFixed(2)} Cr'),
                      Text(
                        '${ShoppingItemModel.shoppingItems[index].tk.toStringAsFixed(2)} tk',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              if (cartItemState is CartItemInitial)
                Material(
                  color: Colors.lightBlue,
                  child: InkWell(
                    onTap: () {
                      context.read<CartItemBloc>().add(AddToCartEvent(
                            itemModel: ShoppingItemModel.shoppingItems[index],
                            id: ShoppingItemModel.shoppingItems[index].id,
                          ));
                      print('tapped');
                      print('Current index = $index');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      height: 40,
                      width: double.maxFinite,
                      child: const Text(
                        'Add Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              if (cartItemState is CartItemUpdateState)
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.zero,
                  // color: Colors.green,
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        color: Colors.green,
                        child: InkWell(
                          onTap: () {
                            context
                                .read<CartItemBloc>()
                                .add(CartItemDecrementEvent(
                                  itemModel:
                                      ShoppingItemModel.shoppingItems[index],
                                  id: ShoppingItemModel.shoppingItems[index].id,
                                ));

                            print('Current index = $index');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(cartItemState.cartItem.length.toString()),
                      // Text('0'),
                      Material(
                        color: Colors.green,
                        child: InkWell(
                          onTap: () {
                            context
                                .read<CartItemBloc>()
                                .add(CartItemIncrementEvent(
                                  itemModel:
                                      ShoppingItemModel.shoppingItems[index],
                                  id: ShoppingItemModel.shoppingItems[index].id,
                                ));

                            print('Current index = $index');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
