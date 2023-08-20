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
      int qt = await notificationDbHelper.getTotalQuantity();
      List<Map<String, dynamic>> notification =
          await notificationDbHelper.getAllNotification();
      List<Map<String, dynamic>> seenNotification =
          await notificationDbHelper.getSeenNotification();
      emit(NotificationUpdatedState(
          updatedCount: qt,
          notification: notification,
          seenNotification: seenNotification));
    });


    on<NotificationRemoveEvent>((event, emit) async {
      emit(NotificationInitial());
      notificationDbHelper.removeItem(item: event.item);
      int qt = await notificationDbHelper.getTotalQuantity();
      List<Map<String, dynamic>> notification =
          await notificationDbHelper.getAllNotification();
      List<Map<String, dynamic>> seenNotification =
          await notificationDbHelper.getSeenNotification();
      if (qt > 0) {
        emit(NotificationUpdatedState(
            updatedCount: qt,
            notification: notification,
            seenNotification: seenNotification));
      } else {
        emit(NotificationInitial());
      }
    });

    on<NotificationSeenEvent>((event, emit) async {
      emit(NotificationInitial());
      notificationDbHelper.dbInsertSeenItem(item: event.item);

      int qt = await notificationDbHelper.getTotalQuantity();
      List<Map<String, dynamic>> notification =
          await notificationDbHelper.getAllNotification();
      List<Map<String, dynamic>> seenNotification =
          await notificationDbHelper.getSeenNotification();
      emit(NotificationUpdatedState(
          updatedCount: qt,
          notification: notification,
          seenNotification: seenNotification));
    });
  }
}
