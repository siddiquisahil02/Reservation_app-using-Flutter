import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reservation_app/Homescreen.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

const owner_email = 'albatrozz911@gmail.com';

class login_page extends StatefulWidget {
  @override
  _login_pageState createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {

  TextEditingController name2,phone2,email2;
  TimeOfDay timeOfDay = TimeOfDay(hour: 00, minute: 00);
  DateTime dateTime = DateTime.now();
  String _setTime="Select Time", _setDate = "Select Date";

  @override
  void initState() {
    name2 = TextEditingController();
    phone2 = TextEditingController();
    email2 = TextEditingController();
    super.initState();
  }

  _login() async{
    final user = await googleSignIn.signIn();
    if(user != null)
      {
        final googleauth = await user.authentication;
        final creden =  GoogleAuthProvider.credential(
            idToken: googleauth.idToken,
            accessToken: googleauth.accessToken
        );

        await firebaseAuth.signInWithCredential(creden).then((value){
          if(value.user!=null && value.user.email==owner_email)
            {
              firebaseAuth.currentUser;
              print("LOGGED IN SUCCEFULLY");
              runApp(
                  new MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: new homescreen(),
                  )
              );
            }
          else
            {
              firebaseAuth.signOut();
              googleSignIn.signOut();
              final snackBar = SnackBar(
                content: Text('You\'re not the owner'),
                action: SnackBarAction(
                  label: 'DENIED',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 80,
            ),
            Expanded(
              child: Container(
                //height: MediaQuery.of(context).size.height-80,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  color: Color.fromRGBO(245, 246, 252, 1)
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text("Reserve your Table",style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                    ),
                    SizedBox(height: 30,),
                    enterinfo(),
                    SizedBox(height: 30,),
                    Center(
                      child: InkWell(
                        onTap: _login,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 15,
                                  //spreadRadius: 5,
                                  offset: Offset(0,8)
                                )
                              ],
                              borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.all(8),
                          width: 150,
                          child: Center(child: Text("Owner Login", style: TextStyle(color: Colors.white,fontSize: 18),)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    showDatePicker(
        context: context,
        builder: (context, child){
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        },
        initialDate: dateTime,
        firstDate: DateTime(DateTime.now().year-5),
        lastDate: DateTime(DateTime.now().year+5)
    ).then((value){
      if(value!=null)
      {
        var det = "${value.day}/"+"${value.month}/"+"${value.year}";
        setState(() {
          dateTime = value;
          _setDate=det;
        });
      }
    });
  }

  Future<Null> _selecttime(BuildContext context) async {
    showTimePicker(
        context: context,
        initialTime: timeOfDay,
        builder: (context, child){
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        }
    ).then((value){
      if(value!=null)
      {
        var toime = "${value.hourOfPeriod}:"+"${value.minute} "+"${value.period.toString().replaceAll("DayPeriod.","").toUpperCase()}";
        setState(() {
          timeOfDay=value;
          _setTime = toime;
        });
      }
    });
  }

  Widget enterinfo()
  {
    return Container(
      height: 400,
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.only(right: 30),
            color: Colors.transparent,
            shadowColor: Colors.black,
            elevation: 15,
            child: Container(
              height: 360,
              padding: EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    autofocus: false,
                    cursorColor: Colors.black,
                    enableSuggestions: true,
                    controller: name2,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.red,
                        labelText: "Name",
                        icon: Icon(Icons.person,color: Colors.black,),
                        hintText: "Enter your Name"
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  TextField(
                    autofocus: false,
                    cursorColor: Colors.black,
                    enableSuggestions: true,
                    controller: email2,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.red,
                        labelText: "Email ID",
                        icon: Icon(Icons.mail,color: Colors.black,),
                        hintText: "Enter your Email ID"
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    autofocus: false,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 20),
                    controller: phone2,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Phone Number",
                      icon: Icon(Icons.phone, color: Colors.black,),
                      hintText: "Enter your Phone Number",
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: (){
                          _selectDate(context);
                        },
                        color: Colors.black,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Select Data ", style: TextStyle(color: Colors.white,fontSize: 15),),
                            Icon(Icons.calendar_today_rounded, color: Colors.white,),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: (){
                          _selecttime(context);
                        },
                        color: Colors.black,
                        child: Row(
                          children: [
                            Text("Select Time ", style: TextStyle(color: Colors.white,fontSize: 15),),
                            Icon(Icons.access_time_rounded, color: Colors.white,),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 20),
              child: RawMaterialButton(
                onPressed: (){
                  if(name2.text.isNotEmpty && phone2.text.isNotEmpty && email2.text.isNotEmpty)
                  {
                    FirebaseFirestore.instance.collection("data").add({
                      "name":name2.text,
                      "phone_number":phone2.text,
                      "emailID":email2.text,
                      "time":_setTime,
                      "date":_setDate,
                      "timestamp":new DateTime.now()
                    }).then((value){
                      print("RESPONSE : Added ${value.id}");
                    }).whenComplete((){
                      name2.clear();
                      email2.clear();
                      phone2.clear();
                      _setTime="Select Time";
                      dateTime = DateTime.now();
                      timeOfDay = TimeOfDay(hour: 00, minute: 00);
                      _setDate = DateTime.now().toString();
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: Text("Your Table is Reserved"),
                            content: Image.asset('assets/done.gif', height: 100,width: 100,),
                            actions: [
                              MaterialButton(
                                child: Text('Okay',style: TextStyle(color: Colors.white),),
                                color: Colors.black,
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        }
                      );
                    });
                  }
                },
                elevation: 20.0,
                fillColor: Colors.black,
                child: Icon(
                  Icons.navigate_next_sharp,
                  color: Colors.white,
                  size: 50.0,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
