import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:blogin/navigation/preference_method.dart';
import 'package:blogin/services/api_service.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';

import 'package:http/src/response.dart';

import '../../data/model/login_model.dart';


part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginInitial());

    PreferenceMethod preferenceMethod = PreferenceMethod();
    late Response response;
    try {
      response = await ApiService().getData(event.employeeId, event.password);
       // print(response.body);

      LoginModel loginModel = LoginModel.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200) {
        print('login success ==== login bloc =========');
        // emit(LoginSuccess(token: jsonResponse['access']));
        preferenceMethod.setTokenAccess(loginModel.access);
        preferenceMethod.setTokenRefresh(loginModel.refresh);
        emit(LoginSuccess());
      } else {
        // emit(LoginFailure(error: response['detail']));

        emit(LoginFailure(error: jsonDecode(response.body)['detail']));
        emit(const LoginFailure(error: 'Got an error!'));
      }

      // print('login success 2');
    } catch (e) {
      print('Error in Login Bloc:  $e');
      emit(const LoginFailure(error: 'error'));
    }
  }
}
