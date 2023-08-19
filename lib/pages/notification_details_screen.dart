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
        builder: (context, notificationState) {
          if (notificationState is NotificationUpdatedState) {
            return ListView.builder(
              itemCount: notificationState.notification.length,
              itemBuilder: (context, index) => ListTile(
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
