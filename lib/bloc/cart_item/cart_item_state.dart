part of 'cart_item_bloc.dart';

abstract class CartItemState extends Equatable {
  const CartItemState();
}

class CartItemInitial extends CartItemState {
  @override
  List<Object> get props => [];
}

class CartItemLoadingState extends CartItemState {
  @override
  List<Object> get props => [];
}

class CartItemLoadedState extends CartItemState {
  final List<ShoppingItemModel> cartItem;

  const CartItemLoadedState({required this.cartItem});

  @override
  List<Object> get props => [];
}

class CartItemAddToCartState extends CartItemState {
  final int quantity;
  const CartItemAddToCartState({required this.quantity});

  @override
  List<Object> get props => [];
}



class CartItemUpdateState extends CartItemState {
  final int quantity;
  const CartItemUpdateState({required this.quantity});

  @override
  List<Object> get props => [];
}

class CartItemErrorState extends CartItemState {
  @override
  List<Object> get props => [];
}
