part of 'mqtt_bloc.dart';

abstract class MqttEvent extends Equatable {
  const MqttEvent();
}

class MqttInitializeEvent extends MqttEvent {
  @override
  List<Object?> get props => [];
}


class MqttSendMessageEvent extends MqttEvent {
  final String msg;

  const MqttSendMessageEvent({required this.msg});

  @override
  List<Object?> get props => [];
}
