
import 'package:App/screens/OrderScreen/OrderScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:App/constants/firebase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  ///GET UID USER
  Rx<User> firebaseUser = Rx<User>(auth.currentUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users')
                  .doc(firebaseUser.value.uid)
                  .snapshots(),
              builder: (context, user_snapshot) {
                if (!user_snapshot.hasData) return Container();
                return Row(
                  children: [
                    Icon(Icons.account_circle,color: Colors.black,),
                    SizedBox(width: 5,),
                    Text("${user_snapshot.data.data()['name']}",
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),),
                  ],
                );
              }),
          SizedBox(width: 10,),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10,top: 20),
            child: InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(225),
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                height: 80,
                child: Text("Order",
                  style: GoogleFonts.roboto(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10,top: 10),
            child: InkWell(
              onTap: () async {

              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(225),
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                height: 80,
                child: Text("Support",
                  style: GoogleFonts.roboto(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10,top: 10),
            child: InkWell(
              onTap: () async {

              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(225),
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                height: 80,
                child: Text("Settings",
                  style: GoogleFonts.roboto(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}