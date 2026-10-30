// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_dialog.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<MyTimer> items = [];
  final _itemSet = <MyTimer>{};
  Timer? _timer;
  Timer? get timer => _timer;

  _ToDoListState(){
    startTimer();
  }

  void _handleListChanged(MyTimer item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(MyTimer item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText, TextEditingController textController, double? time) {
    setState(() {
      print("Adding new item");
      MyTimer item = MyTimer(name: itemText);
      item.timeRemaining = time ?? 10.0;
      items.insert(0, item);
      textController.clear();
    });
  }

  void startTimer() {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds:100), (timer) {
        setState(() {
          for (MyTimer item in items){
            if(!_itemSet.contains(item) && item.timeRemaining > 0.1){
              item.timeRemaining -= 0.1;
            }
            else if(!_itemSet.contains(item) && item.timeRemaining <= 0.1){
              _handleListChanged(item, false);
            }
          }
        });
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Timers'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return TimerListEntry(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return ToDoDialog(onListAdded: _handleNewItem);
                  });
                  
            }));

    
  }
  
}


void main() {
  runApp(MaterialApp(
    title: 'Timers',
    home: ToDoList(),
    theme: ThemeData(
      primaryColor:Colors.lightGreenAccent)
    )
  );
}
