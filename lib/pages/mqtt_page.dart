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
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT'),
        actions: [
          BlocBuilder<MqttBloc, MqttState>(
            builder: (context, connState) {
              if (connState is MqttMessageUpdateState) {
                return IconButton(
                  onPressed: () {
                    context.read<MqttBloc>().add(MqttDisconnectEvent());
                  },
                  icon: const Icon(
                    Icons.stop_circle_outlined,
                    color: Colors.red,
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.stop_circle_outlined,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocBuilder<MqttBloc, MqttState>(
                builder: (context, mqttConnState) {
                  if (mqttConnState is MqttMessageUpdateState) {
                    return Column(
                      children: [
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
                                context.read<MqttBloc>().add(
                                      MqttSendMessageEvent(
                                          message: msgController.text),
                                    );

                                msgController.clear();
                                focusNode.unfocus();
                              },
                              child: const Text('Send'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Displaying Stream Message
                        if (mqttConnState.msgList.isNotEmpty)
                          Column(
                            children: [
                              const Text(
                                'All Messages',
                                style: TextStyle(fontSize: 24),
                              ),
                              const Divider(height: 2),
                              const SizedBox(height: 12),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: mqttConnState.msgList.length,
                                itemBuilder: (context, index) => ListTile(
                                  leading: const Icon(Icons.message),
                                  title: Text(
                                    mqttConnState.msgList.elementAt(index),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        // BlocBuilder<MqttBloc, MqttState>(
                        //   builder: (context, messageState) {
                        //     if (messageState is MqttMessageUpdateState &&
                        //         messageState.msgList.isNotEmpty) {
                        //       return Column(
                        //         children: [
                        //           const Text(
                        //             'All Messages',
                        //             style: TextStyle(fontSize: 24),
                        //           ),
                        //           const Divider(height: 2),
                        //           const SizedBox(height: 12),
                        //           ListView.builder(
                        //             primary: false,
                        //             shrinkWrap: true,
                        //             itemCount: messageState.msgList.length,
                        //             itemBuilder: (context, index) => ListTile(
                        //               leading: const Icon(Icons.message),
                        //               title: Text(
                        //                 messageState.msgList.elementAt(index),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       );
                        //     }
                        //     return const Center(
                        //       child: Text('No message found!'),
                        //     );
                        //   },
                        // ),
                      ],
                    );
                  }
                  return Row(
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
                          onPressed: () {
                            context.read<MqttBloc>().add(MqttInitializeEvent(
                                  username: usernameController.text,
                                  password: passwordController.text,
                                  topic: topicController.text,
                                ));
                          },
                          child: const Text('Connect'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
