import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Reminder {
  int id;
  String title;
  String description;
  DateTime time;
  String repeat;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.repeat,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'time': time.toIso8601String(),
        'repeat': repeat,
      };

  static Reminder fromJson(Map<String, dynamic> json) => Reminder(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        time: DateTime.parse(json['time']),
        repeat: json['repeat'],
      );
}

class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final List<Reminder> _reminders = [];
  int _nextId = 0;

  final List<String> titleSuggestions = [
    "Watering",
    "Fertilizing",
    "Pruning",
    "Repotting",
    "Pest Control",
    "Weeding"
  ];
  final List<String> descSuggestions = [
    "Water at 8 AM",
    "Add fertilizer",
    "Trim dead leaves",
    "Change potting soil",
    "Spray for pests",
    "Remove weeds"
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadRemindersFromPrefs();
    });
  }

  Future<void> _saveRemindersToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final reminderList =
        _reminders.map((r) => json.encode(r.toJson())).toList();
    await prefs.setStringList('reminders', reminderList);
  }

  Future<void> _loadRemindersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final reminderList = prefs.getStringList('reminders') ?? [];
    print("🔄 Loaded ${reminderList.length} reminders from SharedPreferences");

    _reminders.clear();
    for (String item in reminderList) {
      final decoded = json.decode(item);
      final reminder = Reminder.fromJson(decoded);
      _reminders.add(reminder);
      _scheduleNotification(reminder); // re-schedule
      _nextId = _nextId < reminder.id + 1 ? reminder.id + 1 : _nextId;
    }
    setState(() {});
  }

  void _scheduleNotification(Reminder reminder) async {
    var androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.id,
      reminder.title,
      reminder.description,
      tz.TZDateTime.from(reminder.time, tz.local),
      NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: reminder.repeat == "Every Day"
          ? DateTimeComponents.time
          : reminder.repeat == "Every Week"
              ? DateTimeComponents.dayOfWeekAndTime
              : reminder.repeat == "Every Month"
                  ? DateTimeComponents.dayOfMonthAndTime
                  : null,
    );
  }

  void _showReminderDialog({Reminder? existing}) {
    TextEditingController titleController =
        TextEditingController(text: existing?.title ?? '');
    TextEditingController descController =
        TextEditingController(text: existing?.description ?? '');
    DateTime selectedTime =
        existing?.time ?? DateTime.now().add(Duration(minutes: 1));
    String selectedRepeat = existing?.repeat ?? "Only Once";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.green[50],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets +
                  EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      existing == null ? "Add Reminder" : "Edit Reminder",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green[900]),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        hintText: "Enter reminder title",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () =>
                              setModalState(() => titleController.clear()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: titleSuggestions.map((suggestion) {
                          return ActionChip(
                            label: Text(suggestion),
                            onPressed: () {
                              setModalState(() {
                                titleController.text = suggestion;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: "Description",
                        hintText: "Enter reminder details",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () =>
                              setModalState(() => descController.clear()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: descSuggestions.map((suggestion) {
                          return ActionChip(
                            label: Text(suggestion),
                            onPressed: () {
                              setModalState(() {
                                descController.text = suggestion;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  currentTime: selectedTime, onConfirm: (dt) {
                                setModalState(() => selectedTime = dt);
                              });
                            },
                            icon:
                                Icon(Icons.calendar_today, color: Colors.white),
                            label: Text(
                              "Pick Time",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[800],
                                shape: StadiumBorder()),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedRepeat,
                            decoration: InputDecoration(
                              labelText: "Repeat",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                            ),
                            onChanged: (v) {
                              setModalState(() => selectedRepeat = v!);
                            },
                            items: [
                              "Only Once",
                              "Every Day",
                              "Every Week",
                              "Every Month"
                            ]
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: Icon(Icons.save, color: Colors.white),
                      label: Text(
                        "Save Reminder",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Title cannot be empty")));
                          return;
                        }
                        final newReminder = Reminder(
                          id: existing?.id ?? _nextId++,
                          title: titleController.text,
                          description: descController.text,
                          time: selectedTime,
                          repeat: selectedRepeat,
                        );

                        if (existing == null) {
                          _reminders.add(newReminder);
                        } else {
                          int index =
                              _reminders.indexWhere((r) => r.id == existing.id);
                          if (index != -1) {
                            _reminders[index] = newReminder;
                          }
                        }

                        _scheduleNotification(newReminder);
                        _saveRemindersToPrefs();
                        Navigator.pop(context);
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700]),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteReminder(Reminder reminder) {
    flutterLocalNotificationsPlugin.cancel(reminder.id);
    setState(() {
      _reminders.removeWhere((r) => r.id == reminder.id);
    });
    _saveRemindersToPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminders"),
        backgroundColor: Colors.green[700],
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReminderDialog(),
        backgroundColor: Colors.green[800],
        child: Icon(Icons.add),
      ),
      body: _reminders.isEmpty
          ? Center(
              child: Text(
                "No reminders yet. Tap the '+' button to add one.",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            )
          : ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (_, i) {
                final r = _reminders[i];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  color: Colors.green[50],
                  elevation: 2,
                  child: ListTile(
                    leading: Icon(Icons.alarm, color: Colors.green[700]),
                    title: Text(
                      r.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "${r.description}\n${r.time.toLocal().toString().split('.')[0]} (${r.repeat})",
                        style: TextStyle(color: Colors.green[800])),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () => _showReminderDialog(existing: r),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReminder(r),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
