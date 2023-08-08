import 'dart:async';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTClientService {
   MqttServerClient client = MqttServerClient.withPort(
      '36c24cffe29749baa0e3f6b7a8103f04.s2.eu.hivemq.cloud',
      '36c24cffe29749baa0e3f6b7a8103f04',
      8883);

  // late MqttServerClient client;

  // using async tasks, so the connection won't hinder the code flow
  /* Future<void> prepareMqttClient(*/ /*String msg*/ /*) async {
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic('flutter_test');
    // _publishMessage(msg);
  }*/
  Future<void> mqttConnect (
      {required String username,
      required String password,
      required String topic}) async {
    _setupMqttClient();
    await _connectClient(username, password);
    _subscribeToTopic(topic);
    receiveTopicMessage();
  }

  void sendMessage(String msg) {
    _publishMessage(msg);
  }

  // waiting for the connection, if an error occurs, print it and disconnect
  Future<void> _connectClient(String username, String password) async {
    try {
      await client.connect(username, password);
    } on Exception catch (e) {
      print('client exception - $e');
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort(
        '36c24cffe29749baa0e3f6b7a8103f04.s2.eu.hivemq.cloud',
        '36c24cffe29749baa0e3f6b7a8103f04',
        8883);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    print('Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atMostOnce);

    // print the message when it is received
    /*   client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      var message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      // print('YOU GOT A NEW MESSAGE:');
      print(message);
    });*/
  }

 /* receiveTopicMessage() {
    // print the message when it is received
    String message = 'msg';
    return client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print(message);
    });
    *//*print(message);
    return message;*//*
  }*/

  Stream<String> receiveTopicMessage() {
    // Create a StreamController to manage the stream of messages
    final StreamController<String> messageStreamController = StreamController<String>();

    // Listen to MQTT updates and add received messages to the stream
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print(message);
      messageStreamController.add(message); // Add the received message to the stream
    });

    // Return the stream from the StreamController
    return messageStreamController.stream;
  }


  void _publishMessage(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic ${'flutter_test'}');
    client.publishMessage(
        'flutter_test', MqttQos.exactlyOnce, builder.payload!);
  }

  // callbacks for different events
  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
  }

  void _onConnected() {
    print('OnConnected client callback - Client connection was successful');
  }
}
