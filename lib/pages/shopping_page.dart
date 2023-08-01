import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_item/cart_item_bloc.dart';
import '../model/shopping_item_model.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartItemBloc>().add(CartItemLoadDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    List<ShoppingItemModel> cartItems = [];

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
                    label: Text(itemState.quantity.toString()),
                    child: const Icon(Icons.add_shopping_cart),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.add_shopping_cart),
                );
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<CartItemBloc, CartItemState>(
        listener: (context, cartListenerState) {
          if (cartListenerState is CartItemLoadedState) {
            cartItems = cartListenerState.cartItem;
            print(cartItems);
          }
        },
        builder: (context, cartLoadState) {
        /*  if (cartLoadState is CartItemLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }*/

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomScrollView(
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Card(
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
                                  cartItems[index].img,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Divider(color: Colors.black38),
                                  Text(
                                    cartItems[index].name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text('Stock: ${cartItems[index].stock}'),
                                  Text('${cartItems[index].credit} Cr'),
                                  Text(
                                    '${cartItems[index].tk} tk',
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
                          Material(
                            color: Colors.lightBlue,
                            child: InkWell(
                              onTap: () {
                                context.read<CartItemBloc>().add(
                                    CartItemIncrementEvent(
                                        itemModel: cartItems[index]));
                                print('Tapped at index = $index');
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

                          /*Container(
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
                              itemModel: allItems[index],
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
                      // Text(cartItemState.cartItem.length.toString()),
                      Text('0'),
                      Material(
                    color: Colors.green,
                    child: InkWell(
                      onTap: () {
                        context
                            .read<CartItemBloc>()
                            .add(CartItemIncrementEvent(
                              itemModel: allItems[index],
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
                ),*/
                        ],
                      ),
                    ),
                    childCount: cartItems.length,
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
          );
        },
      ),
    );
  }
}
