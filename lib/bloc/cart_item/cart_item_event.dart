part of 'cart_item_bloc.dart';

abstract class CartItemEvent extends Equatable {
  final ShoppingItemModel itemModel;
  final int id;

  const CartItemEvent({required this.itemModel, required this.id});
}

class AddToCartEvent extends CartItemEvent {
  const AddToCartEvent({required super.itemModel, required super.id});

  @override
  List<Object?> get props => [];
}

class CartItemIncrementEvent extends CartItemEvent {
  const CartItemIncrementEvent({required super.itemModel, required super.id});

  @override
  List<Object?> get props => [];
}

class CartItemDecrementEvent extends CartItemEvent {
  const CartItemDecrementEvent({required super.itemModel, required super.id});

  @override
  List<Object?> get props => [];
}
