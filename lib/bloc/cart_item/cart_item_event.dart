part of 'cart_item_bloc.dart';

abstract class CartItemEvent extends Equatable {
  const CartItemEvent();
}

class CartItemLoadDataEvent extends CartItemEvent {
  @override
  List<Object?> get props => [];
}

class CartItemAddToCartEvent extends CartItemEvent {
  final ShoppingItemModel itemModel;
  final int index;

  const CartItemAddToCartEvent(
      {required this.itemModel, required this.index});

  @override
  List<Object?> get props => [];
}

/*class CartItemIncrementEvent extends CartItemEvent {
  final ShoppingItemModel itemModel;

  const CartItemIncrementEvent({required this.itemModel});

  @override
  List<Object?> get props => [];
}*/

class CartItemRemoveEvent extends CartItemEvent {
  final int index;

  const CartItemRemoveEvent({required this.index});

  @override
  List<Object?> get props => [];
}
