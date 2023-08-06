import 'package:blogin/data/model/shopping_item_model.dart';
import 'package:blogin/navigation/routes.dart';
import 'package:blogin/pages/shopping_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_item/cart_item_bloc.dart';
import '../services/logs.dart';

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({super.key, required this.item});

 final ShoppingItemModel item;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name, overflow: TextOverflow.ellipsis),
        actions: [
          BlocBuilder<CartItemBloc, CartItemState>(
            buildWhen: (previous, current) => current is CartItemUpdateState,
            builder: (context, itemState) {
              if (itemState is CartItemUpdateState && itemState.quantity > 0) {
                return InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, Routes.kCheckout);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Badge(
                      label: Text(itemState.quantity.toString()),
                      child: const Icon(Icons.add_shopping_cart),
                    ),
                  ),
                );
              }
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, Routes.kCheckout);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.add_shopping_cart),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 150,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(),
              ),
              child: Image.network(item.img),
            ),
            const SizedBox(height: 16),
            BlocBuilder<CartItemBloc, CartItemState>(
              builder: (context, addState) {
                if (addState is CartItemUpdateState &&
                    addState.dbItems.contains(item.id)) {
                  return Container(
                    width: 200,
                    padding: EdgeInsets.zero,
                    // color: Colors.green,
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                          color: Colors.lightBlue,
                          child: InkWell(
                            onTap: () {
                              ShoppingPage.mainCount--;
                              context.read<CartItemBloc>().add(
                                  CartItemRemoveEvent(
                                      index: item.id));

                              Log('Current index = ${item.id}');
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
                        Text(addState.idQuantityMap[item.id]
                            .toString()),
                        Material(
                          color: Colors.lightBlue,
                          child: InkWell(
                            onTap: addState.quantity < 3
                                ? () {
                              ShoppingPage.mainCount++;
                              context
                                  .read<CartItemBloc>()
                                  .add(
                                  CartItemAddToCartEvent(
                                    item: item,
                                    index: item.id,
                                  ));

                              Log('Current index = ${item.id}');
                            }
                                : () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Maximum cart item exceeded!')));
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
                  );
                }

                return Material(
                  color: Colors.lightBlue,
                  child: InkWell(
                    onTap: ShoppingPage.mainCount < 3
                        ? () {
                      Log('MainCount: $ShoppingPage.mainCount');
                      ShoppingPage.mainCount++;
                      context
                          .read<CartItemBloc>()
                          .add(CartItemAddToCartEvent(
                        item: item,
                        index: item.id,
                      ));
                      Log('Tapped at index = ${item.id}');
                    }
                        : () {
                      Log('MainCount: $ShoppingPage.mainCount');
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                          content: Text(
                              'Maximum cart item exceeded!')));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      height: 40,
                      child: const Text(
                        'Add Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            //Item Name
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(item.name ?? ''),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            //Item Quantity
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Weight/Qty',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('1'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
