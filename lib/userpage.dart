import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  bool _validaten = false;
  var f;
  String sname = '';
  TextEditingController nameController = TextEditingController();
  FocusNode namefocusnode;
  final firebaseuser = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return MaterialApp(
        title: "NoteApp",
        debugShowCheckedModeBanner: false,
        color: Colors.white,
        home: Scaffold(
            backgroundColor: Colors.grey[200],
            body: Container(
              height: ht,
              width: wt,
              padding: EdgeInsets.only(bottom: 5),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: ht / 1.7,
                    width: wt,
                    child: Image.asset(
                      'assets/i.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                      height: ht - ht / 1.5,
                      width: wt / 1.2,
                      padding: EdgeInsets.all(5.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("SIGN IN",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  )),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    sname = value;
                                  });
                                },
                                focusNode: namefocusnode,
                                onFieldSubmitted: (String value) {
                                  namefocusnode.unfocus();
                                },
                                style: TextStyle(
                                    fontSize: wt / 30,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600),
                                controller: nameController,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.red[900],
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person,
                                      color: Colors.red[900], size: 25),
                                  hintText: "User Name",
                                  hintStyle: TextStyle(fontSize: wt / 30),
                                  errorText: _validaten
                                      ? 'Name must contains atleast 4 characters'
                                      : null,
                                  errorStyle: TextStyle(
                                    fontSize: wt / 33,
                                    color: Colors.black45,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                              RaisedButton(
                                color: Colors.red[900],
                                onPressed: () async {
                                  setState(() {
                                    f = 0;
                                    print("Sname: " + sname);
                                    if (sname.length < 4 || sname == '') {
                                      f = 1;
                                      _validaten = true;
                                    }
                                  });
                                  if (f == 0) {
                                    SharedPreferences prefsnote =
                                        await SharedPreferences.getInstance();
                                    setState(() {
                                      prefsnote.setString('sname', sname);
                                      prefsnote.setBool('first_time', false);
                                      print("true modify");
                                    });

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  }
                                },
                                child: Text(
                                  "Signin",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              )),
            )));
  }
}
