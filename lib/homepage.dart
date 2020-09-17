import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/components/cards.dart';
import 'package:noteapp/components/faderoute.dart';
import 'package:noteapp/data.dart';
import 'package:noteapp/data/models.dart';
import 'package:noteapp/screens/edit.dart';
import 'package:noteapp/screens/view.dart';
import 'package:noteapp/services/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  bool isFlagOn = false;
  bool headerShouldHide = false;
  //NotesModel note;
  List<NotesModel> notesList = [];
  TextEditingController searchController = TextEditingController();
  NotesData n = new NotesData();
  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    //  NotesDatabaseService.db.init();
    setNotesFromDB();
  }

  setNotesFromDB() async {
    print("Entered setNotes");
    var fetchedNotes = await n.getNotesFromDB();
    setState(() {
      notesList = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add", style: TextStyle(fontSize: 15, color: Colors.white)),
        icon: Icon(Icons.add, size: 30, color: Colors.white),
        backgroundColor: Colors.red[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        onPressed: () {
          gotoEditNote();
        },
        //   label: Text('Add Note'.toUpperCase()),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              /* Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                    /*  Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SettingsPage(
                                  changeTheme: widget.changeTheme)));*/
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.all(16),
                      alignment: Alignment.centerRight,
                      child: Icon(
                        OMIcons.settings,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade600
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),*/
              buildHeaderWidget(context),
              buildButtonRow(),
              buildImportantIndicatorText(),
              /*  Container(height: 20),*/
              ...buildNoteComponentsList(),
              /* GestureDetector(
                onTap: gotoEditNote,
                //  child: AddNoteCardComponent()
              ),*/
              // Container(height: 30)*/
            ],
          ),
          margin: EdgeInsets.only(top: 2),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),
      ),
    );
  }

  Widget buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                isFlagOn = !isFlagOn;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 160),
              height: 50,
              width: 50,
              curve: Curves.slowMiddle,
              child: Icon(
                isFlagOn ? Icons.favorite : Icons.favorite_border,
                color: isFlagOn ? Colors.red : Colors.red,
                size: isFlagOn ? 20 : 20,
              ),
              decoration: BoxDecoration(
                  //  color: isFlagOn ? Colors.w : Colors.transparent,
                  border: Border.all(
                    width: isFlagOn ? 1 : 1,
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.only(left: 16),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      maxLines: 1,
                      onChanged: (value) {
                        handleSearch(value);
                      },
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                            fontWeight: FontWeight.w900),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(isSearchEmpty ? Icons.search : Icons.cancel,
                        color: Colors.grey.shade300),
                    onPressed: cancelSearch,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top: 8, bottom: 25, left: 10),
          width: headerShouldHide ? 0 : 200,
          child: Text(
            'My Notes',
            style: TextStyle(
              fontFamily: 'ZillaSlab',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.red[800],
            ),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      ],
    );
  }

  Widget testListItem(Color color) {
    return new NoteCardComponent(
      noteData: NotesModel.random(),
    );
  }

  Widget buildImportantIndicatorText() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      firstChild: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          'Your favourite Notes',
          style: TextStyle(
              fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
      ),
      secondChild: Container(
        height: 2,
      ),
      crossFadeState:
          isFlagOn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  List<Widget> buildNoteComponentsList() {
    List<Widget> noteComponentsList = [];
    notesList.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    if (searchController.text.isNotEmpty) {
      notesList.forEach((note) {
        if (note.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            note.content
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
          noteComponentsList.add(NoteCardComponent(
            noteData: note,
            onTapAction: openNoteToRead,
          ));
      });
      return noteComponentsList;
    }
    if (isFlagOn) {
      notesList.forEach((note) {
        if (note.isImportant)
          noteComponentsList.add(NoteCardComponent(
            noteData: note,
            onTapAction: openNoteToRead,
          ));
      });
    } else {
      notesList.forEach((note) {
        noteComponentsList.add(NoteCardComponent(
          noteData: note,
          onTapAction: openNoteToRead,
        ));
      });
    }
    return noteComponentsList;
  }

  void handleSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }

  void gotoEditNote() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => EditNotePage(
                  triggerRefetch: refetchNotesFromDB,
                )));
  }

  void refetchNotesFromDB() async {
    await setNotesFromDB();
    print("Refetched notes");
  }

  openNoteToRead(NotesModel noteData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
        context,
        FadeRoute(
            page: ViewNotePage(
                triggerRefetch: refetchNotesFromDB, currentNote: noteData)));
    await Future.delayed(Duration(milliseconds: 300), () {});

    setState(() {
      headerShouldHide = false;
    });
  }

  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }
}
