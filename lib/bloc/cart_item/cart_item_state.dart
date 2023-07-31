part of 'cart_item_bloc.dart';

abstract class CartItemState extends Equatable {
  const CartItemState();
}

class CartItemInitial extends CartItemState {
  @override
  List<Object> get props => [];
}

class CartItemUpdateState extends CartItemState {
  // final ShoppingItemModel itemModel;
  final List<Map<int, ShoppingItemModel>> cartItem;

  const CartItemUpdateState({required this.cartItem});

  @override
  List<Object> get props => [];
}
