part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeTextUpdate extends HomeEvent {
  final String newText;
  const HomeTextUpdate({required this.newText});
  @override
  List<Object?> get props => [];
}
