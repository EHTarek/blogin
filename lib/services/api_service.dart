import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response> getData(String employeeId, String password) async {
    return http.post(
      Uri.parse('https://testemployee.get-aid.ltd/api/v1/user/login/'),
      body: jsonEncode({
        'employee_id': employeeId,
        'password': password,
        "device_id":"UPB3.230519.006"
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
