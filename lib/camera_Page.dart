import 'dart:io';
import 'package:camera/camera.dart';
import 'package:driverassistant/video_page.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:path_provider/path_provider.dart';



class CameraPage extends StatefulWidget {
  const CameraPage({Key key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  bool loading = false;
  double progress = 0;
  String _VideoFile;

  CameraController _cameraController;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }


  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
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
      GallerySaver.saveVideo(_VideoFile);
      print("gallery saver");

      String newdate=date.substring(1,date.length-1);
      print(newdate);
      await File(newdate).copy('/storage/emulated/0/DCIM/Camera/'+a+'.mp4');
   //   await File(date).copySync('/storage/emulated/0/DCIM/Camera/'+a+'.mp4');

      print("saving test");




      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }

  }

  @override
  Widget build(BuildContext context) {
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
}