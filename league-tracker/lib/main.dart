// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/match_record.dart';
import 'package:to_dont_list/objects/mode.dart';
import 'package:to_dont_list/widgets/match_list_item.dart';
import 'package:to_dont_list/widgets/match_dialog.dart';

enum SortMode { none, role, champion, result }

class MatchList extends StatefulWidget {
  const MatchList({super.key});

  @override
  State createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  final List<MatchRecord> matches = [];
  SortMode _sortMode = SortMode.none;

  void _handleNewMatch(MatchRecord record) {
  setState(() {
    matches.insert(0, record);
  });
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  title: const Text('League Tracker'),
  actions: [
    DropdownButton<SortMode>(
      value: _sortMode,
      items: SortMode.values
          .map((mode) => DropdownMenuItem(value: mode, child: Text(mode.name)))
          .toList(),
      onChanged: (mode) => setState(() => _sortMode = mode!),
    ),
  ],
),
    body: ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: _sortedMatches.map((record) {
        return MatchListItem(record: record);
      }).toList(),
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return MatchDialog(onMatchAdded: _handleNewMatch);
          },
        );
      },
    ),
  );
}

List<MatchRecord> get _sortedMatches {
  final sorted = List<MatchRecord>.from(matches);
  switch (_sortMode) {
    case SortMode.role:
      if (ModeManager.mode.game == Game.league) {
        sorted.sort((a, b) => a.role!.index.compareTo(b.role!.index));
      }
      break;
    case SortMode.champion:
      if (ModeManager.mode.game == Game.league || ModeManager.mode.game == Game.deadlock) {
        sorted.sort((a, b) => a.champion!.compareTo(b.champion!));
      }
      break;
    case SortMode.result:
      if (ModeManager.mode.game == Game.league) {
        sorted.sort((a, b) => ((b.won ?? false) ? 1 : 0).compareTo((a.won ?? false) ? 1 : 0));
      }
      break;
    case SortMode.none:
      break;
  }
  return sorted;
}

}

void main() {
  runApp(const MaterialApp(
    title: 'League Tracker',
    home: MatchList(),
  ));
}
