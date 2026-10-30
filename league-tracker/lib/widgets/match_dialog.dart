import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/match_record.dart';
import 'package:to_dont_list/objects/mode.dart';

typedef MatchListAddedCallback = Function(MatchRecord record);

class MatchDialog extends StatefulWidget {
  const MatchDialog({
    super.key,
    required this.onMatchAdded,
  });

  final MatchListAddedCallback onMatchAdded;

  @override
  State<MatchDialog> createState() => _MatchDialogState();
}

class _MatchDialogState extends State<MatchDialog> {
  final TextEditingController _championController = TextEditingController();
  Role _selectedRole = Role.top;
  final TextEditingController _killsController = TextEditingController();
  final TextEditingController _deathsController = TextEditingController();
  final TextEditingController _assistsController = TextEditingController();
  final TextEditingController _csController = TextEditingController();
  final TextEditingController _gameLengthController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _won = true;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return AlertDialog(
    title: const Text('Add Match'),
    content: SingleChildScrollView(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextField(
        controller: _championController,
        decoration: const InputDecoration(hintText: "champion name"),
      ),
      DropdownButton<Role>(
        value: _selectedRole,
        items: Role.values
            .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
            .toList(),
        onChanged: (r) => setState(() => _selectedRole = r!),
      ),
      TextField(
        controller: _killsController,
        decoration: const InputDecoration(hintText: "kills"),
        keyboardType: TextInputType.number,
      ),
      TextField(
        controller: _deathsController,
        decoration: const InputDecoration(hintText: "deaths"),
        keyboardType: TextInputType.number,
      ),
      TextField(
        controller: _assistsController,
        decoration: const InputDecoration(hintText: "assists"),
        keyboardType: TextInputType.number,
      ),
      TextField(
        controller: _csController,
        decoration: const InputDecoration(hintText: "creep score"),
        keyboardType: TextInputType.number,
      ),
      TextField(
        controller: _gameLengthController,
        decoration: const InputDecoration(hintText: "game length (minutes)"),
        keyboardType: TextInputType.number,
      ),
      Row(
        children: [
          const Text("Won:"),
          Switch(
            value: _won,
            onChanged: (value) => setState(() => _won = value),
          ),
        ],
      ),
      TextButton(
        onPressed: _pickDate,
        child: Text("Select Date: ${_selectedDate.toLocal().toString().split(' ')[0]}"),
      ),
    ],
  ),
),
    actions: <Widget>[
  ElevatedButton(
    key: const Key("OKButton"),
    onPressed: () {
      setState(() {
        widget.onMatchAdded(
          MatchRecord(
          game: ModeManager.mode.game,
          champion: _championController.text,
          role: _selectedRole,
          kills: int.parse(_killsController.text),
          deaths: int.parse(_deathsController.text),
          assists: int.parse(_assistsController.text),
          cs: int.parse(_csController.text),
          gameLength: int.parse(_gameLengthController.text),
          won: _won,
          date: _selectedDate,
          ),
        );
        Navigator.pop(context);
      });
    },
    child: const Text('OK'),
  ),
  ElevatedButton(
    key: const Key("CancelButton"),
    child: const Text('Cancel'),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  ],
);
}

}