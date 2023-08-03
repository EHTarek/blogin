import 'package:blogin/data/repository/shopping_item_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_item/cart_item_bloc.dart';

class ShoppingPage extends StatelessWidget {
  ShoppingPage({super.key});

  final ShoppingItemRepo shoppingItemRepo = ShoppingItemRepo();

  @override
  Widget build(BuildContext context) {
    print('Inside build');
    int mainCount = 0;
    return BlocListener<CartItemBloc, CartItemState>(
      listener: (context, cartListenState) {
        if (cartListenState is CartItemUpdateState) {
          print('Inside Listener');
          if (cartListenState.quantity > 3) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Maximum cart item exceeded!')));
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping'),
          actions: [
            BlocBuilder<CartItemBloc, CartItemState>(
              buildWhen: (previous, current) => current is CartItemUpdateState,
              builder: (context, itemState) {
                if (itemState is CartItemUpdateState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Badge(
                      label: Text(itemState.quantity.toString()),
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
                  (context, index) {
                    int itemCount = 0;
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
                                  shoppingItemRepo.shoppingItems[index].img,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Divider(color: Colors.black38),
                                  Text(
                                    shoppingItemRepo.shoppingItems[index].name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                      'Stock: ${shoppingItemRepo.shoppingItems[index].stock}'),
                                  Text(
                                      '${shoppingItemRepo.shoppingItems[index].credit} Cr'),
                                  Text(
                                    '${shoppingItemRepo.shoppingItems[index].tk} tk',
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
                          BlocBuilder<CartItemBloc, CartItemState>(
                            builder: (context, addState) {
                              if (addState is CartItemUpdateState &&
                                  addState.dbItems.contains(index)) {
                                return Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.zero,
                                  // color: Colors.green,
                                  height: 40,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Material(
                                        color: Colors.green,
                                        child: InkWell(
                                          onTap: () {
                                            mainCount--;
                                            itemCount--;
                                            context.read<CartItemBloc>().add(
                                                CartItemRemoveEvent(
                                                    index: index));

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
                                      Text(itemCount.toString()),
                                      // Text('0'),
                                      Material(
                                        color: Colors.green,
                                        child: InkWell(
                                          onTap: addState.quantity < 3
                                              ? () {
                                                  mainCount++;
                                                  itemCount++;
                                                  context
                                                      .read<CartItemBloc>()
                                                      .add(
                                                          CartItemAddToCartEvent(
                                                        item: shoppingItemRepo
                                                                .shoppingItems[
                                                            index],
                                                        index: index,
                                                      ));

                                                  print(
                                                      'Current index = $index');
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
                                  onTap: mainCount < 3
                                      ? () {
                                          print('MainCount: $mainCount');
                                          mainCount++;
                                          itemCount++;
                                          context
                                              .read<CartItemBloc>()
                                              .add(CartItemAddToCartEvent(
                                                item: shoppingItemRepo
                                                    .shoppingItems[index],
                                                index: index,
                                              ));
                                          print('Tapped at index = $index');
                                        }
                                      : () {
                                          print('MainCount: $mainCount');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Maximum cart item exceeded!')));
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
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: shoppingItemRepo.shoppingItems.length,
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
      ),
    );
  }
}
