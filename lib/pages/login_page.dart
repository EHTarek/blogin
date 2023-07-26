import 'package:blogin/navigation/preference_method.dart';
import 'package:blogin/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../bloc/login/login_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _employeeIdController = TextEditingController(text: 'tarikul');
  final _passwordController = TextEditingController(text: '1234');

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    getDeviceInfo();
    userLoggedIn();
  }

  @override
  Widget build(BuildContext context) {

    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        // body: BlocListener<LoginBloc, LoginState>(
        body: BlocConsumer<LoginBloc, LoginState>(
          // listenWhen: (previous, current) => previous != current && previous is LoginInitial,
          listener: (context, loginState) {
            if (loginState is LoginFailure) {
              context.loaderOverlay.hide();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loginState.error)),
              );
            }

            if (loginState is LoginInitial) {
              context.loaderOverlay.show();
            }

            if (loginState is LoginSuccess) {
              context.loaderOverlay.hide();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful')));

              // Navigator.pushReplacementNamed(context, '/home');
              Navigator.pushNamed(context, Routes.kHome);
            }
          },
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _employeeIdController,
                      decoration: const InputDecoration(
                        labelText: 'Employee ID',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        final employeeId = _employeeIdController.text;
                        final password = _passwordController.text;
                        context.read<LoginBloc>().add(LoginButtonPressed(
                              employeeId: employeeId,
                              password: password,
                            ));
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');
    print(androidInfo.id);
  }

  void userLoggedIn() async{
    PreferenceMethod preferenceMethod = PreferenceMethod();
    String? token = await preferenceMethod.getTokenAccess();
    if(token!.isNotEmpty){
      bool hasExpired = JwtDecoder.isExpired(token);
      if(!hasExpired){
        Navigator.pushReplacementNamed(context, Routes.kHome);
      }
    }
  }
}
