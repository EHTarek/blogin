part of 'mqtt_bloc.dart';

abstract class MqttState extends Equatable {
  const MqttState();
}

class MqttInitial extends MqttState {
  @override
  List<Object> get props => [];
}

class MqttMessageUpdateState extends MqttState {
  final List<String> msgList;

  const MqttMessageUpdateState({required this.msgList});

  @override
  List<Object> get props => [];
}