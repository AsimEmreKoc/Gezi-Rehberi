import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gezi_rehberi/screens/Details/Lists.dart';
import 'package:gezi_rehberi/screens/Pages/SearchPage.dart';
import 'package:gezi_rehberi/screens/Pages/MapPage.dart';
import 'package:gezi_rehberi/screens/Pages/fav.dart';
import 'package:gezi_rehberi/screens/Pages/login.dart';
import 'package:gezi_rehberi/screens/Pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../main.dart';
var fav= FirebaseFirestore.instance.collection('Şehirler').doc('Antalya').collection('Mekanlar').doc('Alanya Kalesi').get();
final _firestore = FirebaseFirestore.instance;
final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
var searchRef =_firestore.collection('Search');
var sehirRef = _firestore.collection('Şehirler');
var ist = sehirRef.doc('İstanbul').collection('İstanbulMekan');
var ant = sehirRef.doc('Antalya').collection('Mekanlar');
var siv = sehirRef.doc('Sivas').collection('SivasMekan');
var den = sehirRef.doc('Denizli').collection('DenizliMekan');
var bur = sehirRef.doc('Bursa').collection('BursaMekan');
var gaz = sehirRef.doc('Gaziantep').collection('AntepMekan');
var mar = sehirRef.doc('Mardin').collection('MardinMekan');
var mug = sehirRef.doc('Muğla').collection('MuğlaMekan');
var nev = sehirRef.doc('Nevşehir').collection('NevşehirMekan');
var can = sehirRef.doc('Çanakkale').collection('ÇanakkaleMekan');

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 12, 207, 18),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/gezi.jpg',
                fit: BoxFit.contain,
                height: 45,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Gezi Rehberi'))
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchPage());
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () =>  Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => HomePage1())),
                icon: Icon(Icons.favorite_outline_sharp)),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => profile()));
              },
              icon: Icon(Icons.person),
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Antalya',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: Row(children: [
                    SizedBox(
                        height: 130,
                        width: 391,
                        child: StreamBuilder(
                          stream: ant.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> asyncSnapShot) {
                            if (asyncSnapShot.hasError) {
                              //hata varsa hata mesajı gönder
                              return Text('Error:${asyncSnapShot.error}');
                            }
                            if (asyncSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              //bağlantı bekleniyorsa loadıng mesajı gönder
                              return Center(
                                child: Text('Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black)),
                              );
                            }
                            return ListView.builder(
                                //bağlantı geldiyse kodları çalıştır
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      asyncSnapShot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DetailsScreen(
                                                          product:
                                                              documentSnapshot,
                                                        ))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          documentSnapshot['image']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                         Positioned(
                                                  top: 5,
                                                  right: 2,
                                                   child: SizedBox(
                                                    height: 25,
                                                    width: 30,
                                                                     child:StatefulBuilder(builder: (context,state)=>  Container(
                                                 
                                                                       decoration: BoxDecoration(
                                                                           
                                                                           color: Colors.red,
                                                                           borderRadius: BorderRadius.circular(15)),
                                                                       child: documentSnapshot['fav']
                                                                           .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                           ? IconButton(
                                                                         icon: Icon(
                                                                           Icons.favorite_rounded,
                                                                           color: Color.fromARGB(255, 7, 234, 75),
                                                                           size: 15,
                                                                         ),
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                 .collection('Şehirler')
                                                                                 .doc('Antalya')
                                                                                 .collection('Mekanlar')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayRemove([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       )
                                                                           : IconButton(
                                                                         icon: Icon(Icons.favorite_border_rounded,size: 15),
                                                 
                                                                         color: Colors.black,
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                  .collection('Şehirler')
                                                                                  .doc('Antalya')
                                                                                 .collection('Mekanlar')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayUnion([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   ),
                                                 ),
                                       
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['ad'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 244, 243, 243),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )),
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Bursa',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: Row(children: [
                    SizedBox(
                        height: 130,
                        width: 391,
                        child: StreamBuilder(
                          stream: bur.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> asyncSnapShot) {
                            if (asyncSnapShot.hasError) {
                              //hata varsa hata mesajı gönder
                              return Text('Error:${asyncSnapShot.error}');
                            }
                            if (asyncSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              //bağlantı bekleniyorsa loadıng mesajı gönder
                              return Center(
                                child: Text('Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black)),
                              );
                            }
                            return ListView.builder(
                                //bağlantı geldiyse kodları çalıştır
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      asyncSnapShot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DetailsScreen(
                                                          product:
                                                              documentSnapshot,
                                                        ))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image:  NetworkImage(
                                                          documentSnapshot['image']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                                  top: 5,
                                                  right: 2,
                                                   child: SizedBox(
                                                    height: 25,
                                                    width: 30,
                                                                     child:StatefulBuilder(builder: (context,state)=>  Container(
                                                 
                                                                       decoration: BoxDecoration(
                                                                           
                                                                           
                                                                           borderRadius: BorderRadius.circular(15)),
                                                                       child: documentSnapshot['fav']
                                                                           .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                           ? IconButton(
                                                                         icon: Icon(
                                                                           Icons.favorite_rounded,
                                                                           color: Color.fromARGB(255, 7, 234, 75),
                                                                           size: 15,
                                                                         ),
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                 .collection('Şehirler')
                                                                                 .doc('Bursa')
                                                                                 .collection('BursaMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayRemove([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       )
                                                                           : IconButton(
                                                                         icon: Icon(Icons.favorite_border_rounded,size: 15),
                                                 
                                                                         color: Colors.black,
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                  .collection('Şehirler')
                                                                                   .doc('Bursa')
                                                                                 .collection('BursaMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayUnion([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   ),
                                                 ),
                                     
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['ad'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 244, 243, 243),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )),
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Denizli',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: Row(children: [
                    SizedBox(
                        height: 130,
                        width: 391,
                        child: StreamBuilder(
                          stream: den.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> asyncSnapShot) {
                            if (asyncSnapShot.hasError) {
                              //hata varsa hata mesajı gönder
                              return Text('Error:${asyncSnapShot.error}');
                            }
                            if (asyncSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              //bağlantı bekleniyorsa loadıng mesajı gönder
                              return Center(
                                child: Text('Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black)),
                              );
                            }
                            return ListView.builder(
                                //bağlantı geldiyse kodları çalıştır
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      asyncSnapShot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.orange[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DetailsScreen(
                                                          product:
                                                              documentSnapshot,
                                                        ))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image:  NetworkImage(
                                                          documentSnapshot['image']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                         Positioned(
                                                  top: 5,
                                                  right: 2,
                                                   child: SizedBox(
                                                    height: 25,
                                                    width: 30,
                                                                     child:StatefulBuilder(builder: (context,state)=>  Container(
                                                 
                                                                       decoration: BoxDecoration(
                                                                           
                                                                           
                                                                           borderRadius: BorderRadius.circular(15)),
                                                                       child: documentSnapshot['fav']
                                                                           .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                           ? IconButton(
                                                                         icon: Icon(
                                                                           Icons.favorite_rounded,
                                                                           color: Color.fromARGB(255, 7, 234, 75),
                                                                           size: 15,
                                                                         ),
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                 .collection('Şehirler')
                                                                                 .doc('Denizli')
                                                                                 .collection('DenizliMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayRemove([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       )
                                                                           : IconButton(
                                                                         icon: Icon(Icons.favorite_border_rounded,size: 15),
                                                 
                                                                         color: Colors.black,
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                  .collection('Şehirler')
                                                                                  .doc('Denizli')
                                                                                 .collection('DenizliMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayUnion([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   ),
                                                 ),
                                     
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['ad'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 244, 243, 243),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )),
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Gaziantep',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: Row(children: [
                    SizedBox(
                        height: 130,
                        width: 391,
                        child: StreamBuilder(
                          stream: gaz.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> asyncSnapShot) {
                            if (asyncSnapShot.hasError) {
                              //hata varsa hata mesajı gönder
                              return Text('Error:${asyncSnapShot.error}');
                            }
                            if (asyncSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              //bağlantı bekleniyorsa loadıng mesajı gönder
                              return Center(
                                child: Text('Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black)),
                              );
                            }
                            return ListView.builder(
                                //bağlantı geldiyse kodları çalıştır
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      asyncSnapShot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.orange[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DetailsScreen(
                                                          product:
                                                              documentSnapshot,
                                                        ))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image:  NetworkImage(
                                                          documentSnapshot['image']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                                  top: 5,
                                                  right: 2,
                                                   child: SizedBox(
                                                    height: 25,
                                                    width: 30,
                                                                     child:StatefulBuilder(builder: (context,state)=>  Container(
                                                 
                                                                       decoration: BoxDecoration(
                                                                           
                                                                           
                                                                           borderRadius: BorderRadius.circular(15)),
                                                                       child: documentSnapshot['fav']
                                                                           .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                           ? IconButton(
                                                                         icon: Icon(
                                                                           Icons.favorite_rounded,
                                                                           color: Color.fromARGB(255, 7, 234, 75),
                                                                           size: 15,
                                                                         ),
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                 .collection('Şehirler')
                                                                                  .doc('Gaziantep')
                                                                                 .collection('AntepMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayRemove([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       )
                                                                           : IconButton(
                                                                         icon: Icon(Icons.favorite_border_rounded,size: 15),
                                                 
                                                                         color: Colors.black,
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                  .collection('Şehirler')
                                                                                  .doc('Gaziantep')
                                                                                 .collection('AntepMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayUnion([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   ),
                                                 ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['ad'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 244, 243, 243),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )),
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Mardin',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: Row(children: [
                    SizedBox(
                        height: 130,
                        width: 391,
                        child: StreamBuilder(
                          stream: mar.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> asyncSnapShot) {
                            if (asyncSnapShot.hasError) {
                              //hata varsa hata mesajı gönder
                              return Text('Error:${asyncSnapShot.error}');
                            }
                            if (asyncSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              //bağlantı bekleniyorsa loadıng mesajı gönder
                              return Center(
                                child: Text('Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black)),
                              );
                            }
                            return ListView.builder(
                                //bağlantı geldiyse kodları çalıştır
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      asyncSnapShot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.yellow[600],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DetailsScreen(
                                                          product:
                                                              documentSnapshot,
                                                        ))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image:  NetworkImage(
                                                          documentSnapshot['image']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                         Positioned(
                                                  top: 5,
                                                  right: 2,
                                                   child: SizedBox(
                                                    height: 25,
                                                    width: 30,
                                                                     child:StatefulBuilder(builder: (context,state)=>  Container(
                                                 
                                                                       decoration: BoxDecoration(
                                                                           
                                                                           
                                                                           borderRadius: BorderRadius.circular(15)),
                                                                       child: documentSnapshot['fav']
                                                                           .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                           ? IconButton(
                                                                         icon: Icon(
                                                                           Icons.favorite_rounded,
                                                                           color: Color.fromARGB(255, 7, 234, 75),
                                                                           size: 15,
                                                                         ),
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                 .collection('Şehirler')
                                                                                  .doc('Mardin')
                                                                                 .collection('MardinMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayRemove([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       )
                                                                           : IconButton(
                                                                         icon: Icon(Icons.favorite_border_rounded,size: 15),
                                                 
                                                                         color: Colors.black,
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                  .collection('Şehirler')
                                                                                  .doc('Mardin')
                                                                                 .collection('MardinMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayUnion([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   ),
                                                 ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['ad'],
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 244, 243, 243),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )),
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Muğla',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: Row(children: [
                    SizedBox(
                        height: 130,
                        width: 391,
                        child: StreamBuilder(
                          stream: mug.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> asyncSnapShot) {
                            if (asyncSnapShot.hasError) {
                              //hata varsa hata mesajı gönder
                              return Text('Error:${asyncSnapShot.error}');
                            }
                            if (asyncSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              //bağlantı bekleniyorsa loadıng mesajı gönder
                              return Center(
                                child: Text('Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black)),
                              );
                            }
                            return ListView.builder(
                                //bağlantı geldiyse kodları çalıştır
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      asyncSnapShot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.green[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DetailsScreen(
                                                          product:
                                                              documentSnapshot,
                                                        ))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image:  NetworkImage(
                                                          documentSnapshot['image']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                       Positioned(
                                                  top: 5,
                                                  right: 2,
                                                   child: SizedBox(
                                                    height: 25,
                                                    width: 30,
                                                                     child:StatefulBuilder(builder: (context,state)=>  Container(
                                                 
                                                                       decoration: BoxDecoration(
                                                                           
                                                                           
                                                                           borderRadius: BorderRadius.circular(15)),
                                                                       child: documentSnapshot['fav']
                                                                           .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                           ? IconButton(
                                                                         icon: Icon(
                                                                           Icons.favorite_rounded,
                                                                           color: Color.fromARGB(255, 7, 234, 75),
                                                                           size: 15,
                                                                         ),
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                 .collection('Şehirler')
                                                                                  .doc('Muğla')
                                                                                 .collection('MuğlaMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayRemove([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       )
                                                                           : IconButton(
                                                                         icon: Icon(Icons.favorite_border_rounded,size: 15),
                                                 
                                                                         color: Colors.black,
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                  .collection('Şehirler')
                                                                                  .doc('Muğla')
                                                                                 .collection('MuğlaMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayUnion([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   ),
                                                 ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['ad'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 244, 243, 243),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )),
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Nevşehir',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: Row(children: [
                    SizedBox(
                        height: 130,
                        width: 391,
                        child: StreamBuilder(
                          stream: nev.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> asyncSnapShot) {
                            if (asyncSnapShot.hasError) {
                              //hata varsa hata mesajı gönder
                              return Text('Error:${asyncSnapShot.error}');
                            }
                            if (asyncSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              //bağlantı bekleniyorsa loadıng mesajı gönder
                              return Center(
                                child: Text('Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black)),
                              );
                            }
                            return ListView.builder(
                                //bağlantı geldiyse kodları çalıştır
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      asyncSnapShot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DetailsScreen(
                                                          product:
                                                              documentSnapshot,
                                                        ))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image:  NetworkImage(
                                                          documentSnapshot['image']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                                  top: 5,
                                                  right: 2,
                                                   child: SizedBox(
                                                    height: 25,
                                                    width: 30,
                                                                     child:StatefulBuilder(builder: (context,state)=>  Container(
                                                 
                                                                       decoration: BoxDecoration(
                                                                           
                                                                           
                                                                           borderRadius: BorderRadius.circular(15)),
                                                                       child: documentSnapshot['fav']
                                                                           .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                           ? IconButton(
                                                                         icon: Icon(
                                                                           Icons.favorite_rounded,
                                                                           color: Color.fromARGB(255, 7, 234, 75),
                                                                           size: 15,
                                                                         ),
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                 .collection('Şehirler')
                                                                                  .doc('Nevşehir')
                                                                                 .collection('NevşehirMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayRemove([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       )
                                                                           : IconButton(
                                                                         icon: Icon(Icons.favorite_border_rounded,size: 15),
                                                 
                                                                         color: Colors.black,
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                  .collection('Şehirler')
                                                                                  .doc('Nevşehir')
                                                                                 .collection('NevşehirMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayUnion([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   ),
                                                 ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['ad'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 244, 243, 243),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )),
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Sivas',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: Row(children: [
                    SizedBox(
                        height: 130,
                        width: 391,
                        child: StreamBuilder(
                          stream: siv.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> asyncSnapShot) {
                            if (asyncSnapShot.hasError) {
                              //hata varsa hata mesajı gönder
                              return Text('Error:${asyncSnapShot.error}');
                            }
                            if (asyncSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              //bağlantı bekleniyorsa loadıng mesajı gönder
                              return Center(
                                child: Text('Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black)),
                              );
                            }
                            return ListView.builder(
                                //bağlantı geldiyse kodları çalıştır
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      asyncSnapShot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DetailsScreen(
                                                          product:
                                                              documentSnapshot,
                                                        ))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image:  NetworkImage(
                                                          documentSnapshot['image']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                         Positioned(
                                                  top: 5,
                                                  right: 2,
                                                   child: SizedBox(
                                                    height: 25,
                                                    width: 30,
                                                                     child:StatefulBuilder(builder: (context,state)=>  Container(
                                                 
                                                                       decoration: BoxDecoration(
                                                                           
                                                                           
                                                                           borderRadius: BorderRadius.circular(15)),
                                                                       child: documentSnapshot['fav']
                                                                           .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                           ? IconButton(
                                                                         icon: Icon(
                                                                           Icons.favorite_rounded,
                                                                           color: Color.fromARGB(255, 7, 234, 75),
                                                                           size: 15,
                                                                         ),
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                 .collection('Şehirler')
                                                                                  .doc('Sivas')
                                                                                 .collection('SivasMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayRemove([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       )
                                                                           : IconButton(
                                                                         icon: Icon(Icons.favorite_border_rounded,size: 15),
                                                 
                                                                         color: Colors.black,
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                  .collection('Şehirler')
                                                                                  .doc('Sivas')
                                                                                 .collection('SivasMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayUnion([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   ),
                                                 ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['ad'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 244, 243, 243),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )),
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'Çanakkale',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: Row(children: [
                    SizedBox(
                        height: 130,
                        width: 391,
                        child: StreamBuilder(
                          stream: can.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> asyncSnapShot) {
                            if (asyncSnapShot.hasError) {
                              //hata varsa hata mesajı gönder
                              return Text('Error:${asyncSnapShot.error}');
                            }
                            if (asyncSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              //bağlantı bekleniyorsa loadıng mesajı gönder
                              return Center(
                                child: Text('Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black)),
                              );
                            }
                            return ListView.builder(
                                //bağlantı geldiyse kodları çalıştır
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      asyncSnapShot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DetailsScreen(
                                                          product:
                                                              documentSnapshot,
                                                        ))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image:  NetworkImage(
                                                          documentSnapshot['image']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                                  top: 5,
                                                  right: 2,
                                                   child: SizedBox(
                                                    height: 25,
                                                    width: 30,
                                                                     child:StatefulBuilder(builder: (context,state)=>  Container(
                                                 
                                                                       decoration: BoxDecoration(
                                                                           
                                                                           
                                                                           borderRadius: BorderRadius.circular(15)),
                                                                       child: documentSnapshot['fav']
                                                                           .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                           ? IconButton(
                                                                         icon: Icon(
                                                                           Icons.favorite_rounded,
                                                                           color: Color.fromARGB(255, 7, 234, 75),
                                                                           size: 15,
                                                                         ),
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                 .collection('Şehirler')
                                                                                  .doc('Çanakkale')
                                                                                 .collection('ÇanakkaleMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayRemove([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       )
                                                                           : IconButton(
                                                                         icon: Icon(Icons.favorite_border_rounded,size: 15),
                                                 
                                                                         color: Colors.black,
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                  .collection('Şehirler')
                                                                                  .doc('Çanakkale')
                                                                                 .collection('ÇanakkaleMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayUnion([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   ),
                                                 ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['ad'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 244, 243, 243),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )),
                  ])),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'İstanbul',
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                      child: Row(children: [
                    SizedBox(
                        height: 130,
                        width: 391,
                        child: StreamBuilder(
                          stream: ist.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> asyncSnapShot) {
                            if (asyncSnapShot.hasError) {
                              //hata varsa hata mesajı gönder
                              return Text('Error:${asyncSnapShot.error}');
                            }
                            if (asyncSnapShot.connectionState ==
                                ConnectionState.waiting) {
                              //bağlantı bekleniyorsa loadıng mesajı gönder
                              return Center(
                                child: Text('Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black)),
                              );
                            }
                            return ListView.builder(
                                //bağlantı geldiyse kodları çalıştır
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      asyncSnapShot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    height: 200,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[700],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 1),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        DetailsScreen(
                                                          product:
                                                              documentSnapshot,
                                                        ))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                      image:  NetworkImage(
                                                          documentSnapshot['image']),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                         Positioned(
                                                  top: 5,
                                                  right: 2,
                                                   child: SizedBox(
                                                    height: 25,
                                                    width: 30,
                                                                     child:StatefulBuilder(builder: (context,state)=>  Container(
                                                 
                                                                       decoration: BoxDecoration(
                                                                           
                                                                           
                                                                           borderRadius: BorderRadius.circular(15)),
                                                                       child: documentSnapshot['fav']
                                                                           .contains(FirebaseAuth.instance.currentUser!.uid)
                                                                           ? IconButton(
                                                                         icon: Icon(
                                                                           Icons.favorite_rounded,
                                                                           color: Color.fromARGB(255, 7, 234, 75),
                                                                           size: 15,
                                                                         ),
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                 .collection('Şehirler')
                                                                                  .doc('İstanbul')
                                                                                 .collection('İstanbulMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayRemove([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       )
                                                                           : IconButton(
                                                                         icon: Icon(Icons.favorite_border_rounded,size: 15),
                                                 
                                                                         color: Colors.black,
                                                                         onPressed: () {
                                                                           state(() {
                                                                             FirebaseFirestore.instance
                                                                                  .collection('Şehirler')
                                                                                  .doc('İstanbul')
                                                                                 .collection('İstanbulMekan')
                                                                                 .doc(
                                                                               documentSnapshot.id,
                                                                             )
                                                                                 .update({
                                                                               'fav': FieldValue.arrayUnion([
                                                                                 FirebaseAuth.instance.currentUser!.uid
                                                                               ])
                                                                             });
                                                                           });
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   ),
                                                 ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                              vertical: 2,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  documentSnapshot['ad'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 244, 243, 243),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                        )),
                  ])),
                ])));
  }
}

FirebaseAuth auth = FirebaseAuth.instance;
class DetailsScreen extends StatefulWidget {
  final DocumentSnapshot product;
  const DetailsScreen({Key? key, required this.product,}) : super(key: key);
  
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  double rating = 0;
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 12, 207, 18),
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/gezi.jpg',
              fit: BoxFit.contain,
              height: 45,
            ),
            Container(
                padding: const EdgeInsets.all(8.0), child: Text('Gezi Rehberi'))
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchPage());
              },
              icon: Icon(Icons.search)),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => profile()));
            },
            icon: Icon(Icons.login),
          ),
        ],
      ),
      body:  ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
               Center(
                      child: Container(
                        width: 500,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: NetworkImage(widget.product['image']),
                                fit: BoxFit.cover)),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                Text(
                widget.product['ad'],
                style: TextStyle(fontSize: 22),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                
                children: [
                    Text('Rating: $rating',
              style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10,),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                itemSize: 18,
                itemPadding: EdgeInsets.symmetric(horizontal: 1),
                itemBuilder: (context, _)=>Icon(Icons.star,color: Colors.amber,),
                updateOnDrag: true,
                onRatingUpdate: (rating)=>setState(() {
                  this.rating = rating;
                }),
              
              ),
                ],
              ),
             
              ],),
             
              SizedBox(
                height: 10,
              ),
              Container(
                  color: Colors.blue[100],
                  child: Column(
                    children: [
                      Text(
                        widget.product['Bilgi'],
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        widget.product['Saat'],
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        widget.product['Ücret'],
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        widget.product['Konum'],
                        style: TextStyle(fontSize: 22),
                      ),
                       SizedBox(
                        height: 20,
                      ),        
                     
                    ],  
                    
                  )),
              SizedBox(
                height: 5,
              ), 
                       
                        
            ],
          ),
        ),
        
      ]),
      
    );
  }

  Future YorumYap() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    FirebaseFirestore.instance
        .collection('Yorumlar')
        .doc(widget.product['ad'])
        .update({'Yorum':  FieldValue.arrayUnion([t1.text
                              ])});
  }
}
