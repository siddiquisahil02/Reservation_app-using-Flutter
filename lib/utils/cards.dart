import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/screens/editDialog.dart';

class cards extends StatelessWidget {

  final QuerySnapshot snapshot;
  final int index;

  const cards({Key key, this.snapshot, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width-50,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text("Created on : ${DateTime.parse(snapshot.docs[index]['timestamp'].toDate().toString()).toString()}",
                    style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
              Card(
                elevation: 15,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.centerRight,
                              width: 120,
                              child: Text("Name : ",
                                style: TextStyle(fontSize: 16),
                              )
                          ),
                          Text(snapshot.docs[index]['name'],style: TextStyle(fontSize: 17),),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.centerRight ,
                              width: 120,
                              child: Text("Email ID : ",
                                style: TextStyle(fontSize: 16),
                              )
                          ),
                          Text(snapshot.docs[index]['emailID'],style: TextStyle(fontSize: 17),),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.centerRight ,
                              width: 120,
                              child: Text("Phone Number : ",
                                style: TextStyle(fontSize: 16),
                              )
                          ),
                          Text(snapshot.docs[index]['phone_number'],style: TextStyle(fontSize: 17),),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.centerRight ,
                              width: 120,
                              child: Text("Date : ",
                                style: TextStyle(fontSize: 16),
                              )
                          ),
                          Text(snapshot.docs[index]['date'],style: TextStyle(fontSize: 17),),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.centerRight ,
                              width: 120,
                              child: Text("Time : ",
                                style: TextStyle(fontSize: 16),
                              )
                          ),
                          Text(snapshot.docs[index]['time'],style: TextStyle(fontSize: 17),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Editdialog(snapshot, index),
        )
      ],
    );
  }
}
