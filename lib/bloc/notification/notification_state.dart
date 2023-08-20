part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {}

class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationUpdatedState extends NotificationState {
  final int updatedCount;
  final List<Map<String, dynamic>> notification;
  final List<Map<String, dynamic>> seenNotification;

  NotificationUpdatedState(
      {required this.updatedCount, required this.notification, required this.seenNotification});

  @override
  List<Object> get props => [];
}
