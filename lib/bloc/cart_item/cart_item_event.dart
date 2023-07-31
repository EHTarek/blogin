part of 'cart_item_bloc.dart';

abstract class CartItemEvent extends Equatable {
  final int itemIndex;

  const CartItemEvent({required this.itemIndex});
}

class AddToCartEvent extends CartItemEvent {
  const AddToCartEvent({required super.itemIndex});

  @override
  List<Object?> get props => [];
}

class CartItemIncrementEvent extends CartItemEvent {
  const CartItemIncrementEvent({required super.itemIndex});

  @override
  List<Object?> get props => [];
}

class CartItemDecrementEvent extends CartItemEvent {
  const CartItemDecrementEvent({required super.itemIndex});

  @override
  List<Object?> get props => [];
}
