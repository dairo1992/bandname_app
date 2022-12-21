import 'dart:ffi';

import 'package:bandname_app/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text('Server status: ${socketService.serverStatus}'),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            socketService.socket.emit(
                'emitir-mensaje', {'nombre': 'Wen', 'mensaje': 'Hola wen'});
          },
          child: Icon(Icons.send_sharp),
        ));
  }
}
