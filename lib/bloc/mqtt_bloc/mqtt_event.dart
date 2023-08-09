part of 'mqtt_bloc.dart';

abstract class MqttEvent extends Equatable {
  const MqttEvent();
}

class MqttInitializeEvent extends MqttEvent {
  final String username, password, topic;

  const MqttInitializeEvent({
    required this.username,
    required this.password,
    required this.topic,
  });

  @override
  List<Object?> get props => [];
}

class MqttSendMessageEvent extends MqttEvent {
  final String message;

  const MqttSendMessageEvent({required this.message});

  @override
  List<Object?> get props => [];
}

class MqttRequestMessageEvent extends MqttEvent {
  @override
  List<Object?> get props => [];
}

class MqttDisconnectEvent extends MqttEvent {
  @override
  List<Object?> get props => [];
}
