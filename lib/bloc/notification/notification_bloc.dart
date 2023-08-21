import 'package:bloc/bloc.dart';
import 'package:blogin/services/db/notification_db_helper.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationDbHelper notificationDbHelper = NotificationDbHelper();

  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationUpdateEvent>((event, emit) async {
      emit(NotificationInitial());
      int count = await notificationDbHelper.getUnseenNotificationCount();
      List<Map<String, dynamic>> notification =
          await notificationDbHelper.getAllNotification();

      emit(NotificationUpdatedState(
          updatedCount: count,
          notification: notification));
    });


    on<NotificationRemoveEvent>((event, emit) async {
      emit(NotificationInitial());
      await notificationDbHelper.removeItem(item: event.item);
      int count = await notificationDbHelper.getUnseenNotificationCount();
      List<Map<String, dynamic>> notification =
          await notificationDbHelper.getAllNotification();

        emit(NotificationUpdatedState(
            updatedCount: count,
            notification: notification));

    });

    on<NotificationSeenEvent>((event, emit) async {
      emit(NotificationInitial());
      await notificationDbHelper.toggleSeenValue(itemId: event.itemId);

      int count = await notificationDbHelper.getUnseenNotificationCount();
      List<Map<String, dynamic>> notification =
          await notificationDbHelper.getAllNotification();
      emit(NotificationUpdatedState(
          updatedCount: count,
          notification: notification));
    });

    on<AllNotificationSeenEvent>((event, emit) async {
      emit(NotificationInitial());
      await notificationDbHelper.makeAllSeen();

      int count = await notificationDbHelper.getUnseenNotificationCount();
      List<Map<String, dynamic>> notification =
      await notificationDbHelper.getAllNotification();
      emit(NotificationUpdatedState(
          updatedCount: count,
          notification: notification));
    });
  }
}
