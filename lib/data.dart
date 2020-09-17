import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/data/models.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class NotesData {
  String name;
  int id = 0;
  Future<NotesModel> addNoteInDB(NotesModel newNote) async {
    // final db = await database;
    if (newNote.title.trim().isEmpty) newNote.title = 'Untitled Note';

    /*int id = await db.transaction((transaction) {
      transaction.rawInsert(
          'INSERT into Notes(title, content, date, isImportant) VALUES ("${newNote.title}", "${newNote.content}", "${newNote.date.toIso8601String()}", ${newNote.isImportant == true ? 1 : 0});');
    });*/
    SharedPreferences prefsnote = await SharedPreferences.getInstance();
    name = prefsnote.getString('sname');

    //   if (isNoteNew) {
    print(DateTime.now().toLocal());
    print(newNote.title);
    id = id + 1;
    Firestore.instance
        .collection(name)
        .document("notes")
        .collection("current")
        .document()
        .setData({
      "id": id,
      "title": newNote.title,
      "content": newNote.content,
      "isImportant": newNote.isImportant,
      "date": DateTime.now().toString()
    }).then((_) => {print("sucess")});
    newNote.id = id;

    print('Note added: ${newNote.title} ${newNote.content}');
    return newNote;
  }

  updateNoteInDB(NotesModel updatedNote, String title, String des) async {
    var temp;
    SharedPreferences prefsnote = await SharedPreferences.getInstance();
    name = prefsnote.getString('sname');
    CollectionReference c = Firestore.instance
        .collection(name)
        .document('notes')
        .collection("current");
    QuerySnapshot q = await c.getDocuments();

    temp = q.documents;
    temp.map((DocumentSnapshot doc) {
      print("title");
      print(doc.data['title']);
      print("eisting title" + title);
      print("eisting title" + des);
      print("update" + updatedNote.title);
      if (doc.data['title'] == title && doc.data['content'] == des) {
        print(doc.documentID);
        Firestore.instance
            .collection('$name/notes/current')
            .document(doc.documentID)
            .updateData({
          "id": updatedNote.id,
          "title": updatedNote.title,
          "content": updatedNote.content,
          "date": updatedNote.date, //.toIso8601String(),
          "isImportant": 1,
        });
      }
    }).toList();

    /*  .getDocuments()
        .then((value) {
      value.documents[0].data.update(
        "title",
        (value) => updatedNote.title,
      );
      value.documents[0].data.update(
        "description",
        (value) => updatedNote.content,
      );
      value.documents[0].data.update(
        "time",
        (value) => updatedNote.date,
      );
    });

    print(snapshots.toString());*/
  }

  Future<List<NotesModel>> getNotesFromDB() async {
    SharedPreferences prefsnote = await SharedPreferences.getInstance();
    name = prefsnote.getString('sname');
    // final db = await database;
    List<NotesModel> notesList = [];
    List<Map> maps = new List();
    List<DocumentSnapshot> temp;

    CollectionReference c = Firestore.instance
        .collection(name)
        .document('notes')
        .collection("current");
    QuerySnapshot q = await c.getDocuments();

    temp = q.documents;
    maps = temp.map((DocumentSnapshot doc) {
      print(doc.data);

      return doc.data;
    }).toList();

    //  maps = map;

    print(maps);

    /*await db.query('Notes',
        columns: ['_id', 'title', 'content', 'date', 'isImportant']);*/
    // print("length " + l.toString());

    if (maps.length > 0) {
      print("okk");
      maps.forEach((map) {
        print(map);
        print(map.entries);
        print(NotesModel.fromMap(map));
        notesList.add(NotesModel.fromMap(map));
      });
    }
    return notesList;
  }

  deleteNoteInDB(NotesModel noteToDelete) async {
    SharedPreferences prefsnote = await SharedPreferences.getInstance();
    name = prefsnote.getString('sname');
    Firestore.instance
        .collection(name)
        .document("notes")
        .collection("trash")
        .document()
        .setData({
      "id": noteToDelete.id,
      "title": noteToDelete.title,
      "content": noteToDelete.content,
      "time": noteToDelete.date
    });
    var temp, maps;
    CollectionReference c = Firestore.instance
        .collection(name)
        .document('notes')
        .collection("current");
    QuerySnapshot q = await c.getDocuments();

    temp = q.documents;
    temp.map((DocumentSnapshot doc) {
      print("title");
      print(doc.data['title']);
      if (doc.data['title'] == noteToDelete.title &&
          doc.data['content'] == noteToDelete.content) {
        print(doc.documentID);
        Firestore.instance
            .collection('$name/notes/current')
            .document(doc.documentID)
            .delete();
      }
    }).toList();

    //  maps = map;
    print('Note deleted');
  }
}
