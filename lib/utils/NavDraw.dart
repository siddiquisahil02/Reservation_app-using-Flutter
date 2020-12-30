import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/login%20Screen.dart';

class sidemenu extends StatelessWidget {

  User user = firebaseAuth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.displayName, style: TextStyle(color: Colors.white, fontSize: 25)),
                Text(user.email, style: TextStyle(color: Colors.white, fontSize: 15)),
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(user.photoURL)
                )
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app_rounded,color: Colors.black,),
            title: Text('Logout'),
            onTap: () async{
              await firebaseAuth.signOut();
              await googleSignIn.signOut();
              runApp(
                  new MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: new login_page(),
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}
