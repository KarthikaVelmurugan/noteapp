import 'package:flutter/material.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  @override
  _Myapp createState() => _Myapp();
}

class _Myapp extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: viewPage("", ""),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Fill()));
              });
            },
            label: Text("Add",
                style: TextStyle(fontSize: 15, color: Colors.white)),
            icon: Icon(Icons.add, size: 30, color: Colors.white),
            backgroundColor: Colors.red[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          )),
    );
  }

  Widget _showfruitcard() {
    return Container(height: 100, width: 200, color: Colors.red);
  }
}

class Fill extends StatefulWidget {
  @override
  _Fill createState() => _Fill();
}

class _Fill extends State<Fill> {
  String title, desc;
  bool _validatetitle, _validatedes;
  TextEditingController titlecontroller;
  TextEditingController desccontroller;
  FocusNode titlefocusnode, descfocusnode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      TextFormField(
        onChanged: (value) {
          setState(() {
            title = value;
          });
        },
        focusNode: titlefocusnode,
        onFieldSubmitted: (String value) {
          titlefocusnode.unfocus();
        },
        style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            letterSpacing: 1,
            fontWeight: FontWeight.w600),
        controller: titlecontroller,
        keyboardType: TextInputType.text,
        cursorColor: Colors.red[900],
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person, color: Colors.red[900], size: 25),
          hintText: "Title",
          hintStyle: TextStyle(fontSize: 20),
          errorText: _validatetitle ? 'title not be empty' : null,
          errorStyle: TextStyle(
            fontSize: 28,
            color: Colors.black45,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
      SizedBox(height: 20),
      TextFormField(
        onChanged: (value) {
          setState(() {
            desc = value;
          });
        },
        focusNode: descfocusnode,
        onFieldSubmitted: (String value) {
          descfocusnode.unfocus();
        },
        style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            letterSpacing: 1,
            fontWeight: FontWeight.w600),
        controller: desccontroller,
        keyboardType: TextInputType.text,
        cursorColor: Colors.red[900],
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person, color: Colors.red[900], size: 25),
          hintText: "Description",
          hintStyle: TextStyle(fontSize: 20),
          errorText: _validatedes ? 'Description not be empty' : null,
          errorStyle: TextStyle(
            fontSize: 20,
            color: Colors.black45,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
      _button(),
    ]));
  }

  Widget _button() {
    return RaisedButton(
      color: Colors.red[900],
      onPressed: () async {
        var f;
        setState(() {
          f = 0;

          if (title == null || title == '') {
            f = 1;
            _validatetitle = true;
          }
          if (desc == null || desc == '') {
            f = 1;
            _validatedes = true;
          }
        });
        if (f == 0) {
          /* SharedPreferences prefsnote =
                                        await SharedPreferences.getInstance();
                                    setState(() {
                                      prefsnote.setString('sname', sname);
                                      prefsnote.setBool('first_time', false);
                                      print("true modify");
                                    });
*/
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => viewPage(title, desc)));
        }
      },
      child: Text(
        "Signin",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

Widget viewPage(String title, String desc) {
  return Container(
      color: Colors.red,
      height: 100,
      width: 100,
      child: Column(
        children: <Widget>[
          Text(title),
          Text(desc),
        ],
      ));
}
