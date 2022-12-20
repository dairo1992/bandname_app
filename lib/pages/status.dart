import 'package:bandname_app/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    socketService.initConfig();
    return Scaffold(
      body: Center(
        child: Text('Hola Mundsdo'),
      ),
    );
  }
}
