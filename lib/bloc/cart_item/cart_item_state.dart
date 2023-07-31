part of 'cart_item_bloc.dart';

abstract class CartItemState extends Equatable {
  const CartItemState();
}

class CartItemInitial extends CartItemState {
  @override
  List<Object> get props => [];
}

class CartItemUpdateState extends CartItemState {
  final int count;
  final int itemIndex;

  const CartItemUpdateState({required this.count, required this.itemIndex});

  @override
  List<Object> get props => [];
}
