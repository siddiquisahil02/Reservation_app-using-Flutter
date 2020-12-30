import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/login%20Screen.dart';
import 'package:reservation_app/model/model.dart';
import 'package:reservation_app/utils/NavDraw.dart';
import 'package:reservation_app/utils/cards.dart';

class homescreen extends StatefulWidget {
  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  User user = firebaseAuth.currentUser;

  Data_model data_model;

  TimeOfDay timeOfDay = TimeOfDay(hour: 00, minute: 00);
  DateTime dateTime = DateTime.now();

  String _setTime="Select Time", _setDate = DateTime.now().toString();

  var firestoreDB = FirebaseFirestore.instance.collection("data").snapshots();

  TextEditingController nameController;
  TextEditingController phonenumberController;
  TextEditingController emailController;

  @override
  void initState() {
    // TODO: implement initState
    nameController = TextEditingController();
    phonenumberController = TextEditingController();
    emailController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Reserved Tables"),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30,),
        backgroundColor: Colors.black,
        onPressed: (){
          _showDialog(context);
        }
      ),
      drawer: sidemenu(),
      body: StreamBuilder(
        stream: firestoreDB,
        builder: (context,AsyncSnapshot snapshot){
          if(!snapshot.hasData)
            return CircularProgressIndicator();
          else
            {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, int index){
                  return cards(snapshot: snapshot.data,index: index,);
                },
              );
            }
        },
      )
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

  _showDialog(BuildContext context) async{
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context){
        return AlertDialog(
          scrollable: true,
          title: Text("Add a new Reservation"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Text("Name : "),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  autocorrect: true,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Name",
                  ),
                  controller: nameController,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  autocorrect: true,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Phone Number",
                  ),
                  controller: phonenumberController,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  autocorrect: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Email ID",
                  ),
                  controller: emailController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    color: Colors.black,
                    onPressed: (){
                      _selectDate(context);
                      setState(() {
                      });
                    },
                    child: Text("Select Date",style: TextStyle(color: Colors.white),),
                  ),
                  FlatButton(
                    color: Colors.black,
                    onPressed: (){
                      _selecttime(context);
                    },
                    child: Text("Select Time",style: TextStyle(color: Colors.white),),
                  )
                ],
              )
            ],
          ),
          actions: [
            FlatButton(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("SUBMIT"),
              ),
              onPressed: (){
                if(nameController.text.isNotEmpty && phonenumberController.text.isNotEmpty && emailController.text.isNotEmpty)
                  {
                    FirebaseFirestore.instance.collection("data").add({
                      "name":nameController.text,
                      "phone_number":phonenumberController.text,
                      "emailID":emailController.text,
                      "time":_setTime,
                      "date":_setDate,
                      "timestamp":new DateTime.now()
                    }).then((value){
                      print("RESPONSE : ${value.id}");
                    }).whenComplete((){
                      nameController.clear();
                      emailController.clear();
                      phonenumberController.clear();
                      _setTime="Select Time";
                      dateTime = DateTime.now();
                      timeOfDay = TimeOfDay(hour: 00, minute: 00);
                      _setDate = DateTime.now().toString();
                      Navigator.pop(context);
                    });
                  }
              },
            ),
            FlatButton(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("CANCEL"),
              ),
              onPressed: (){
                nameController.clear();
                emailController.clear();
                phonenumberController.clear();
                dateTime = DateTime.now();
                _setTime="Select Time";
                timeOfDay = TimeOfDay(hour: 00, minute: 00);
                _setDate = DateTime.now().toString();
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

}
