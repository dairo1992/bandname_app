import 'dart:io';

import 'package:bandname_app/models/bands_model.dart';
import 'package:bandname_app/services/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        actions: [
          IconButton(
            onPressed: addNewBand,
            icon: Icon(Icons.add, size: 30, color: Colors.blue),
          ),
          Container(
              margin: EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.offline_bolt, color: Colors.red))
        ],
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          // color: Colors.red,
          child: Column(children: [
            _showGraph(),
            socketService.serverStatus == ServerStatus.Online
                ? Expanded(
                    child: ListView.builder(
                        itemCount: bands.length,
                        itemBuilder: (context, i) {
                          return _bandTile(bands[i]);
                        }),
                  )
                : CircularProgressIndicator(),
          ])),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: addNewBand,
      //   child: Icon(Icons.add),
      //   elevation: 1,
      //   backgroundColor: Colors.blue[900],
      // ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
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
        onTap: (() => socketService.socket.emit('vote-band', {'id': band.id})),
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.isNotEmpty) {
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> map = Map.fromIterable(bands,
        key: (e) => e.name, value: (e) => e.votes.toDouble());

    Map<String, double> dataMap = {
      "Flutter": 5,
      "React": 3,
      "Xamarin": 2,
      "Ionic": 2,
    };
    final List<Color> colorList = [
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.pink,
      Colors.indigo,
      Colors.green,
    ];

    return Container(
      padding: const EdgeInsets.only(left: 10, top: 15),
      width: double.infinity,
      height: 250,
      child: PieChart(
        dataMap: map.isNotEmpty ? map : dataMap,
        chartType: ChartType.ring,
        baseChartColor: Colors.grey[50]!.withOpacity(0.15),
        colorList: colorList,
        centerText: "GENEROS",
        chartValuesOptions: const ChartValuesOptions(
          showChartValuesInPercentage: true,
          showChartValueBackground: false,
        ),
        // totalValue: 10,
      ),
    );
    // child: PieChart(
    //   dataMap: map.isNotEmpty ? map : dataMap,
    //   animationDuration: const Duration(milliseconds: 800),
    //   chartLegendSpacing: 32,
    //   chartRadius: MediaQuery.of(context).size.width / 3.2,
    //   colorList: colorList,
    //   initialAngleInDegree: 0,
    //   chartType: ChartType.ring,
    //   ringStrokeWidth: 32,
    //   centerText: "GENEROS",
    //   legendOptions: const LegendOptions(
    //     showLegendsInRow: false,
    //     legendPosition: LegendPosition.right,
    //     showLegends: true,
    //     legendShape: BoxShape.circle,
    //     legendTextStyle: TextStyle(
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   chartValuesOptions: const ChartValuesOptions(
    //     showChartValueBackground: true,
    //     showChartValues: true,
    //     showChartValuesInPercentage: false,
    //     showChartValuesOutside: false,
    //     decimalPlaces: 1,
    //   ),
    //   // gradientList: ---To add gradient colors---
    //   // emptyColorGradient: ---Empty Color gradient---
    // ));
  }
}
