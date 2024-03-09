import 'package:flutter/material.dart';
import 'package:sanskrithi/database/databasemain.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  String searchText = ''; // Store the search text in the state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search for groceries',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Update the search text in the state
                setState(() {
                  searchText = value;
                });
              },
            ),
            Expanded(
              child: FutureBuilder<List<Grocery>>(
                future: DatabaseHelper.instance.getGroceries(searchText),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No grocery items found.'));
                  } else {
                    return ListView.separated(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final grocery = snapshot.data![index];
                        return ListTile(
                          title: Text(grocery.name),
                          subtitle: Text(grocery.meaning),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
