import 'package:blogin/services/logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notification/notification_bloc.dart';

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Notification'),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
      // buildWhen: (previous, current) => current is NotificationUpdatedState,
        builder: (context, notificationState) {
          if (notificationState is NotificationUpdatedState) {
            Log(notificationState.notification);
            Log(notificationState.seenNotification);

            return ListView.builder(
              itemCount: notificationState.notification.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  context.read<NotificationBloc>().add(NotificationSeenEvent(
                      item: notificationState.notification.elementAt(index)));

                  Log(notificationState.seenNotification.contains(
                      notificationState.notification.elementAt(index)));
                  Log(notificationState.notification.elementAt(index));
                },
                tileColor: notificationState.seenNotification.contains(
                        notificationState.notification.elementAt(index))
                    ? Colors.white
                    : Colors.grey.shade400,
                leading: const Icon(Icons.notifications),
                title: Text(
                  notificationState.notification
                      .elementAt(index)['title']
                      .toString(),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  notificationState.notification
                      .elementAt(index)['body']
                      .toString(),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () {
                    context.read<NotificationBloc>().add(
                        NotificationRemoveEvent(
                            item: notificationState.notification
                                .elementAt(index)));
                  },
                ),
              ),
            );
          }
          return const Center(
            child: Text('No notification found!'),
          );
        },
      ),
    );
  }
}
