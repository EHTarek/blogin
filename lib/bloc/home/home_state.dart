part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeUpdateDone extends HomeState {
  final String updateText;

  const HomeUpdateDone({required this.updateText});

  @override
  List<Object?> get props => [];
}
