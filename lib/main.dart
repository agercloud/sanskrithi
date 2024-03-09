import 'package:flutter/material.dart';
import 'package:sanskrithi/database/datacode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SqliteApp());
}

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  State<SqliteApp> createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  final textController = TextEditingController();
  final searchController = TextEditingController();
  bool isSearching = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            isSearching ? 'Search' : 'Add and Delete',
            style: TextStyle(color: Color.fromARGB(224, 219, 186, 0)),
          ),
          backgroundColor: Colors.black,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image2.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.center),
          ),
          child: Center(
            child: Column(
              children: [
                if (isSearching)
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Words',
                      hintText: ' Enter a keyword',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            labelText: 'Enter word',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () async {
                          final enteredText = textController.text.trim();
                          if (enteredText.isNotEmpty) {
                            await DatabaseHelper.instance
                                .addGrocery(Grocery(name: enteredText));
                            setState(() {
                              textController.clear();
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          final enteredText = textController.text.trim();
                          if (enteredText.isNotEmpty) {
                            await DatabaseHelper.instance.remove(enteredText);
                            setState(() {
                              textController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                Expanded(
                  child: FutureBuilder<List<Grocery>>(
                    future: DatabaseHelper.instance
                        .getGroceries(isSearching ? searchController.text : ''),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: Text('Loading...'));
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error loading!'),
                        );
                      }
                      return snapshot.data!.isEmpty
                          ? const Center(
                              child: Text('No  items found in the database.'))
                          : ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final grocery = snapshot.data![index];
                                return Center(
                                  child: ListTile(
                                    // onLongPress: () async {
                                    //   try {
                                    //     await DatabaseHelper.instance
                                    //         .remove(grocery.name);
                                    //     setState(() {});
                                    //   } catch (error) {
                                    //     print("Error removing: $error");
                                    //   }
                                    // },
                                    title: Text(grocery.name),
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            isSearching ? Icons.add : Icons.search,
            color: const Color.fromARGB(224, 219, 186, 0),
          ),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
              if (!isSearching) {
                textController.clear();
                searchController.clear();
              }
            });
          },
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
