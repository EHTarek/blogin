import 'package:blogin/bloc/mqtt_bloc/mqtt_bloc.dart';
import 'package:blogin/data/repository/shopping_item_repo.dart';
import 'package:blogin/navigation/routes.dart';
import 'package:blogin/services/logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_item/cart_item_bloc.dart';

class ShoppingPage extends StatelessWidget {
  ShoppingPage({super.key});

  final ShoppingItemRepo shoppingItemRepo = ShoppingItemRepo();
  static int mainCount = 0;

  @override
  Widget build(BuildContext context) {
    print('Inside build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.kMqttPage);
              // context.read<MqttBloc>().add(MqttInitializeEvent());
            },
            icon: const Icon(Icons.app_shortcut_sharp),
          ),
          BlocBuilder<CartItemBloc, CartItemState>(
            buildWhen: (previous, current) => current is CartItemUpdateState,
            builder: (context, itemState) {
              if (itemState is CartItemUpdateState && itemState.quantity > 0) {
                return InkWell(
                  onTap: () {
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
                onTap: () {
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Card(
                    color: Colors.white,
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.kItemDetail,
                              arguments: shoppingItemRepo.shoppingItems[index],
                            );
                          },
                          child: Column(
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
                        ),
                        const Spacer(),
                        BlocBuilder<CartItemBloc, CartItemState>(
                          builder: (context, addState) {
                            if (addState is CartItemUpdateState &&
                                addState.dbItems.contains(index)) {
                              return Container(
                                // color: Colors.lightBlue,
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
                                      color: Colors.lightBlue,
                                      child: InkWell(
                                        onTap: () {
                                          mainCount--;
                                          context.read<CartItemBloc>().add(
                                              CartItemRemoveEvent(
                                                  index: index));

                                          Log('Current index = $index');
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
                                    Text(addState.idQuantityMap[index]
                                        .toString()),
                                    Material(
                                      color: Colors.lightBlue,
                                      child: InkWell(
                                        onTap: addState.quantity < 3
                                            ? () {
                                                mainCount++;
                                                context
                                                    .read<CartItemBloc>()
                                                    .add(CartItemAddToCartEvent(
                                                      item: shoppingItemRepo
                                                          .shoppingItems[index],
                                                      index: index,
                                                    ));

                                                Log('Current index = $index');
                                              }
                                            : () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Maximum cart item exceeded!'),
                                                  ),
                                                );
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
                                        Log('MainCount: $mainCount');
                                        mainCount++;

                                        context
                                            .read<CartItemBloc>()
                                            .add(CartItemAddToCartEvent(
                                              item: shoppingItemRepo
                                                  .shoppingItems[index],
                                              index: index,
                                            ));
                                        Log('Tapped at index = $index');
                                      }
                                    : () {
                                        Log('MainCount: $mainCount');
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
    );
  }
}
