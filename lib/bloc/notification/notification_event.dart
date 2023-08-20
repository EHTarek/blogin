part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {}

class NotificationUpdateEvent extends NotificationEvent {
  @override
  List<Object?> get props => [];
}

class NotificationRemoveEvent extends NotificationEvent {
  final Map<String, dynamic> item;

  NotificationRemoveEvent({required this.item});

  @override
  List<Object?> get props => [];
}

class NotificationSeenEvent extends NotificationEvent {
  final Map<String, dynamic> item;

  NotificationSeenEvent({required this.item});

  @override
  List<Object?> get props => [];
}
