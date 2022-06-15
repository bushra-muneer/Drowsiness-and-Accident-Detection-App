import 'package:driverassistant/CameraPreview.dart';
import 'package:driverassistant/Login_Screen.dart';
import 'package:driverassistant/camera_Page.dart';
import 'package:driverassistant/sms.dart';
import 'package:driverassistant/video_page.dart';
import 'package:driverassistant/view_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            //accountName: Text("ABC"),
            accountEmail: Text(Name.email2),
          ),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Face Detection'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPreviewScanner(),
                ),

              );
            },
          ),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Recordings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPage(),
                ),

              );
            },
          ),

          ListTile(
            leading: Icon(Icons.attach_file),
            title: Text('View File'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => view_pdf(),
                ),

              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.map),
          //   title: Text('Location'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //
          //         builder: (context) => GoogleMapPage(),
          //       ),
          //
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Emergency Contacts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(

                  builder: (context) => SmsP(),
                ),

              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),

              );
            },
          ),
        ],
      ),


    );
  }
}
