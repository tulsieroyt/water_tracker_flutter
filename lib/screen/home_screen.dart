import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController noOfWaterGlass = TextEditingController(text: '1');
  List<WaterTrack> waterConsumeList = [];
  int totalAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Water Consume',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  totalAmount.toString(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: noOfWaterGlass,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          int amount =
                              int.tryParse(noOfWaterGlass.text.trim()) ?? 1;
                          totalAmount += amount;
                          WaterTrack currentTime = WaterTrack(
                              time: DateTime.now(), noOfGlass: amount);
                          waterConsumeList.add(currentTime);
                          setState(() {});
                        },
                        child: const Text('Add')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: waterConsumeList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Warning'),
                            content: Text(
                                "Removed ${DateFormat('HH:mm:ss a dd:MM:yyyy').format(waterConsumeList[index].time)}'s water"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel')),
                              ElevatedButton(
                                  onPressed: () {
                                    removeItem(index);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Remove'))
                            ],
                          );
                        },
                      );
                    },
                    leading: CircleAvatar(
                      child: Text((index + 1).toString()),
                    ),
                    title: Text(
                      DateFormat('HH:mm:ss a    dd:MM:yyyy')
                          .format((waterConsumeList[index].time)),
                    ),
                    trailing: Text(
                      waterConsumeList[index].noOfGlass.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void removeItem(int index) {
    totalAmount = totalAmount - waterConsumeList[index].noOfGlass;
    waterConsumeList.removeAt(index);
    setState(() {});
  }
}

class WaterTrack {
  final DateTime time;
  final int noOfGlass;

  WaterTrack({required this.time, required this.noOfGlass});
}
