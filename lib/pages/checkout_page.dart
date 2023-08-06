import 'package:blogin/pages/shopping_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogin/data/repository/shopping_item_repo.dart';
import '../bloc/cart_item/cart_item_bloc.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({super.key});

  final ShoppingItemRepo shoppingItemRepo = ShoppingItemRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: BlocBuilder<CartItemBloc, CartItemState>(
        buildWhen: (previous, current) => current is CartItemUpdateState,
        builder: (context, checkoutState) {
          if (checkoutState is CartItemUpdateState && checkoutState.quantity>0) {
            return ListView.separated(
              itemCount: checkoutState.dbItems.length,
              itemBuilder: (context, index) => ListTile(
                leading: Image.network(
                  shoppingItemRepo
                      .shoppingItems[checkoutState.dbItems.elementAt(index)].img,
                  fit: BoxFit.contain,
                ),
                title: Text(
                  shoppingItemRepo
                      .shoppingItems[checkoutState.dbItems.elementAt(index)].name,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Container(
                  // color: Colors.lightBlue,
                  width: 80,
                  padding: EdgeInsets.zero,
                  // color: Colors.green,
                  // height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        color: Colors.lightBlue,
                        child: InkWell(
                          onTap: () {
                            ShoppingPage.mainCount--;
                            context.read<CartItemBloc>().add(
                                CartItemRemoveEvent(
                                    index: checkoutState.dbItems.elementAt(index)));
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
                      Text(checkoutState
                          .idQuantityMap[checkoutState.dbItems.elementAt(index)]
                          .toString()),
                      Material(
                        color: Colors.lightBlue,
                        child: InkWell(
                          onTap: checkoutState.quantity < 3
                              ? () {
                            ShoppingPage.mainCount++;
                                  context
                                      .read<CartItemBloc>()
                                      .add(CartItemAddToCartEvent(
                                        item: shoppingItemRepo
                                            .shoppingItems[checkoutState.dbItems.elementAt(index)],
                                        index: shoppingItemRepo
                                            .shoppingItems[checkoutState.dbItems.elementAt(index)].id,
                                      ));
                                }
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Maximum cart item exceeded!'),
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
                ),
              ),
              separatorBuilder: (context, index) => const Divider(),
            );
          }
          return const Center(
            child: Text('Empty Cart'),
          );
        },
      ),
    );
  }
}
