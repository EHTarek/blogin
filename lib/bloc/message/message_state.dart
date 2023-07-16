part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class MessageInitial extends MessageState {
  @override
  List<Object> get props => [];
}

class MessageUpdateComplete extends MessageState {
  final String message;

  const MessageUpdateComplete({required this.message});

  @override
  List<Object?> get props => [];
}
