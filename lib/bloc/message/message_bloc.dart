import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitial()) {
    on<MessageUpdate>((event, emit) {
      emit(MessageInitial());
      print('Message Bloc: ${event.message}');
      emit(MessageUpdateComplete(message: event.message));
    });
  }
}
