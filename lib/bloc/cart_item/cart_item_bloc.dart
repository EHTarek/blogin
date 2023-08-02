import 'package:bloc/bloc.dart';
import 'package:blogin/services/db_helper.dart';
import 'package:equatable/equatable.dart';

import '../../model/shopping_item_model.dart';

part 'cart_item_event.dart';

part 'cart_item_state.dart';

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  CartItemBloc() : super(CartItemInitial()) {
    DbHelper dbHelper = DbHelper();

    on<CartItemLoadDataEvent>((event, emit) async {
      emit(CartItemLoadingState());
      // Future.delayed(const Duration(microseconds: 500));
      try {
        await dbHelper.init();

        emit(CartItemLoadedState(cartItem: ShoppingItemModel.shoppingItems));
      } catch (e) {
        print(e.toString());
      }
    });

    on<CartItemAddToCartEvent>((event, emit) async {
      emit(CartItemInitial());

      try {
        int totalQuantity = await dbHelper.getTotalQuantity();
        if (totalQuantity <= 4) {
          dbHelper.dbInsert(item: event.itemModel, quantity: 1);
          emit(CartItemUpdateState(
              index: event.index, quantity: totalQuantity + 1));
        }
      } catch (e) {
        print(e.toString());
      }
    });

    on<CartItemRemoveEvent>((event, emit) async {
      // emit(CartItemInitial());
      try {
        int totalQuantity = await dbHelper.getTotalQuantity();
        if (totalQuantity >= 1) {
          dbHelper.removeItemAndUpdateQuantity(itemId: event.index);
          emit(CartItemUpdateState(
              index: event.index, quantity: totalQuantity - 1));
        }
        emit(CartItemInitial());
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
