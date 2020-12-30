import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Editdialog extends StatefulWidget {

  final QuerySnapshot snapshot;
  final int index;

  Editdialog(this.snapshot, this.index);

  @override
  _EditdialogState createState() => _EditdialogState();
}

class _EditdialogState extends State<Editdialog> {
  TextEditingController name;
  TextEditingController phone;
  TextEditingController email;

  TimeOfDay timeOfDay = TimeOfDay(hour: 00, minute: 00);

  DateTime dateTime = DateTime.now();

  String _setTime="Select Time", _setDate = "Select Date";

  @override
  void initState() {
    // TODO: implement initState
    name = TextEditingController();
    phone = TextEditingController();
    email = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.edit, size: 25,color: Colors.black,),
          onPressed: () {
            _editDialog(context);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete,size: 25,color: Colors.black,),
          onPressed: ()async{
            await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context){
                return AlertDialog(
                  title: Text("Are you sure ?"),
                  actions: [
                    MaterialButton(
                      color: Colors.black,
                      child: Text('YES', style: TextStyle(color: Colors.white),),
                      onPressed: ()async{
                        await FirebaseFirestore.instance.collection("data").
                        doc(widget.snapshot.docs[widget.index].id).delete().catchError((e) {print(e);}).then((value){
                          print("Deleted succesfully");
                        }).
                        whenComplete((){
                          Navigator.pop(context);
                        });
                      },
                    ),
                    MaterialButton(
                      color: Colors.black,
                      child: Text('NO', style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              }
            );
          },
        )
      ],
    );
  }

  _editDialog(BuildContext context) async{

    name.text = widget.snapshot.docs[widget.index]['name'];
    phone.text = widget.snapshot.docs[widget.index]['phone_number'];
    email.text = widget.snapshot.docs[widget.index]['emailID'];

    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context){
        return AlertDialog(
          scrollable: true,
          title: Text("Edit a Reservation"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Text("Name : "),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  autocorrect: true,
                  autofocus: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Name",
                  ),
                  controller: name,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  autocorrect: true,
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Phone Number",
                  ),
                  controller: phone,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  autocorrect: true,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Email ID",
                  ),
                  controller: email,
                ),
              ),
              FlatButton(
                color: Colors.black,
                onPressed: (){
                  _selectDate(context);
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
          ),
          actions: [
            FlatButton(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("SUBMIT"),
              ),
              onPressed: (){
                if(name.text.isNotEmpty && phone.text.isNotEmpty && email.text.isNotEmpty)
                {
                  FirebaseFirestore.instance.collection("data").doc(widget.snapshot.docs[widget.index].id).update({
                    "name":name.text,
                    "phone_number":phone.text,
                    "emailID":email.text,
                    "time":_setTime,
                    "date":_setDate,
                    "timestamp":new DateTime.now()
                  }).then((value){
                    print("RESPONSE : Updated}");
                  }).whenComplete((){
                    name.clear();
                    email.clear();
                    phone.clear();
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
                name.clear();
                email.clear();
                phone.clear();
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
}

