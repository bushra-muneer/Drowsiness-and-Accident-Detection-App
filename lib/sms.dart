import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:driverassistant/drawer.dart';
import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

const apiKey="AIzaSyBgEkPrSQgUgAHZPMg8hhUQnZYLxs3dqNU";

class CetCon
{
  static List<String> cont=[];
}

class SmsP extends StatefulWidget {
  const SmsP({Key key}) : super(key: key);

  @override
  _SmsPState createState() => _SmsPState();
}

class _SmsPState extends State<SmsP> {
  List<Contact> contacts =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Provider.of<LocationProvider>(context, listen: false).initialization();
    getAllContacts();
  }

  //LocationProvider pos;
  //LatLng  locationPosition;
  String lat,lon;





  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts(
        query: "Emergency")).toList();
    setState(() {
      contacts = _contacts;
    });
  }
  List<String> emer=[];
  // String k = locav.loci;
  // String temp = k.split(",") as String;
  @override
  Widget build(BuildContext context) {
    //Provider.of<LocationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:Text("Emergency Contacts"),
        // centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Container(
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: contacts.length,
              itemBuilder: (context,index){
                Contact contact = contacts[index];
                emer.add(contact.phones.elementAt(0).value);
                CetCon.cont.add(contact.phones.elementAt(0).value);
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(
                      contact.phones.elementAt(0).value
                  ),
                );
              },
            ),

            const SizedBox(height:30),
           /* TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                //_sendSMS("User is sleeping. Current Location: "+'https://www.google.com/maps/search/?api=1&query='+Value.latiu+','+Value.langa,emer);
              },//yhn msg b likhlo na sleepin , address krky
              child: const Text("Send Alert Message"),
            )*/

            //_sendSMS("User is sleeping. Current Location: "+'https://www.google.com/maps/search/?api=1&query='+Value.latiu+','+Value.langa,emer)
          ],

        ),
      ),
      //_sendSMS("User is sleeping. Current Location: "+'https://www.google.com/maps/search/?api=1&query='+Value.latiu+','+Value.langa,emer);
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          ContactsService.openContactForm();
        },
      ),

    );

  }

}


