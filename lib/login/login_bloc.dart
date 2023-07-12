import 'dart:async';
import 'dart:math';
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

  Future<void> _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {

    emit(LoginInitial());


    // Handle the LoginButtonPressed event
    // Call your API or perform any necessary login logic here
    print('login success');

    try{
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
        emit(LoginSuccess(token: jsonResponse['access']));
      } else {
        emit(LoginFailure(error: jsonResponse['detail']));
      }

      print('login success 2');
    }catch(e){
      print('login success @#$e');

      emit(const LoginFailure(error: ''));
    }


  }

}
