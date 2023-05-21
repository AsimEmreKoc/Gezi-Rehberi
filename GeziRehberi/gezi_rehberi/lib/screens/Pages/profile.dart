import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gezi_rehberi/screens/Pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

final _firestore = FirebaseFirestore.instance;

class _profileState extends State<profile> {
  File? image;
  Future pickImage(ImageSource source) async{
 try { final image = await ImagePicker().pickImage(source: source);
  if(image==null) return;

 // final imageTemporary = File(image.path);
 final imagePermanent = await saveImagePermanently(image.path);
  setState(() =>
   this.image = imagePermanent);}
   on PlatformException catch (e){
    print('Resim Yüklenemedi: $e');
   }
  }
  Future<File> saveImagePermanently(String imagePath) async{
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }
 late File _Image;
  

  

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    var Kullanici = FirebaseFirestore.instance
        .collection('KullanıcıBilgisi')
        .where("KullanıcıId", isEqualTo: auth.currentUser!.uid);
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
            // The search area here
            backgroundColor: Color.fromARGB(255, 12, 207, 18),
            title: Container(
              width: double.infinity,
              height: 40,
            )),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Expanded(
            flex: 5,
            child: StreamBuilder<QuerySnapshot>(
                stream: Kullanici.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Center(
                      child: Text('Hata'),
                    );
                  }
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: Text('Bekleyin'),
                    );
                  }

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          asyncSnapshot.data!.docs[index];
                      return Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            TextFieldWidget(
                              label: 'İsim',
                              text: documentSnapshot['Ad'],

                            ),
                            SizedBox(
                              height: 8,
                            ),
                             TextFieldWidget(
                              label: 'Soyisim',
                              text: documentSnapshot['Soyad'],

                            ),
                            SizedBox(
                              height: 8,
                            ),
                             TextFieldWidget(
                              label: 'Email',
                              text: user.email!,

                            ),
                            SizedBox(
                              height: 50,
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(50),
                              ),
                              icon: Icon(
                                Icons.arrow_back,
                                size: 32,
                              ),
                              label: Text(
                                'ÇIKIŞ YAP',
                                style: TextStyle(fontSize: 24),
                              ),
                              onPressed: () => FirebaseAuth.instance.signOut(),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
        ));
  }
}

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String text;
  const TextFieldWidget({ Key? key,required this.label,required this.text}) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;
  @override
  void initState(){
    super.initState();
    controller = TextEditingController(text: widget.text);
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) =>
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      widget.label,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,),
    ),
    const SizedBox(height: 8,),
    TextField(
      controller: controller ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  ],
);
}