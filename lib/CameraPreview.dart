import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:driverassistant/video_page.dart';
import 'package:driverassistant/view_file.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:telephony/telephony.dart';
import 'Login_Screen.dart';
import 'drawer.dart';
import 'scanner_utils.dart';



class Info {
  static String locationu;
  static List<String> emerg=[];
  static List<String> emailsg=[];
}
class CameraPreviewScanner extends StatefulWidget {
  const CameraPreviewScanner({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CameraPreviewScannerState();
}
String username = 'detectionaccident331@gmail.com';
String password = 'hkyifacphjnhvfqe';
final smtpServer = gmail(username, password);
class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  dynamic _scanResults;
  String albumName = 'Media';

  CameraController _camera;
  CameraController _cameraController;
  CameraController _cam2;
  List<CameraDescription> cameras;


  bool _isDetecting = false;
  bool click=false;

  bool _isLoading = true;
  bool _isRecording = false;

  CameraLensDirection _direction = CameraLensDirection.front;
  bool km=false;
  int temp=0;
  int stopr=0;
  int ik =0;
  DateTime tempol;
  DateTime temp2,temp3;
  Position position;
  int verf=0;
  int tre=0;
  int trem=0;
  int ika=0;
  int verfa=0;
  int tempr=0;
  StreamSubscription accid;
  double x=0;
  double y=0;
  double z =0;
  double xsqr;
  double ysqr;
  double zsqr;
  double totall;
  List<double> _userAccelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  //XFile videoFile;

  //VideoPlayerController videoController;
  //XFile imageFile;
  String _VideoFile;
  //VoidCallback videoPlayerListener;
  final Telephony tp = Telephony.instance;
  //final Tg sm = new Tg();
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FaceDetector _faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
          mode: FaceDetectorMode.accurate,
          enableLandmarks: true,
          enableClassification: true,
          enableContours: true
        // enableTracking: true
      ));
  List<Contact> contacts =[];

  @override
  initState() {
    super.initState();
    //Provider.of<LocationProvider>(context, listen: false).initialization();
    getAllContacts();
    //getCam();
    //_initCamera();
    _initializeCamera();
    accelerometerEvents.listen((AccelerometerEvent event) {
      x=event.x;
      y=event.y;
      z=event.z;
    });

   /* xsqr=pow(x,2);
    ysqr=pow(y,2);
    zsqr=pow(z,2);
    totall=sqrt(xsqr+ysqr+zsqr);*/
    // if(accid==null){
    //   userAccelerometerEvents.listen(
    //         (UserAccelerometerEvent event) {
    //       setState(() {
    //         x=event.x;
    //         y=event.y;
    //         z=event.z;
    //       });
    //     },
    //   );
    // }
    // else{
    //   accid.resume();
    // }
    // userAccelerometerEvents.listen(
    //       (UserAccelerometerEvent event) {
    //     setState(() {
    //       x=event.x;
    //       y=event.y;
    //       z=event.z;
    //     });
    //   },
    // );
    //_initCamera1();
    // _initializeCamera();

  }
  getCam() async{
    await _initCamera();
    await _initCamera1();
  }

  _initCamera() async {
    print("DFEFE");
     List<CameraDescription> cameras;
     cameras = await availableCameras();
     print("CAM2 CAMERAS"+cameras.toString());
    _cameraController = CameraController(cameras[1],
      defaultTargetPlatform == TargetPlatform.android
          ? ResolutionPreset.medium
          : ResolutionPreset.low,);
    await _cameraController.initialize();
    print("GEGEGEGEG");
    setState(() => _isLoading = false);
  }
 void _initCamera1() async {
   print("DFEFE");
    List<CameraDescription> cameras;
    cameras = await availableCameras();
   print("CAM2 CAMERAS"+cameras.toString());
    _cam2 = CameraController(cameras[0],
      defaultTargetPlatform == TargetPlatform.android
          ? ResolutionPreset.medium
          : ResolutionPreset.low,);
    await _cam2.initialize().catchError((onError) => print(onError));
    print("SUPPPP");
    setState(() => _isLoading = false);
  }
  List<String> emer=[];
  List<String> emails=[];
  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts(
        query: "Emergency")).toList();
    setState(() {
      contacts = _contacts;
    });
    for(var i=0; i<contacts.length; i++)
    {
      Contact contact = contacts[i];
      emer.add(contact.phones.elementAt(0).value);
      emails.add(contact.emails.elementAt(0).value);
      Info.emerg.add(contact.phones.elementAt(0).value);
      Info.emailsg.add(contact.emails.elementAt(0).value);
    }
  }
  void _initializeCamera() async {
     List<CameraDescription> cameras;
     cameras = await availableCameras();
     print("ORGINAL CAM CAMERAS"+cameras.toString());
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Info.locationu='https://www.google.com/maps/search/?api=1&query=' +
        position.latitude.toString() + ',' +
        position.longitude.toString();
    final CameraDescription description =
    await ScannerUtils.getCamera(_direction);
    setState(() {});
    _camera = CameraController(
      cameras[1],
      defaultTargetPlatform == TargetPlatform.android
          ? ResolutionPreset.medium
          : ResolutionPreset.low,
    );

    await _camera.initialize().catchError((onError) => print(onError));
    print("HEAAAA");
    //_recordVideo();
    _camera.startImageStream((CameraImage image){

      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _faceDetector.processImage,
        imageRotation: description.sensorOrientation,
      ).then(
            (dynamic results) {
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
    //_recordVideo();
  }

 /* void _recordVideonew() async {
    ImagePicker()
        .getVideo(source: ImageSource.camera)
        .then((PickedFile recordedVideo) {
      if (recordedVideo != null && recordedVideo.path != null) {
        setState(() {
         print('saving in progress...');
        });
        GallerySaver.saveVideo(recordedVideo.path, albumName: albumName)
            .then((bool success) {
          setState(() {
            print('video saved!');
          });
        });
      }
    });
  }*/


  _recordVideo() async {
    if (_isRecording) {
      await DefaultCacheManager().emptyCache();
      final file = await _cameraController.stopVideoRecording();
     // final file = await _camera.stopVideoRecording();
      print("test stop");
      /*await GallerySaver.saveVideo(file.path);
      File(file.path).deleteSync();*/
      print(file.path);
      print("SAVED");
      File videoFile = File(file.path);

      int currentUnix = DateTime.now().millisecondsSinceEpoch;

      final directory = await getApplicationDocumentsDirectory();
      String fileFormat = videoFile.path.split('.').last;

      var _videoFile = await videoFile.copy(
        '${directory.path}/$currentUnix.$fileFormat',
      );
      print(_videoFile);

      _VideoFile=(_videoFile).toString();
      print("videoooo");
      print(_VideoFile);
      String a = currentUnix.toString();

      //  var prefix = parts[0].trim();                 // prefix: "date"
      // var date = parts.sublist(1).join(':').trim(); // date: "'2019:04:01'"

      //File: '/data/user/0/com.example.driverassistant/app_flutter/1641413277505.mp4'
      var parts = _VideoFile.split(':');
      // prefix: "date"
      var date = parts.sublist(1).join(':').trim();
      print("path of date");
      print(date);
      GallerySaver.saveVideo(file.path);
      print("gallery saver");

      String newdate=date.substring(1,date.length-1);
      print(newdate);
      await File(newdate).copy('/storage/emulated/0/DCIM/Recordings/'+a+'.mp4');
      //   await File(date).copySync('/storage/emulated/0/DCIM/Camera/'+a+'.mp4');
      //showInSnackBar('Video Recording saved in Internal Storage/DCIM/Camera/'+a+'.mp4');
      print("saving test");
      final snackBar = SnackBar(content: Text('Recording Saved at Gallery. Name: '+a+'.mp4'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);


      //_isRecording=false;
      setState(() => _isRecording = false);
      //_buildResults();
      // final route = MaterialPageRoute(
      //   fullscreenDialog: true,
      //   builder: (_) => CameraPreviewScanner(),
      // );
      //Navigator.push(context, route);
    } else {
       await DefaultCacheManager().emptyCache();
       await _cameraController.prepareForVideoRecording();
       await _cameraController.startVideoRecording();
       final snackBar = SnackBar(content: Text("Recording Started"));
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
         // showDialog(
         //   context: context,
         //   builder: (ctx) => AlertDialog(
         //     title: Text("Recording Started"),
         //     actions: [
         //       TextButton(
         //         onPressed: () {
         //           Navigator.of(ctx).pop();
         //         },
         //         child: Text('Okay'),
         //       )
         //     ],
         //   ),
         // );
      //await _camera.prepareForVideoRecording();
      //await _camera.startVideoRecording();
      /* print("trying build camera");
       _initCamera();
       _initializeCamera();
       _buildResults();*/



      setState(() => _isRecording = true);

    }

  }
  _recordVideo1() async {
    if (_isRecording) {
      //final file = await _cameraController.stopVideoRecording();
       final file = await _camera.stopVideoRecording();
      print("test stop");
      /*await GallerySaver.saveVideo(file.path);
      File(file.path).deleteSync();*/
      print(file.path);
      print("SAVED");
      File videoFile = File(file.path);

      int currentUnix = DateTime.now().millisecondsSinceEpoch;

      final directory = await getApplicationDocumentsDirectory();
      String fileFormat = videoFile.path.split('.').last;

      var _videoFile = await videoFile.copy(
        '${directory.path}/$currentUnix.$fileFormat',
      );
      print(_videoFile);

      _VideoFile=(_videoFile).toString();
      print("videoooo");
      print(_VideoFile);
      String a = currentUnix.toString();

      //  var prefix = parts[0].trim();                 // prefix: "date"
      // var date = parts.sublist(1).join(':').trim(); // date: "'2019:04:01'"

      //File: '/data/user/0/com.example.driverassistant/app_flutter/1641413277505.mp4'
      var parts = _VideoFile.split(':');
      // prefix: "date"
      var date = parts.sublist(1).join(':').trim();
      print("path of date");
      print(date);
      GallerySaver.saveVideo(file.path);
      print("gallery saver");

      String newdate=date.substring(1,date.length-1);
      print(newdate);
      await File(newdate).copy('/storage/emulated/0/DCIM/Recordings/'+a+'.mp4');
      //   await File(date).copySync('/storage/emulated/0/DCIM/Camera/'+a+'.mp4');
      //showInSnackBar('Video Recording saved in Internal Storage/DCIM/Camera/'+a+'.mp4');
      print("saving test");
      final snackBar = SnackBar(content: Text('Recording Saved at Gallery. Name: '+a+'.mp4'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);


      //_isRecording=false;
      setState(() => _isRecording = false);
      // Navigator.push(context,MaterialPageRoute(
      //   builder: (context) =>CameraPreviewScanner(),
      // ),);
      //_buildResults();
      // final route = MaterialPageRoute(
      //   fullscreenDialog: true,
      //   builder: (_) => CameraPreviewScanner(),
      // );
      //Navigator.push(context, route);
    } else {
      //await DefaultCacheManager().emptyCache();
      await _camera.prepareForVideoRecording();
      await _camera.startVideoRecording();
      // await _cameraController.prepareForVideoRecording();
      // await _cameraController.startVideoRecording();
      await DefaultCacheManager().emptyCache();
      final snackBar = SnackBar(content: Text("Recording Started"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("record checkkkkkkkkkkkkkkkkkkkkkk");
      //_buildResults();


     for (int i=0;i<5;i++){
       print("texxttt while recordinn");

     }
     print(tempr);

       print("now value is 1");


      // Navigator.push(context,MaterialPageRoute(
      //   builder: (context) =>CameraPreviewScanner(),
      // ),);

      //   context: context,
      //   builder: (ctx) => AlertDialog(
      //     title: Text("Recording Started"),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Navigator.of(ctx).pop();
      //         },
      //         child: Text('Okay'),
      //       )
      //     ],
      //   ),
      // );
      // await _camera.prepareForVideoRecording();
      // await _camera.startVideoRecording();
      // setState(() {
      //
      //   return _isRecording = true;
      // });
      setState(() => _isRecording = true);
    }

  }


  Widget _buildResults()  {
    Text noResultsText = Text('No Face detected yet!');

    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized||tempr==0) {
      print("no results");
      return noResultsText;
    }
  // if(_isRecording){
  //   _cameraController.pauseVideoRecording();
  // }
    CustomPainter painter;
    view_pdf vd;
    if (_scanResults is! List<Face>) return noResultsText;
    final List<Face> faces=_scanResults;
    //_recordVideo();
    for (Face face in faces) {
      // if(_isRecording){
      //   _cameraController.resumeVideoRecording();
      // }
      double averageEyeOpenProb =
          (face.leftEyeOpenProbability + face.rightEyeOpenProbability) / 2.0;
      double l = face.leftEyeOpenProbability;
      double r = face.rightEyeOpenProbability;
      // accelerometerEvents.listen((AccelerometerEvent event) {
      //   x=event.x;
      //   y=event.y;
      //   z=event.z;
      // });
      // userAccelerometerEvents.listen(
      //       (UserAccelerometerEvent event) {
      //     setState(() {
      //       x=event.x;
      //       y=event.y;
      //       z=event.z;
      //     });
      //   },
      // );
      // if(accid==null){
      //   userAccelerometerEvents.listen(
      //         (UserAccelerometerEvent event) {
      //       setState(() {
      //         x=event.x;
      //         y=event.y;
      //         z=event.z;
      //       });
      //     },
      //   );
      // }
      // else{
      //   accid.resume();
      // }
      print(l);
      print(r);
      print("x");
      print(x);
      print("y");
      print(y);
      xsqr=pow(x,2);
      ysqr=pow(y,2);
      zsqr=pow(z,2);
      totall=sqrt(xsqr+ysqr+zsqr);
      //print(z);
      print("total g: "+totall.toString());
        if (totall > 20) {
          Future.delayed(Duration(seconds: 1), () {
            FlutterRingtonePlayer.playRingtone(
                asAlarm: true,
                looping: true);
            _showDialog1(context);
          });
          print("ACICDDENTTTT");
          for(int i=0;i<emer.length;i++) {
            tp.sendSms(to: emer[i],
                message: "User has gotten into an accident. Current Location: " +
                    'https://www.google.com/maps/search/?api=1&query=' +
                    position.latitude.toString() + ',' +
                    position.longitude.toString());
          }
          for(int i=0;i<emails.length;i++){
            final message = Message()
              ..from = Address(username, 'Driver Assistant')
              ..recipients.add(emails[i])
              ..subject = 'ACCIDENT DETECTED!!! ${DateTime.now()}'
              ..text ="User has gotten into an accident. Current Location: "+'https://www.google.com/maps/search/?api=1&query='+position.latitude.toString()+','+position.longitude.toString();
            send(message,smtpServer);
          }
          // generatefile();
          // Navigator.push(context,MaterialPageRoute(
          //   builder: (context) =>CameraPreviewScanner(),
          // ),);

        }

      if(tre==0){
        if(averageEyeOpenProb<0.6)
        {
          print("left");
          print(l);
          print("right");
          print(r);
          if(ik==0){
            tempol = DateTime.now();//a=5 //9:05.01
            temp2=tempol.add(const Duration(seconds: 1));
            //  temp2=tempol;
            //print(tempol);
            ik+=1;
          }
          print("ok");
          // print(tempol);
          temp2=temp2.add(const Duration(seconds: 1));//9:05.00
          //  print(temp2);
          if(verf==0){
            if(tempol.add(const Duration(seconds: 10))==temp2){//9.05/10
              print("TIMMMMME");
              print(DateTime.now());
              // FlutterRingtonePlayer.playNotification();
              print("HELOOOOOOOOOOOOOO");
              Future.delayed(Duration(seconds:1), () {
                FlutterRingtonePlayer.playRingtone(
                    asAlarm: true,
                    looping: true);
                // if(_isRecording){
                //    _recordVideo();
                // }
                _showDialog(context);
                //_recordVideo();
                tempol = DateTime.now();
                temp2=null;
                temp2 = tempol;
              });
              verf+=1;
            }
          }
          else{
            print("HELLLO");
            temp2 = temp2.add(const Duration(seconds: 1));
            if(tempol.add(const Duration(seconds: 10))==temp2){
              print("hhyht");
              // position =  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
              for(int i=0;i<emer.length;i++) {
                tp.sendSms(to: emer[i],
                    message: "User is sleeping. Current Location: " +
                        'https://www.google.com/maps/search/?api=1&query=' +
                        position.latitude.toString() + ',' +
                        position.longitude.toString());
              }
              for(int i=0;i<emails.length;i++){
                //sendDrowsiness(emails[i], DateTime.now(), position.latitude.toString()+','+position.longitude.toString());
                final message = Message()
                  ..from = Address(username, 'Driver Assistant')
                  ..recipients.add(emails[i])
                  ..subject = 'DROWSINESS DETECTED!!! ${DateTime.now()}'
                  ..text ="User is sleeping. Current Location: "+'https://www.google.com/maps/search/?api=1&query='+position.latitude.toString()+','+position.longitude.toString();
                send(message,smtpServer);
              }
              // if(_isRecording){
              //   _recordVideo();
              // }
              print("heyoo");
              tempol=DateTime.now();
              temp2=null;
              temp2=tempol;
              //verf=0;
              tre+=1;
              break;
            }
            break;

          }
          break;
         }

      }


    }

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _b(){
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
          ],
        ),
      );
    }
  }
  Future<void> generatefile() async {
    print("file bnaunga hehe");
    final PdfDocument document = PdfDocument();
    PdfPage page1 = document.pages.add();
    print("file page hehe");
    //String data="abc";

    page1.graphics.drawString(
        "Accident Report ", PdfStandardFont(PdfFontFamily.helvetica,20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(168, 10, 450, 50));

    page1.graphics.drawString(
        "User Email: "+Name.email2+"\n", PdfStandardFont(PdfFontFamily.helvetica,12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 80, 450, 100));

    PdfPage page = document.pages[0];
    Size clientSize = page.getClientSize();
    page.graphics.drawString(
        "Location : "+Info.locationu, PdfStandardFont(PdfFontFamily.helvetica,12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        //bounds: Rect.fromLTWH(0, 0, 450, 180));
        bounds: Rect.fromLTWH( 0,100,450,120));
    // page.graphics.drawString(
    //     'SMS sent to Numbers : '+"\n", PdfStandardFont(PdfFontFamily.helvetica,20),
    //     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    //     bounds: Rect.fromLTWH(0, 50, 450, 250));
    double temp=200;
    for(int i=0;i<emer.length;i++) {
      page.graphics.drawString(
          'SMS sent to : '+emer[i].toString(), PdfStandardFont(PdfFontFamily.helvetica,12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds:  Rect.fromLTWH(0, temp,450, 250));
      temp+=50;
    }

    for(int i=0;i<emails.length;i++) {
      page.graphics.drawString(
          "Email sent to : "+ emails[i].toString(), PdfStandardFont(PdfFontFamily.helvetica,12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds:  Rect.fromLTWH(0, temp, 450, 250));
      temp+=50;
    }
  
    List<int> bytes = document.save();
    document.dispose();
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/Oukli1.pdf');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/Oukli1.pdf');
  

  }

  Widget _backCam(){
      return Container(
        margin: EdgeInsets.only(bottom: 20, right: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(width: 10, color: Colors.black),
                  ),
                  // margin: EdgeInsets.only(bottom: 30),
                  child:Square(),
                ),
              ),
            ),
            // Square(),
          ],
        ),
      );
  }

  Widget Square(){
    return AspectRatio(
        aspectRatio: _cam2.value.aspectRatio,
        child: CameraPreview(_cam2));
  }
  Widget _buildImage() {
    var size = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints.expand(),
      color: Colors.orange[200],

      child: _camera == null
          ? Center(
        child: Text(
          'Initializing Camera...',
          style: TextStyle(
            color: Colors.red,
            fontSize: 30.0,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
        fit: StackFit.expand,
          children: [
            //_backCam(),
            CameraPreview(_camera),
            //CameraPreview(cam2),
            //_backCam(),
            //CameraPreview(_cameraController),
            _buildResults(),
            //_backCam(),
            //_b(),
            // Text(face)
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }
  void _toggleCameraDirection() async {
    _direction = CameraLensDirection.front;

    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    }
    await _recordVideo();
    await _camera.stopImageStream();
    await _camera.dispose();
    await _cameraController.dispose();
    setState(() {
      _camera = null;
      _cameraController=null;
    });
    _initializeCamera();
    _initCamera();
  }
  @override
  Widget build(BuildContext context) {

      //Provider.of<LocationProvider>(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Driver Assistant',
          ),

        ),
        drawer: MyDrawer(),
        body: _buildImage(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 500,
            ),
            // FloatingActionButton(
            //   onPressed: _toggleCameraDirection,
            //   child: _direction == CameraLensDirection.front
            //       ? Icon(Icons.camera_front)
            //       : Icon(Icons.camera_front),
            // ),

            ElevatedButton(
              child: Text("Start Detection"),
              onPressed: ()  {
                tempr=1;
                //_recordVideo1();
                print("detection startedddddd");
                print(tempr);

              },
            ),

            ElevatedButton(
              child: Text("Stop Detection"),
              onPressed: () {
                tempr=0;
                // await _recordVideo1();
                // await dispose();
              },
            ),
            // SizedBox(height: 10,),
            // FloatingActionButton(
            //   backgroundColor: Colors.blueAccent,
            //   child: Icon(Icons.circle),
            //   onPressed: () => _recordVideo(),
            // ),
            SizedBox(height: 10,),
            FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.stop),
              onPressed: () =>
                  _recordVideo1(),
            ),
          ],
        ),
      );
  }

  @override
  void dispose() async {
    // _cameraController.dispose();
    // _camera.dispose().then((_) {
    //   _faceDetector.close();
    // });
    // _recordVideo();
    await _camera.stopImageStream();
    _camera.dispose().then((_) {
      _faceDetector.close();
    });
    _cameraController.dispose();
    setState(() {
      _camera = null;
      _cameraController=null;
    });
    _initializeCamera();
    _initCamera();
    super.dispose();
  }
  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Recording Started'),
      ),
    );
  }
  _showDialog1(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar:AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            brightness: Brightness.light,
            title: Text(
              'Accident Detected',
              style: TextStyle(fontSize: 50.0,color:Colors.white,),
            ),
            //   backgroundColor: Colors.transparent,
          ),
          body:Container(
            decoration:BoxDecoration(
              /*  image: DecorationImage(
               image: ExactAssetImage('Images/Cover2.jpg'),
                fit: BoxFit.fill,
              ),*/
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child:AlertDialog(
                    title: Text('Alert',style: TextStyle(

                        fontSize: 23,
                        color: Colors.black),),
                    content:  Text('Accident Detected',style: TextStyle(

                        fontSize: 18,
                        color: Colors.black),),
                    actions:
                    <Widget>[
                      Center(
                        child: RaisedButton(
                          splashColor: Colors.grey,
                          elevation: 20.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          highlightElevation: 20.0,
                          highlightColor: Colors.white,
                          child: Text(
                            'Turn OFF',
                            style: TextStyle(

                                fontSize: 15,
                                color: Colors.black),
                          ),
                          color: Colors.blue[600],
                          onPressed: () async {
                            FlutterRingtonePlayer.stop();
                            km=true;
                            if(_isRecording){
                              await _recordVideo1();
                            }
                            //dispose();
                            print("Stopped");
                            Navigator.pop(context);
                            generatefile();

                            //assetsAudioPlayer.stop();
                            Navigator.push(context,MaterialPageRoute(
                              builder: (context) =>CameraPreviewScanner(),
                            ),);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar:AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            brightness: Brightness.light,
            title: Text(
              'Drowiseness Alert',
              style: TextStyle(fontSize: 50.0,color:Colors.white,),
            ),
            //   backgroundColor: Colors.transparent,
          ),
          body:Container(
            decoration:BoxDecoration(
              /*  image: DecorationImage(
               image: ExactAssetImage('Images/Cover2.jpg'),
                fit: BoxFit.fill,
              ),*/
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child:AlertDialog(
                    title: Text('Alert',style: TextStyle(

                        fontSize: 23,
                        color: Colors.black),),
                    content:  Text('Drowsiness Detected',style: TextStyle(

                        fontSize: 18,
                        color: Colors.black),),
                    actions:
                    <Widget>[
                      Center(
                        child: RaisedButton(
                          splashColor: Colors.grey,
                          elevation: 20.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          highlightElevation: 20.0,
                          highlightColor: Colors.white,
                          child: Text(
                            'Turn OFF',
                            style: TextStyle(

                                fontSize: 15,
                                color: Colors.black),
                          ),
                          color: Colors.blue[600],
                          onPressed: () async {
                            FlutterRingtonePlayer.stop();
                            km=true;
                            if(_isRecording){
                              await _recordVideo1();
                            }
                            //dispose();
                            print("Stopped");
                            Navigator.pop(context);

                            //assetsAudioPlayer.stop();
                            // Navigator.push(context,MaterialPageRoute(
                            //   builder: (context) =>CameraPreviewScanner(),
                            // ),);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
