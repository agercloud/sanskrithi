import 'package:flutter/material.dart';
import 'package:sanskrithi/database/databasemain.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final textController = TextEditingController();
  final textController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 500,
            width: 500,
            child: Column(
              children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    labelText: 'Enter name',
                  ),
                ),
                TextField(
                  controller: textController2,
                  decoration: InputDecoration(
                    labelText: 'Enter meaning',
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final name = textController.text.trim();
                    final meaning = textController2.text.trim();
                    if (name.isNotEmpty) {
                      await DatabaseHelper.instance.addGrocery(
                        Grocery(name: name, meaning: meaning),
                      );
                      setState(() {
                        textController.clear();
                        textController2.clear();
                      });
                      // Call a separate function to refresh
                    }
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
