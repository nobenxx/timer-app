import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/item.dart';

typedef ToDoListChangedCallback = Function(MyTimer item, bool completed);
typedef ToDoListRemovedCallback = Function(MyTimer item);

class TimerListEntry extends StatefulWidget {
  TimerListEntry(
      {required this.item,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem})
      : super(key: ObjectKey(item));

  final MyTimer item;
  final bool completed;

  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

  


  @override
  State<TimerListEntry> createState(){
     return _CountDownState();
  } 
 // CHANGE COLOR
  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

}
class _CountDownState extends State<TimerListEntry> {
    //https://api.flutter.dev/flutter/dart-async/Timer-class.html
    @override
    void dispose() {
      super.dispose();
    }
    @override
    Widget build(BuildContext context){
      return ListTile(
      onTap: () {
        widget.onListChanged(widget.item, widget.completed);
      },
      onLongPress: widget.completed
          ? () {
              widget.onDeleteItem(widget.item);
            }
          : null,
      leading: Container(
        width: 50,
        height: 50,
        decoration:BoxDecoration(
          color: widget._getColor(context),
        ),
        child: Text(
          widget.item.timeRemaining.toStringAsFixed(widget.item.timeRemaining < 10 ? 1 : 0),
          style: widget._getTextStyle(context)?.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
          maxLines: 2,
          textScaler: const TextScaler.linear(1.5),
          
        ),
      ),
      title: Text(
        widget.item.name,
        style: widget._getTextStyle(context),
      ),
    );
    
      //return Row(
      //  children: [
      //    Text('Time remaining: $_timeRemaining')
      //  ],
      //);
    }
    
  }