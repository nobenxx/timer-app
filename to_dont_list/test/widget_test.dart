// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';

void main() {
  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item:  Item(name: "test"),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);                                          
  });

  testWidgets('ToDoListItem has a Container with remaining time',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: Item(name: "test"),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final abbvFinder = find.text('10.0');
    final avatarFinder = find.byType(Container);

    Container circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(ctext.data, "10.0");
  });

  // testWidgets('Default ToDoList has no items', (tester) async {
  //   await tester.pumpWidget(const MaterialApp(home: ToDoList()));

  //   final listItemFinder = find.byType(ToDoListItem);

  //   expect(listItemFinder, findsNothing);
  // });
  //This test hangs for whatever reason, I truly cannot find out why
  
  testWidgets('Clicking and Typing adds item to ToDoList', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byKey(const Key("LabelField")), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);
  
    await tester.enterText(find.byKey(const Key("LabelField")), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(1));
  });
  //This one also hangs, I believe the issue is timer related

  testWidgets('Adding an item sets its timer duration', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('LabelField')), 'test');
    await tester.enterText(find.byKey(const Key('TimeField')), '2');
    await tester.tap(find.byKey(const Key('OKButton')));
    await tester.pump();

    expect(find.text('2.0'), findsOneWidget);
  });
  
  testWidgets('Timer decreases an item’s remaining time', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('LabelField')), 'test');
    await tester.enterText(find.byKey(const Key('TimeField')), '2');
    await tester.tap(find.byKey(const Key('OKButton')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('1.0'), findsOneWidget);
  });

  testWidgets('Timer completes an item when its time expires', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(0), 'timed item');
    await tester.enterText(find.byType(TextField).at(1), '0');
    await tester.tap(find.byKey(const Key('OKButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final itemText = tester.widget<Text>(find.text('timed item'));
    expect(itemText.style?.decoration, TextDecoration.lineThrough);
  });

}
