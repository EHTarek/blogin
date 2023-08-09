import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blogin/services/mqtt_client_Service.dart';
import 'package:equatable/equatable.dart';

part 'mqtt_event.dart';

part 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  MqttBloc() : super(MqttInitial()) {
    MQTTClientService myMqttService = MQTTClientService();
    List<String> streamMessage = [];
    on<MqttInitializeEvent>((event, emit) async {
      emit(MqttInitial());
      await myMqttService.mqttConnect(
        username: event.username,
        password: event.password,
        topic: event.topic,
      );
      emit(MqttMessageUpdateState(msgList: streamMessage));

      // Listen MQTT Stream Message
      myMqttService.receiveTopicMessage().listen((message) {
        print('Received message inside mqtt_bloc: $message');
        streamMessage.add(message);
        // emit(MqttMessageUpdateState(msgList: streamMessage));
        add(MqttRequestMessageEvent());
      });
    });

    on<MqttSendMessageEvent>((event, emit) {
      myMqttService.sendMessage(event.message);
    });

    on<MqttRequestMessageEvent>((event, emit) {
      emit(MqttInitial());
      emit(MqttMessageUpdateState(msgList: streamMessage));
    });
    on<MqttDisconnectEvent>((event, emit) {
      streamMessage.clear();
      myMqttService.disconnectClient();
      emit(MqttInitial());
    });
  }
}
