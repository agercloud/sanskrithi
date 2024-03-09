import 'package:flutter/material.dart';
import 'package:sanskrithi/database/databasemain.dart';
import 'package:sqflite/sqflite.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({Key? key}) : super(key: key);

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  final TextEditingController textController = TextEditingController();
  String searchText = ''; // Store the search text in the state

  Future<void> _deleteItem(String enteredText) async {
    if (enteredText.isNotEmpty) {
      await DatabaseHelper.instance.remove(enteredText);
      setState(() {
        textController.clear();
      });
    }
  }

  Future<List<Grocery>> _getGroceries(String name) async {
    return await DatabaseHelper.instance.getGroceries(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deleting'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                key: const ValueKey('search-field'),
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    labelText: 'Enter item to delete',
                  ),
                  onChanged: (value) {
                    // Update the search text in the state
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteItem(textController.text.trim());
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Grocery>>(
              future: _getGroceries(textController.text.trim()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('Loading...'));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading groceries!'),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return Center(child: Text('No grocery items found.'));
                }
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final grocery = snapshot.data![index];
                    return Center(
                      child: ListTile(
                          title: Text(grocery.name),
                          subtitle: Text(grocery.meaning),
                          trailing: IconButton(
                              onPressed: () async {
                                setState(() {
                                  DatabaseHelper.instance.remove(grocery.name);
                                });
                              },
                              icon: Icon(Icons.delete))),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
