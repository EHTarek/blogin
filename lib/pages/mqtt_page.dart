import 'package:blogin/bloc/mqtt_bloc/mqtt_bloc.dart';
import 'package:blogin/services/mqtt_client_Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MqttPage extends StatelessWidget {
  MqttPage({super.key});

  final TextEditingController msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                maxLines: 3,
                controller: msgController,
                decoration: const InputDecoration(
                  hintText: 'Write your message here...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<MqttBloc>().add(MqttSendMessageEvent(msg: msgController.text));
                },
                child: const Text('Send'),
              ),
              const SizedBox(height: 24),
              const Text(''),
            ],
          ),
        ),
      ),
    );
  }

}
