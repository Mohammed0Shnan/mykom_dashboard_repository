import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/enum/image_type.dart';
import 'package:my_kom_dist_dashboard/module_upload/repository/upload_repository.dart';


class ImageUploadService {
  final UploadRepository _uploadRepository = UploadRepository();

  Future<String?> uploadImage(FilePickerResult file,ImageType imageType) async {

    try {

      /// This Section

      String fileName = '';
      if(imageType == ImageType.PRODUCT){
        fileName = 'products/';
      }else if(imageType == ImageType.COMPANY){
        fileName = 'companies/';
      }else if(imageType == ImageType.ADVERTISEMENT){
        fileName = 'advertisements/';
      }
      TaskSnapshot upload = await FirebaseStorage.instance
          .ref().child('$fileName${file.files.first.name} - ${DateTime.now().toIso8601String()}.${file.files.first.extension}')
          .putData(
        file.files.first.bytes!,
        SettableMetadata(contentType: 'image/${file.files.first.extension}'),
      );

      String url = await upload.ref.getDownloadURL();
      print('000000000000000000000');
      print(url);
      return url;
    } catch (e) {
      print('error in uploading image for : ${e.toString()}');
      return null;
    }


  }
  // Future<String?> uploadImage(String filePath) async {
  //   File out = File(filePath);//await ImageCompression.compressAndGetFile(file: File(filePath));
  //    UploadTask? task = await  _uploadRepository.upload(filePath , out);
  //    if(task == null){
  //      return null;
  //    }
  //    else
  //      {
  //        final snapshot = await task.whenComplete(() {});
  //        final urlDownload = await snapshot.ref.getDownloadURL();
  //        return urlDownload;
  //      }
  // }

  Future getImageFromGallery(ImageSource imageSource) async {
    String? _path;
    try {
      var pickedImage = await ImagePicker().pickImage(source: imageSource);
      _path = pickedImage!.path;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    String file = _path != null ? _path : '';
    return file; //await cropImage(file);
  }

  Future cropImage(String image) async {

    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: image,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedFile!.path;
  }
}
