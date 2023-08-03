part of 'cart_item_bloc.dart';

abstract class CartItemEvent extends Equatable {
  const CartItemEvent();
}

class CartItemAddToCartEvent extends CartItemEvent {
  final ShoppingItemModel item;
  final int index;

  const CartItemAddToCartEvent(
      {required this.item, required this.index});

  @override
  List<Object?> get props => [];
}

class CartItemRemoveEvent extends CartItemEvent {
  final int index;

  const CartItemRemoveEvent({required this.index});

  @override
  List<Object?> get props => [];
}
