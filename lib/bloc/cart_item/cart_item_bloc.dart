import 'package:bloc/bloc.dart';
import 'package:blogin/services/db_helper.dart';
import 'package:equatable/equatable.dart';

import '../../model/shopping_item_model.dart';

part 'cart_item_event.dart';

part 'cart_item_state.dart';

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  CartItemBloc() : super(CartItemInitial()) {
    DbHelper dbHelper = DbHelper();
    // ShoppingItemModel shoppingItemModel;
    // final List<ShoppingItemModel> cartItem = [];

    on<CartItemLoadDataEvent>((event, emit) async {
      emit(CartItemLoadingState());
      // Future.delayed(const Duration(microseconds: 500000));
      try {
        await dbHelper.init();

        emit(CartItemLoadedState(cartItem: ShoppingItemModel.shoppingItems));
      } catch (e) {
        print(e.toString());
        // emit(CartItemErrorState());
      }
    });

    /*   on<AddToCartEvent>((event, emit) async {
      try {
        await dbHelper.init();
        int count = await dbHelper.queryRowCount();
        // if (count < 3) {
          dbHelper.insert(event.itemModel.toJson());
          emit(CartItemUpdateState(quantity: count));
        // } else {
        //   emit(CartItemExceeded());
        // }
      } catch (e) {
        print(e.toString());
      }
    });*/

    on<CartItemIncrementEvent>((event, emit) async {
      emit(CartItemInitial());
      try {
        int count = await dbHelper.queryRowCount();

        print('DB : Item found $count');

        if (count < 3) {
          dbHelper.insert(event.itemModel.toJson());
          emit(CartItemUpdateState(quantity: count));
        } else {
          emit(CartItemErrorState());
        }
      } catch (e) {
        print(e.toString());
      }
    });

    on<CartItemDecrementEvent>((event, emit) async {
      int count = await dbHelper.queryRowCount();
      if (count > 1) {
        dbHelper.delete(event.itemModel.id);
        emit(CartItemUpdateState(quantity: count));
      } else {
        emit(CartItemInitial());
      }
    });
  }
}
