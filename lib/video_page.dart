import 'dart:io';
import 'package:driverassistant/Register_Screen.dart';
import 'package:driverassistant/drawer.dart';
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
  //final fb = FirebaseDatabase.instance.reference().child("VideoLink");
  List<String> videos=[];
  getVideos() async{
    List<String> temp=[];
    User user = await FirebaseAuth.instance.currentUser;
    DatabaseReference _messagesRef = FirebaseDatabase.instance.reference().child(user.uid).child(user.uid);
    _messagesRef.onValue.listen((Event event) {
      var value=event.snapshot.value;
      print(value);
      value.forEach((key,value){
        temp.add(value['file']);
      });
    });
    setState(() {
      videos = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    getVideos();
  }
  void dispose() {
    super.dispose();
  }
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Videos'),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children:[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: videos.isEmpty ? 0 : videos.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: SelectableText("Uploaded Video"),
                    subtitle: SelectableText(
                        videos[index]==null ? "No videos uploaded" : videos[index]
                    ),
                  );
                },
              ),
         
              // ElevatedButton.icon(
              //
              //     onPressed: ()  async {
              //       PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);
              //       picfile = File(pickedFile.path);
              //       uploading==true?CircularProgressIndicator():Text("");
              //       await _upload('gallery');
              //     },
              //     icon: const Icon(Icons.library_add),
              //     label: const Text('Upload To Storage')),
              const SizedBox(height:30),
            ],

          ),

        ),
      ),
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);
          picfile = File(pickedFile.path);
          uploading==true?CircularProgressIndicator():Text("");
          await _upload('gallery');
        },
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
          'uploaded_by': user.uid,
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
  DatabaseReference _messagesRef = FirebaseDatabase.instance.reference().child(user.uid);
  _messagesRef.child(user.uid).push().set({
    'id':user.uid,
    'file':link,
  });
 

}

void openFile(PlatformFile File){
  OpenFile.open(File.path);
}

