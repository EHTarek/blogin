import 'package:blogin/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _employeeIdController = TextEditingController(text: 'django123');
  final _passwordController = TextEditingController(text: '123456');

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      // body: BlocListener<LoginBloc, LoginState>(
      body: BlocConsumer<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous != current && previous is LoginInitial,
        listener: (context, loginState) {
          if (loginState is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loginState.error)),
            );
          } else if (loginState is LoginSuccess) {
            if (mounted) {

              context.loaderOverlay.show();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successful')),
              );

            // Navigator.pushReplacementNamed(context, '/home');
            Navigator.pushNamed(context, Routes.kHome, arguments: loginState.token);
            }
            // context.loaderOverlay.hide();
            ///
          }
        },
        // child: BlocBuilder<LoginBloc, LoginState>(
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

                        loginBloc.add(LoginButtonPressed(
                          employeeId: employeeId,
                          password: password,
                        ));
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 16),
                    if (state is LoginLoading)
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          },
        // ),
      ),
    );
  }
}
