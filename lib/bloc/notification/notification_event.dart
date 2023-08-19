part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {}

class NotificationUpdateEvent extends NotificationEvent {
  @override
  List<Object?> get props => [];
}
