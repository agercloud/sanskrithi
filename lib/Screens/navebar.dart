import 'package:flutter/material.dart';
import 'package:sanskrithi/Screens/pages/homepage.dart';
import 'package:sanskrithi/Screens/pages/deletepage.dart';
import 'package:sanskrithi/Screens/pages/addpage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final screen = [HomePage(), DeletePage(), AddPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[index], // Change here
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(indicatorColor: Colors.blueAccent),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() {
            this.index = index;
          }),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.delete),
              label: "Delete",
            ),
            NavigationDestination(
              icon: Icon(Icons.add),
              label: "Add",
            )
          ],
        ),
      ),
    );
  }
}
// Change here