import 'dart:io';

import 'package:bandname_app/models/bands_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Pop', votes: 3),
    Band(id: '3', name: 'Vallenato', votes: 8),
    Band(id: '4', name: 'ranchera', votes: 6),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, i) {
            return _bandTile(bands[i]);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: Icon(Icons.add),
        elevation: 1,
        backgroundColor: Colors.blue[900],
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => {print(direction.toString())},
      background: Container(
        padding: EdgeInsets.only(left: 10),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: const [
              Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              Icon(Icons.delete, color: Colors.white),
            ],
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[900],
          child: Text(
            band.name.substring(0, 2),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}'),
        onTap: (() {
          print(band.name);
        }),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (!Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Nueva band:"),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  onPressed: () => addBandToList(textController.text),
                  elevation: 1,
                  textColor: Colors.white,
                  color: Colors.blue[900],
                  child: Text("Add"),
                )
              ],
            );
          });
    } else {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("Nueva band:"),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text("Add"),
                  onPressed: () => addBandToList(textController.text),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text("Cancelar"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
    }
  }

  void addBandToList(String name) {
    if (name.isNotEmpty) {
      bands.add(Band(id: DateTime.now().toString(), name: name));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
