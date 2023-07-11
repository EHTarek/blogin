import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  void _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) {
    // Handle the LoginButtonPressed event
    // Call your API or perform any necessary login logic here
    print('login success');

  }



  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final response = await http.post(
          Uri.parse('https://testemployee.get-aid.ltd/api/v1/user/login/'),
          body: jsonEncode({
            'employee_id': event.employeeId,
            'password': event.password,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        final jsonResponse = jsonDecode(response.body);

        if (response.statusCode == 200) {
          yield LoginSuccess(token: jsonResponse['token']);
        } else {
          yield LoginFailure(error: jsonResponse['detail']);
        }
      } catch (error) {
        yield const LoginFailure(error: 'Failed to connect to the server');
      }
    }
  }
}
