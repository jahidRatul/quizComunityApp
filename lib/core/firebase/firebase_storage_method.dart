import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

// ignore: camel_case_types
class FireBaseFileStorage {
  FirebaseStorage storage;

  static Future<String> uploadImage({
    File imageFile,
    String dirName,
  }) async {
    try {
      if (imageFile == null) return null;
      var fileName = imageFile?.path?.split("/")?.last;
      print(fileName);
      var path = "$dirName/$fileName";
      Reference ref = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask;

      //  var dowUrl = await (await uploadTask.onComplete)?.ref?.getDownloadURL();
      String dowUrl = await uploadTask.snapshot?.ref?.getDownloadURL();

      String url = dowUrl?.toString();
      print("Image upload ------------------>>>>>>>");
      print(url);

      return url;
    } catch (e, t) {
      print("Image upload ERROR ;;;;------------------>>>>>>>");
      print(e);
      print(t);
    }
    return null;
  }

  static Future<void> deleteFile(String fullUrl) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(fullUrl);
      await ref.delete();
      return;
    } catch (e) {}
  }
}
