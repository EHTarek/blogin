import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/shopping_item_model.dart';

part 'cart_item_event.dart';

part 'cart_item_state.dart';

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  CartItemBloc() : super(CartItemInitial()) {
    int count = 0;
    final List<Map<int, ShoppingItemModel>> cartItem = [];
    on<AddToCartEvent>((event, emit) {
      emit(CartItemInitial());
      cartItem.add({event.id: event.itemModel});
      emit(CartItemUpdateState(cartItem: cartItem));
    });

    on<CartItemIncrementEvent>((event, emit) {
      emit(CartItemInitial());
      cartItem.add({event.id: event.itemModel});
      emit(CartItemUpdateState(cartItem: cartItem));
    });

    on<CartItemDecrementEvent>((event, emit) {
      emit(CartItemInitial());

      if (cartItem.length > 1) {

        cartItem.removeWhere((element) => cartItem.contains({event.id:event.itemModel}));

        emit(CartItemUpdateState(cartItem: cartItem));
      } else {
        emit(CartItemInitial());
      }
    });
  }
}
