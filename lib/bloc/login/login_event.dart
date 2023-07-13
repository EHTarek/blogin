part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String employeeId;
  final String password;

  const LoginButtonPressed({
    required this.employeeId,
    required this.password,
  });

  @override
  List<Object> get props => [];
}