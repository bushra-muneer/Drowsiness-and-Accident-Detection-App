import 'dart:io';
import 'package:driverassistant/Register_Screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';


class Rec{
  static String vidlink;
}
class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key key, this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}
var value;
var uuids;
var uuid;
var userNames;
var userName;
var images;
String link;
File picfile;
FirebaseStorage storage = FirebaseStorage.instance;
bool uploading=false;
class _VideoPageState extends State<VideoPage> {
  VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    super.dispose();
  }
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Videos'),
        elevation: 0,
        backgroundColor: Colors.black26,
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
            children: [
        Row(
        children:[
         /*  ElevatedButton(
            child: Text("Select a Recording"),
            onPressed: () async {
              PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);
              picfile = File(pickedFile.path);

              OpenFile.open(pickedFile.path);
            },

          ),

          SizedBox(width: 20,),
          */
          ElevatedButton.icon(

              onPressed: ()  async {
                PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);
                picfile = File(pickedFile.path);
                uploading==true?CircularProgressIndicator():Text("");
                await _upload('gallery');
              },
              icon: const Icon(Icons.library_add),
              label: const Text('Upload To Storage')),

        ],
        ),
            ],
        ),
        
      ),
    );
  }
}



Future<void> _upload(String inputSource) async {

  try {
    uploading=true;
    print("Uploadingg .... ");
    DatabaseReference db= FirebaseDatabase.instance.reference();
    User user = await FirebaseAuth.instance.currentUser;
    print(user.uid);
    //print(db.key);
    DatabaseReference d = db.child(users.uid);
    d.onValue.listen((Event event) {
       value = event.snapshot.value;
       print(d.key);
       uuids = value.keys;
       print(uuids);
      for( uuid in uuids) {
         userNames = value[uuid].keys;


        for( userName in userNames) {
           images = value[uuid][userName].values;
        //  var image = images.firstWhere((img) => img[count]== 1);
              print('uuid: $uuid, key: $userName');      //uuid is user id
              print('value: $images');}
      }
    });

    int currentUnix = DateTime.now().millisecondsSinceEpoch;
    String a = "Recording "+currentUnix.toString();

    // Uploading the selected image with some custom meta data
    await storage.ref(a).putFile(
        picfile,
        SettableMetadata(customMetadata: {
          'uploaded_by': 'Accident Detection',
          'description': 'Some description...'
        }));
    print("uploaded");
   // writeUserData(users.uid, link,uuid);
    _downloadLink(storage.ref(a));
    uploading=false;


    // Refresh the UI
  } on FirebaseException catch (error) {
    if (kDebugMode) {
      print(error);
    }

  } catch (err) {
    if (kDebugMode) {
      print(err);
    }
  }
}

Future<void> _downloadLink(Reference ref) async {
   link = await ref.getDownloadURL();
   Rec.vidlink=link.toString();
  print(link);

print("arha condition p");
   User user = await FirebaseAuth.instance.currentUser;
   print(user.uid);
   DatabaseReference db= FirebaseDatabase.instance.reference();

   DatabaseReference d = db.child(users.uid);
print(d.key);
print(uuids.toString());
   if (user.uid==d.key){
     print("men yahan hun ");
     DatabaseReference _messagesRef = FirebaseDatabase.instance.reference().child(user.uid);
    _messagesRef.push().set({
       'file':link,
     });
     print("Updation Complete ");
   }

}


/*
Future<void> writeUserData(Reference ref) async {
  DatabaseReference _messagesRef = FirebaseDatabase.instance.reference().child(users.uid);

  if (users.uid==uuid){
    print("men yahan hun ");
  _messagesRef.push().set({
    'file':link,
  });
  print("Updation Complete ");
  }
}
*/

/*
Future<void> _upload(String inputSource) async {

  try {
    int currentUnix = DateTime.now().millisecondsSinceEpoch;
    String a = "Recording "+currentUnix.toString();

    var ref= .ref("Uploads");
    TaskSnapshot snapshot = await storage
        .ref()
        .child("videos/$a")
        .putFile(picfile);



    // Uploading the selected image with some custom meta data
    await storage.ref(a).putFile(
        picfile,
        SettableMetadata(customMetadata: {
          'uploaded_by': 'Accident Detection',
          'description': 'Some description...'
        }));
    print("uploaded");
    _downloadLink(storage.ref(a));



    // Refresh the UI
  } on FirebaseException catch (error) {
    if (kDebugMode) {
      print(error);
    }

  } catch (err) {
    if (kDebugMode) {
      print(err);
    }
  }
}

Future<void> _downloadLink(Reference ref) async {
  final link = await ref.getDownloadURL();
  print(link);
}
*/


void openFile(PlatformFile File){
  OpenFile.open(File.path);
}

/*
void openFile(PlatformFile File){
  OpenFile.open(File.path);
}*/
