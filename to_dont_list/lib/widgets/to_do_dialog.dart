import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ToDoListAddedCallback = Function(
    String value, TextEditingController textController, double? time);

class ToDoDialog extends StatefulWidget {
  const ToDoDialog({
    super.key,
    required this.onListAdded,
  });

  final ToDoListAddedCallback onListAdded;

  @override
  State<ToDoDialog> createState() => _ToDoDialogState();
}

class _ToDoDialogState extends State<ToDoDialog> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  String valueText = "";
  double? valueTime = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Timer To Add'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            controller: _inputController,
            decoration: const InputDecoration(hintText: "type something here"),
            key: const Key("LabelField"),
          ),
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter> [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged:(value){
              setState(() {
                valueTime = double.tryParse(value) ?? 0.0;
              });
            },
            decoration: const InputDecoration(
              labelText: "Seconds",
            ),
            key: const Key("TimeField"),
          )
        ],
      ), 
      actions: <Widget>[
        ElevatedButton(
          key: const Key("CancelButton"),
          style: noStyle,
          child: const Text('Cancel'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),

        // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _inputController,
          builder: (context, value, child) {
            return ElevatedButton(
              key: const Key("OKButton"),
              style: yesStyle,
              onPressed: value.text.isNotEmpty
                  ? () {
                      setState(() {
                        widget.onListAdded(valueText, _inputController, valueTime);
                        Navigator.pop(context);
                      });
                    }
                  : null,
              child: const Text('OK'),
            );
          },
        ),
      ],
    );
  }
}
