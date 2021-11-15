import 'dart:io';

import 'package:App/constants/json_language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:App/constants/firebase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> {

  ///GET UID USER
  Rx<User> firebaseUser = Rx<User>(auth.currentUser);

  ///CONTAINER DECORATION BORDER
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  Future<List>get_all_products() async {
    var url = 'https://ygyoza-api.herokuapp.com/pawaresoftwares/api/ygyoza/products/get-all/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control_Allow_Origin": "*",
        HttpHeaders.authorizationHeader: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJGd3VaUUZxWmdPUFZtdGl0SDdocDNiM3NqVEgzIiwibmFtZSI6IlZlbmRlZG9yIiwiaXNBZG1pbiI6dHJ1ZSwiZW1haWwiOiJ0ZXN0ZUB0ZXN0ZS5jb20iLCJpc1JlZnJlc2hUb2tlbiI6ZmFsc2UsImV4cCI6MTYzNjk3MzUyNX0.edixhIUJ2tcEjoOvTVUpr8rIpwpvQkdkLWP55g5hcSU',
      },
    );

    List all_products = json.decode(response.body);
    return all_products;
  }
  Future<List>get_all_stores() async {
    var url = 'https://ygyoza-api.herokuapp.com/pawaresoftwares/api/ygyoza/stores/get-all/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Access-Control_Allow_Origin": "*",
        HttpHeaders.authorizationHeader: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJGd3VaUUZxWmdPUFZtdGl0SDdocDNiM3NqVEgzIiwibmFtZSI6IlZlbmRlZG9yIiwiaXNBZG1pbiI6dHJ1ZSwiZW1haWwiOiJ0ZXN0ZUB0ZXN0ZS5jb20iLCJpc1JlZnJlc2hUb2tlbiI6ZmFsc2UsImV4cCI6MTYzNjk3MzUyNX0.edixhIUJ2tcEjoOvTVUpr8rIpwpvQkdkLWP55g5hcSU',
      },
    );

    List all_stores = json.decode(response.body);
    List stores_filtes = [];
    for(var store in all_stores){
      stores_filtes.add(store['name']);
    }
    print(all_stores);
    return stores_filtes;
  }

  Future all_products;

  @override
  void initState() {
    all_products = get_all_products();
    super.initState();
  }

  Map products = {};

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: FilterAppBar(),
        leading: Icon(Icons.home, color: Colors.black, size: 25,),
        title: Text("${json_language['New Order']}",
          style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
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
      body: FutureBuilder<List>(
        future: all_products,
        builder: (
            BuildContext context,
            AsyncSnapshot<List> snapshot,
            ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          } else {
            return GridView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 200,
                    width: 200,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      '${snapshot.data[index]['images'][0]}',
                                    ),
                                    fit: BoxFit.fill )
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text("${snapshot.data[index]['name']}",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.black,

                          ),),
                        Container(
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(onPressed: (){
                                if(products['${index}'] == snapshot.data[index]['price']){
                                  return;
                                }else if(products['${index}'] == null){
                                  setState(() {
                                    products['${index}'] = snapshot.data[index]['price'];
                                  });
                                  setState(() {
                                    products['${index}amount'] = snapshot.data[index]['amount'];
                                  });
                                  return;
                                }else if(products['${index}amount'] == 1){
                                  setState(() {
                                    products['${index}'] = snapshot.data[index]['price'];
                                  });
                                  setState(() {
                                    products['${index}amount'] = 0;
                                  });
                                }else{
                                  setState(() {
                                    products['${index}'] = products['${index}'] - snapshot.data[index]['price'];
                                  });
                                  setState(() {
                                    products['${index}amount']  = products['${index}amount']  - 1;
                                  });
                                  return;
                                }
                              }, icon: Icon(Icons.remove)),
                              Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: myBoxDecoration(),
                                  child: Text('\$${products['${index}'] == null ? snapshot.data[index]['price'].toStringAsFixed(2): products['${index}'].toStringAsFixed(2)}')
                              ),
                              IconButton(onPressed: () async {
                                if(products['${index}'] == null || products['${index}amount'] == 0){
                                  setState(() {
                                    products['${index}'] = snapshot.data[index]['price'] + snapshot.data[index]['price'];
                                  });
                                  setState(() {
                                    products['${index}amount'] = 1;
                                  });
                                  return;
                                }else if(products['${index}'] != null && products['${index}amount'] < snapshot.data[index]['amount']){
                                  setState(() {
                                    products['${index}'] = products['${index}'] + snapshot.data[index]['price'];
                                  });
                                  setState(() {
                                    products['${index}amount'] = products['${index}amount'] + 1;
                                  });
                                  print(products['${index}amount']);
                                  return;
                                }

                              }, icon: Icon(Icons.add)),
                              Icon(Icons.check_box)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (1 / 200),
              ),
            );
          }
        },
      ),
    );
  }

  PreferredSizeWidget FilterAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(110),  //// change height depending on the child height
      child: FutureBuilder<List>(
        future: get_all_stores(),
        builder: (
            BuildContext context,
            AsyncSnapshot<List> snapshot,
            ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: myBoxDecoration(),
                    child: DropDown(
                      items: ['Store',],
                      hint: Text(" ${json_language['Store']}",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      showUnderline: false,
                      icon: Icon(
                        Icons.expand_more,
                        color: Colors.blue,
                      ),
                      onChanged: print,
                    ),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: myBoxDecoration(),
                    child: DropDown(
                      items: ['Product List',],
                      hint: Text(" ${json_language['Product List']}",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      showUnderline: false,
                      icon: Icon(
                        Icons.expand_more,
                        color: Colors.blue,
                      ),
                      onChanged: print,
                    ),),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: myBoxDecoration(),
                    child: DropDown(
                      items: snapshot.data,
                      hint: Text(" ${json_language['Store']}",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      showUnderline: false,
                      icon: Icon(
                        Icons.expand_more,
                        color: Colors.blue,
                      ),
                      onChanged: print,
                    ),),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10,top: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: myBoxDecoration(),
                    child: DropDown(
                      items: ['Food',],
                      hint: Text(" ${json_language['Product List']}",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      showUnderline: false,
                      icon: Icon(
                        Icons.expand_more,
                        color: Colors.blue,
                      ),
                      onChanged: print,
                    ),),
                ),
              ],
            );
          }
        },
      ),
    );
  }

}