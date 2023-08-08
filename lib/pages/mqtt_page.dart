import 'package:blogin/bloc/mqtt_bloc/mqtt_bloc.dart';
import 'package:blogin/services/mqtt_client_Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MqttPage extends StatefulWidget {
  const MqttPage({super.key});

  @override
  State<MqttPage> createState() => _MqttPageState();
}

class _MqttPageState extends State<MqttPage> {
  final TextEditingController msgController = TextEditingController();

  final TextEditingController usernameController =
      TextEditingController(text: 'ehtarek_1');

  final TextEditingController passwordController =
      TextEditingController(text: 'EHTarek123');

  final TextEditingController topicController =
      TextEditingController(text: 'flutter_test');

  final MQTTClientService myMqttService = MQTTClientService();
  List<String> topicMessage = [];
  bool showStream = false;
  FocusNode focusNode = FocusNode();

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
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 4),
                              labelText: 'Username',
                              hintText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 4),
                              labelText: 'Password',
                              hintText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: topicController,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 4),
                              labelText: 'Topic',
                              hintText: 'Topic',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: () async {
                          await myMqttService.mqttConnect(
                              username: usernameController.text,
                              password: passwordController.text,
                              topic: topicController.text);

                          showStream = true;
                          setState(() {});
                        },
                        child: const Text('Connect'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (showStream)
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      focusNode: focusNode,
                      maxLines: 3,
                      controller: msgController,
                      decoration: const InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 4),
                        labelText: 'Message',
                        hintText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      // context.read<MqttBloc>().add(MqttSendMessageEvent(msg: msgController.text));

                      myMqttService.sendMessage(msgController.text);
                      msgController.clear();
                      focusNode.unfocus();
                    },
                    child: const Text('Send'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (showStream)
                StreamBuilder<String>(
                  stream: myMqttService.receiveTopicMessage(),
                  // Call the function to get the message stream
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      topicMessage.add(snapshot.data!);
                      /*return Center(
                      child: Text('Received Message: ${snapshot.data}'),
                    );*/
                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: topicMessage.length,
                        itemBuilder: (context, index) => ListTile(
                          leading: const Icon(Icons.message),
                          title: Text(
                            topicMessage.elementAt(index),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
