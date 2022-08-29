import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class UploadRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Future<UploadTask?> upload(String filePath,File out) async {

    String fileName = basename(filePath);
    try{
      Reference ref =  await _firebaseStorage.ref().child(fileName);
      return  ref.putFile(out);
    }on FirebaseException catch(e){
      return null;
    }

    // var client = Dio();
    // FormData data = FormData.fromMap({
    //   'photo': await MultipartFile.fromFile(filePath),
    // });
    //
    //
    // Response response = await client.post(
    //   '', // Urls.UPLOAD_API,
    //   data: data,
    // );
    //
    // if (response == null) {
    //   return null;
    // }
    // print(response.data);
    // return response.data;
  }
}
