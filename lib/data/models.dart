import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  var id;
  String title;
  String content;
  bool isImportant;
  String date;

  NotesModel({this.id, this.title, this.content, this.isImportant, this.date});

  NotesModel.fromMap(Map<String, dynamic> map) {
    // print("ans" + map.toString());
    // print(map['date']);
    // print(map['isImportant']);
    // print(map['id']);
    //print(map[title]);
    this.id = map['id'];
    this.title = map['title'].toString();
    this.content = map['content'];

    this.date = DateTime.now().toString(); //ap['date'];
    //DateTime.now(); //DateTime.parse(map['date']);
    this.isImportant = map['isImportant'] == 1 ? true : false;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': this.id,
      'title': this.title,
      'content': this.content,
      'isImportant': this.isImportant == true ? 1 : 0,
      'date': this.date //.toIso8601String(),
    };
  }

  NotesModel.random() {
    this.id = Random(10).nextInt(1000) + 1;
    this.title = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
    this.content = 'Lorem Ipsum ' * (Random().nextInt(4) + 1);
    this.isImportant = Random().nextBool();
    // this.date = DateTime.now().add(Duration(hours: Random().nextInt(100)));
  }
}
