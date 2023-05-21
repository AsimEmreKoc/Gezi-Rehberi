import 'package:flutter/material.dart';


//Map Page
  class MapPage extends StatelessWidget {
      const MapPage({ Key? key }) : super(key: key);
                
       @override
         Widget build(BuildContext context) {
       return Scaffold(
            appBar:AppBar(
          // The search area here
          backgroundColor: Color.fromARGB(255, 12, 207, 18),
          title: Container(
        width: double.infinity,
        height: 40,
        )),
                      body: Center(child: Text('Bana En yakın Mekan'),),
                    );
                  }
                }