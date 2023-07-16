import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/message/message_bloc.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MessageTop(),
          ),
          Expanded(
            child: MessageBottom(),
          ),
        ],
      ),
    );
  }
}

class MessageTop extends StatelessWidget {
  MessageTop({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, messageState) {
        if (messageState is MessageUpdateComplete) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.greenAccent,
            child: Center(
              child: Text(messageState.message),
            ),
          );
        }
        return const Center(
          child: Text('Loading...'),
        );
      },
    );
  }
}

class MessageBottom extends StatelessWidget {
  TextEditingController messageEditingController = TextEditingController();

  MessageBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.lightGreenAccent,
      child: Center(
        child: SizedBox(
          width: double.maxFinite,
          child: TextFormField(
            controller: messageEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter message here',
            ),
            onChanged: (value) {
              context
                  .read<MessageBloc>()
                  .add(MessageUpdate(message: messageEditingController.text));
            },
          ),
        ),
      ),
    );
  }
}
