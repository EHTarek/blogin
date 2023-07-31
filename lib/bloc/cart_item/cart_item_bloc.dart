import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cart_item_event.dart';

part 'cart_item_state.dart';

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  CartItemBloc() : super(CartItemInitial()) {

    int count = 0;

    on<AddToCartEvent>((event, emit) {
      count = 0;
      emit(CartItemInitial());
      emit(CartItemUpdateState(itemIndex: event.itemIndex, count: ++count));
    });

    on<CartItemIncrementEvent>((event, emit) {
      emit(CartItemInitial());
      emit(CartItemUpdateState(
          itemIndex: event.itemIndex, count: ++count));
    });

    on<CartItemDecrementEvent>((event, emit) {
      emit(CartItemInitial());
      if(count >1){
        emit(CartItemUpdateState(
            itemIndex: event.itemIndex, count: --count));
      }else{
        emit(CartItemInitial());
      }

    });
  }
}
