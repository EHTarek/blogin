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
    context.read<CartItemBloc>().add(CartItemLoadDataEvent());

    return BlocConsumer<CartItemBloc, CartItemState>(
      buildWhen: (previous, current) =>
          previous != current && current is CartItemLoadedState,
      listener: (context, stateListener) {
        if (stateListener is CartItemLoadedState) {
          cartItems.addAll(stateListener.cartItem);
          print(cartItems);
        }

        if (stateListener is CartItemUpdateState) {
          if (stateListener.quantity > 3) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Cart Exceeded!'),
                content: const Text(
                    'You have taken maximum amount of item at once!'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close')),
                ],
              ),
            );
          }
        }
      },
      builder: (context, stateBuilder) {
        if (stateBuilder is CartItemLoadedState) {
          return Scaffold(
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
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // const Spacer(),
                              BlocBuilder<CartItemBloc, CartItemState>(
                                builder: (context, state) {
                                  if (state is CartItemUpdateState &&
                                      state.index == index &&
                                      state.quantity > 0) {
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
                                                context
                                                    .read<CartItemBloc>()
                                                    .add(CartItemRemoveEvent(
                                                        index: index));

                                                print('Current index = $index');
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                color: Colors.transparent,
                                                child: const Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(state.quantity.toString()),
                                          // Text('0'),
                                          Material(
                                            color: Colors.green,
                                            child: InkWell(
                                              onTap: () {
                                                context
                                                    .read<CartItemBloc>()
                                                    .add(CartItemAddToCartEvent(
                                                      itemModel:
                                                          cartItems[index],
                                                      index: index,
                                                    ));

                                                print('Current index = $index');
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2),
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
                                  if(state is CartItemUpdateState && index == state.dbItems.contains(index)) {
                                    return Material(
                                    color: Colors.lightBlue,
                                    child: InkWell(
                                      onTap: () {
                                        context
                                            .read<CartItemBloc>()
                                            .add(CartItemAddToCartEvent(
                                              itemModel: cartItems[index],
                                              index: index,
                                            ));
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
                                  );
                                  }
                                  return const Spacer();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: cartItems.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Colors.red),
          ),
        );
      },
    );
  }
}
