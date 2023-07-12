import 'dart:convert';
import 'package:http/http.dart' as http;
class ApiService{
  Future getData(String employeeId, String password) async {
    try{
      final response = await http.post(
        Uri.parse('https://testemployee.get-aid.ltd/api/v1/user/login/'),
        body: jsonEncode({
          'employee_id': employeeId,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return [response.statusCode, jsonResponse['access']];

        // emit(LoginSuccess(token: jsonResponse['access']));
      } else {
        return [response.statusCode, jsonResponse['detail']];
        // emit(LoginFailure(error: jsonResponse['detail']));
      }

      print('login success 2');
    }catch(e){
      print('login success $e');

      // emit(const LoginFailure(error: ''));
    }

  }
}