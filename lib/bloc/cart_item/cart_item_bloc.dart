import 'package:bloc/bloc.dart';
import 'package:blogin/services/db_helper.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/shopping_item_model.dart';
import '../../model/shopping_item_model.dart';

part 'cart_item_event.dart';

part 'cart_item_state.dart';

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  CartItemBloc() : super(CartItemInitial()) {
    DbHelper dbHelper = DbHelper();

    on<CartItemLoadDataEvent>((event, emit) async {
      emit(CartItemLoadingState());

      try{
        await dbHelper.init();
        emit(CartItemLoadedState());
      }catch(e){}



    });

    on<CartItemAddToCartEvent>((event, emit) async {
      emit(CartItemInitial());
      try {
        int totalQuantity = await dbHelper.getTotalQuantity();
        await dbHelper.dbInsert(item: event.item);

        List<int> dbItems = await dbHelper.getAllItems();

        emit(
            CartItemUpdateState(quantity: totalQuantity + 1, dbItems: dbItems));
      } catch (e) {
        print(e.toString());
      }
    });

    on<CartItemRemoveEvent>((event, emit) async {
      emit(CartItemInitial());
      try {
        int quantity =
            await dbHelper.removeItemAndUpdateQuantity(itemId: event.index);
        List<int> dbItems = await dbHelper.getAllItems();
        emit(CartItemUpdateState(quantity: quantity, dbItems: dbItems));
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
