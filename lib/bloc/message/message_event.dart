part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class MessageUpdate extends MessageEvent{
  final String message;
  const MessageUpdate({required this.message});

  @override
  List<Object?> get props => [];
}
