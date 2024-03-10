import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sanskrithi/database/databasemain.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final textController = TextEditingController();
  final textController2 = TextEditingController();
  bool isLoading = false;
  bool isAdded = false;
  bool isEmpty = false; // Track if the text fields are empty

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.book,
                size: 100,
              ),
              const SizedBox(height: 50),
              Text(
                'Sanskrithi',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Word',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: textController2,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Meaning',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200.0, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: isEmpty
                    ? Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 40,
                      )
                    : isAdded
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 40,
                          )
                        : isLoading
                            ? SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              )
                            : Text("ADD"),
                onPressed: () {
                  // Check if text fields are empty
                  if (textController.text.isEmpty) {
                    setState(() {
                      isEmpty = true;
                      textController.clear();
                      textController2.clear();
                    });
                    // Reset isEmpty after 1 second
                    Timer(Duration(seconds: 1), () {
                      setState(() {
                        isEmpty = false;
                      });
                    });
                    return;
                  }

                  if (!isLoading && !isAdded) {
                    startLoad();
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void startLoad() async {
    setState(() {
      isLoading = true;
    });

    // Simulate addition process
    await Future.delayed(Duration(seconds: 1));

    // After addition, set isAdded to true and isLoading to false
    setState(() {
      isLoading = false;
      isAdded = true;
    });

    // Reset isAdded after a delay
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isAdded = false;
      final name = textController.text.trim();
      final meaning = textController2.text.trim();
      if (name.isNotEmpty) {
        DatabaseHelper.instance.addGrocery(
          Grocery(name: name, meaning: meaning),
        );
        setState(() {
          textController.clear();
          textController2.clear();
        });
        // Call a separate function to refresh
      }
    });
  }
}
