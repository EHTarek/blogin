import 'package:bloc/bloc.dart';
import 'package:blogin/services/db/notification_db_helper.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationUpdateEvent>((event, emit) async {
      emit(NotificationInitial());
      int qt = await NotificationDbHelper().getTotalQuantity();
      List<Map<String, dynamic>> notification =
      await NotificationDbHelper().getAllNotification();
      emit(NotificationUpdatedState(updatedCount: qt, notification: notification));
    });

  }
}
