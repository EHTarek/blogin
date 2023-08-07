import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blogin/services/mqtt_client_Service.dart';
import 'package:equatable/equatable.dart';

part 'mqtt_event.dart';
part 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  MqttBloc() : super(MqttInitial()) {

    on<MqttInitializeEvent>((event, emit) async {
      await MQTTClientService().prepareMqttClient();
    });

    on<MqttSendMessageEvent>((event, emit) {
      MQTTClientService().sendMessage(event.msg);
    });
  }
}
