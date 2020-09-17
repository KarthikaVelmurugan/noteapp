import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/data.dart';
import 'package:noteapp/data/models.dart';
import 'package:noteapp/remainder.dart';
import 'package:noteapp/screens/edit.dart';
import 'package:noteapp/services/database.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:share/share.dart';

class ViewNotePage extends StatefulWidget {
  Function() triggerRefetch;
  NotesModel currentNote;
  ViewNotePage({Key key, Function() triggerRefetch, NotesModel currentNote})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.currentNote = currentNote;
  }
  @override
  _ViewNotePageState createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {
  DateTime pickedDate;
  DateTime initialDate;
  TimeOfDay time;
  TimeOfDay time1;
  bool _showcard = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  NotesData n = new NotesData();
  NotesModel snote;
  bool _iconnoti = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      snote = widget.currentNote;
    });
    showHeader();
    print("oooooooo" + snote.title + snote.content);
    pickedDate = DateTime.now();
    initialDate = pickedDate;
    time = TimeOfDay.now();
    time1 = time;
    initializing();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }

  Future<void> notificationAfterSec() async {
    //var timeDelayed = pickedDate.add(Duration(hours: time.hour));
    print("time" + time.toString());

    final difference = pickedDate.difference(initialDate).inDays;
    final diffhr = pickedDate.difference(initialDate).inHours;
    final diffmin = pickedDate.difference(initialDate).inMinutes;
    print("no of days:" + difference.toString());
    difference > 0
        ? print("no of days:" +
            difference.toString() +
            "hours" +
            diffhr.toString() +
            "minutes" +
            diffmin.toString())
        : print("hours");
    //print(time.hourOfPeriod);
    print(time.hour - time1.hour);

    print(time.minute - time1.minute);

    var timeDelayed = difference > 0
        ? pickedDate
            .add(Duration(days: difference, hours: diffhr, minutes: diffmin))
        : pickedDate.add(Duration(
            hours: time.hour - time1.hour,
            minutes: time.minute - time1.minute));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            color: Colors.red,
            enableVibration: true,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(1, widget.currentNote.title,
        widget.currentNote.content, timeDelayed, notificationDetails);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }
    ViewNotePage(
        triggerRefetch: widget.triggerRefetch, currentNote: widget.currentNote);
    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  void showHeader() async {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        headerShouldShow = true;
      });
    });
  }

  bool headerShouldShow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            _showcard
                ? Container(
                    padding: EdgeInsets.only(top: 50),
                    height: 250,
                    // width: MediaQuery.of(context).size.width,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /* InkWell(
                          onTap: _pickDate,
                          child: Text(
                              "Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}"),
                        ),
                        InkWell(
                          onTap: _pickTime,
                          child: Text("Time:  ${time.hour}:${time.minute}"),
                        )
                        */
                        ListTile(
                          title: Text(
                              "Date:  ${pickedDate.day}/${pickedDate.month}/${pickedDate.year}",
                              style: TextStyle(fontWeight: FontWeight.w900)),
                          trailing: Icon(Icons.keyboard_arrow_down),
                          onTap: _pickDate,
                        ),
                        ListTile(
                          title: Text("Time:  ${time.hour}:${time.minute}",
                              style: TextStyle(fontWeight: FontWeight.w900)),
                          trailing: Icon(Icons.keyboard_arrow_down),
                          onTap: _pickTime,
                        ),
                        FlatButton(
                            color: Colors.red[900],
                            onPressed: () {
                              _showNotificationsAfterSecond();
                              setState(() {
                                _showcard = !_showcard;
                              });
                            },
                            child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                  "ok",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )))
                      ],
                    ),
                  )
                : Container(
                    height: 80,
                  ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 40.0, bottom: 16),
              child: AnimatedOpacity(
                opacity: headerShouldShow ? 1 : 0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
                child: Text(
                  widget.currentNote.title,
                  style: TextStyle(
                    color: Colors.red[800],
                    fontFamily: 'ZillaSlab',
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: headerShouldShow ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  widget.currentNote.date,
                  // DateFormat.yMd().add_jm().format(widget.currentNote.date),
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 36, bottom: 24, right: 24),
              child: Text(
                widget.currentNote.content,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
        ClipRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 80,
                color: Theme.of(context).canvasColor.withOpacity(0.3),
                child: SafeArea(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.red[800]),
                        onPressed: handleBack,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.notifications,
                            size: 25, color: Colors.red),
                        onPressed: () {
                          print("notification");
                          setState(() {
                            _showcard = !_showcard;
                          });
                          // _showNotificationsAfterSecond();
                          //  OpenNotificationPage();import 'package:flutter/cupertino.dart';
                        },
                      ),
                      IconButton(
                        icon: Icon(
                            widget.currentNote.isImportant
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 25,
                            color: Colors.red[800]),
                        onPressed: () {
                          markImportantAsDirty();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            size: 25, color: Colors.red[800]),
                        onPressed: handleDelete,
                      ),
                      IconButton(
                        icon: Icon(OMIcons.share,
                            size: 25, color: Colors.red[800]),
                        onPressed: handleShare,
                      ),
                      IconButton(
                        icon: Icon(OMIcons.edit,
                            size: 25, color: Colors.red[800]),
                        onPressed: handleEdit,
                      ),
                    ],
                  ),
                ),
              )),
        )
      ],
    ));
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        time = t;
      });
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  void handleSave() async {
    await n.updateNoteInDB(widget.currentNote, "", "");
    widget.triggerRefetch();
  }

  void markImportantAsDirty() {
    setState(() {
      widget.currentNote.isImportant = !widget.currentNote.isImportant;
    });
    handleSave();
  }

  void handleEdit() {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EditNotePage(
                  existingNote: widget.currentNote,
                  triggerRefetch: widget.triggerRefetch,
                )));
  }

  void handleShare() {
    Share.share(
        '${widget.currentNote.title.trim()}\n(On: ${widget.currentNote.date.substring(0, 10)})\n\n${widget.currentNote.content}');
  }

  void handleBack() {
    Navigator.pop(context);
  }

  void handleDelete() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Delete Note'),
            content: Text('This note will be deleted permanently'),
            actions: <Widget>[
              FlatButton(
                child: Text('DELETE',
                    style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  await n.deleteNoteInDB(widget.currentNote);
                  widget.triggerRefetch();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CANCEL',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
