import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:critical_x_quiz/core/tools/flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shape_of_view/shape_of_view.dart';

/*
flutter_native_image: ^0.0.5
image_picker: ^0.6.7+4
flutter_responsive_screen: ^1.0.0

 */

/// android set up
/*<manifest ... >
<!-- This attribute is "false" by default on apps targeting
     Android 10 or higher. -->
  <application android:requestLegacyExternalStorage="true" ... >
    ...
  </application>
</manifest>
*/

/// iso :: <project root>/ios/Runner/Info.plist
/*
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to the photo library.</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app does not require access to the microphone.</string>
<key>NSCameraUsageDescription</key>
<string>This app requires access to the camera.</string>
*/

class FlutterImagePicker {
  static final ImagePicker _picker = ImagePicker();

  static Future<File> compressImage(File imageFile) async {
    if (imageFile == null) return null;
    File image;
    try {
      image = await FlutterNativeImage.compressImage(imageFile.path,
          quality: 80, percentage: 80);
    } catch (e) {
      // L.log(e);
    }
    return image ?? null;
  }

  static Future retrieveLostData() async {
    // ignore: deprecated_member_use
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.image) {
        return (response.file);
      }
    } else {
      // print((response.exception));
    }
    return;
  }

  static Future<File> getImageGallery(context, {bool compress = true}) async {
    // ignore: deprecated_member_use
    File _image;
    /* File _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);*/

    try {
      PickedFile f = await _picker.getImage(
        source: ImageSource.gallery,
      );
      if (f != null) {
        _image = File(f.path);
      }
    } catch (e) {
      FlutterToast.showErrorToast(
          context: context, message: "Failed to load image");
      Navigator.of(context).pop();
      return null;
    }

    File temp;
    try {
      temp = await retrieveLostData();
      if (temp != null) _image = temp;
    } catch (e) {
      print(e);
    }

    if (compress == true) {
      try {
        File _tempImage = await compressImage(_image);
        Navigator.of(context).pop();
        return _tempImage;
      } catch (e) {
        Navigator.of(context).pop();
        return _image;
      }
    }
    Navigator.of(context).pop();
    return _image;
  }

  static Future<File> getImageCamera(context, {bool compress = true}) async {
    // ignore: deprecated_member_use
    File _image;
    try {
      /* _image = await ImagePicker.pickImage(
          */ /*maxWidth: 100,
        maxHeight: 100,*/ /*
          source: ImageSource.camera,
          imageQuality: 100);*/

      PickedFile f = await _picker.getImage(
        source: ImageSource.camera,
      );
      if (f != null) {
        _image = File(f.path);
      }
    } catch (e) {
      FlutterToast.showErrorToast(
          context: context, message: "Failed to load image");
      Navigator.of(context).pop();
      return null;
    }
    File temp;
    try {
      temp = await retrieveLostData();
      if (temp != null) _image = temp;
    } catch (e) {
      print(e);
    }

    if (compress == true) {
      try {
        File _tempImage = await compressImage(_image);
        Navigator.of(context).pop();
        return _tempImage;
      } catch (e) {
        Navigator.of(context).pop();
        return _image;
      }
    }
    Navigator.of(context).pop();
    return _image;
  }

  static void imagePickerModalSheet({BuildContext context, Function fromGallery, Function fromCamera}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (builder) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          maxChildSize: 1,
          minChildSize: 0.3,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    // pick from Gallery
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'CHOOSE FOR ACTION',
                          // ignore: deprecated_member_use
                          style: Theme.of(context).textTheme.body1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),

                    Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            children: <Widget>[
                              InkWell(
                                onTap: fromGallery,
                                child: Container(
                                  decoration:
                                  BoxDecoration(shape: BoxShape.circle),
                                  child: Material(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(22.0)),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: MemoryImage(
                                              SupportImage.getGallery()),
                                          /*AssetImage(
                                                  "assets/images/galery.png"),*/
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Gallery',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Column(
                            children: <Widget>[
                              InkWell(
                                onTap: fromCamera,
                                child: Container(
                                  decoration:
                                  BoxDecoration(shape: BoxShape.circle),
                                  child: Material(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(22.0)),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: MemoryImage(
                                                SupportImage.getCamera()),
                                            /* AssetImage(
                                                "assets/images/camera.png"),*/
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
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
      },
    );
  }

  static Future<File> getCustomCamera(BuildContext context, bool square) async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    File image = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
              camera: firstCamera,
              square: square,
            )));

    Navigator.pop(context);

    return image;
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  final bool square;

  const TakePictureScreen({
    Key key,
    @required this.camera,
    this.square = false,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;

  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;

    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ShapeOfView(
                        shape: RoundRectShape(
                          borderRadius: BorderRadius.circular(0),
                          borderColor: Colors.white, //optional
                          borderWidth: 0, //optional
                        ),
                        child: Container(
                          height: 100,
                          width: 100,
                          child: CameraPreview(_controller),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Container(
                          height: widget.square
                              ? hp(100) -
                                  (getHeightForSquare(hp(100), wp(80)) * 2.0)
                              : wp(60).roundToDouble(),
                          width: wp(80).roundToDouble(),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            File f = File(path);
            File croppedFile = await croppedImage(
              f,
              height: widget.square
                  ? (hp(100) - (getHeightForSquare(hp(100), wp(80)) * 2.0))
                      .round()
                  : hp(50).round(),
              width: wp(99).round(),
              x: widget.square
                  ? getHeightForSquare(hp(100), wp(80)).round()
                  : hp(30).round(),
              y: widget.square ? wp(10).round() : wp(10).round(),
            );

            Navigator.pop(context, croppedFile);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }

  double getHeightForSquare(double height, double width) {
    return (height - width) / 2.0;
  }

  Future<File> croppedImage(File imagePath,
      {int x, int y, int height, int width}) async {
    File croppedFile = await FlutterNativeImage.cropImage(
      imagePath.path,
      x.toInt(),
      y.toInt(),
      height?.toInt(),
      width?.toInt(),
    );

    return croppedFile;
  }
}

class SupportImage {
  static String _galleryBase64 =
      'data:image/png;base64,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';
  static String _cameraBase64 =
      'data:image/png;base64,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';

  static Uint8List getCamera() {
    return base64.decode(_cameraBase64.split(',').last);
  }

  static Uint8List getGallery() {
    return base64.decode(_galleryBase64.split(',').last);
  }
}
