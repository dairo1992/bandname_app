import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  // SocketService() {
  //   initConfig();
  // }

  void initConfig() {
    // Dart client
    IO.Socket socket = IO.io('http://http://127.0.0.1:3000/', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    socket.on('connect', (_) {
      print('connect');
    });
    socket.on('disconnect', (_) => print('disconnect'));
  }
}
