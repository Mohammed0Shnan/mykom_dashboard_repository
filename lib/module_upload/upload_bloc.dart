import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/enum/image_type.dart';
import 'package:my_kom_dist_dashboard/module_upload/service/image_upload_service.dart';

class UploadBloc extends Bloc<UploadEvent, UploadStates> {
  final ImageUploadService _service = ImageUploadService();


  UploadBloc() : super(UploadInitState()) {

    on<UploadEvent>((UploadEvent event, Emitter<UploadStates> emit) {
      if (event is UploadLoadingEvent)
        emit(UploadLoadingState());
      else if (event is UploadErrorEvent){
        emit(UploadErrorState());
      }
      else if (event is UploadSuccessEvent){
        emit(UploadSuccessState( event.image));}
      else{
        emit(UploadInitState());

      }
      // else if(event is UpdateProductsCompanySuccessEvent){
      //   _update(event,emit);
      // }
    });

    // streamSubscription = shopBloc.stream.listen((event) {
    //  _update1();
    // });

  }



 // Future<void> upload(String file_path) async {
 //    this.add(UploadLoadingEvent());
 //   await _service.uploadImage(file_path).then((value) {
 //      if (value != null) {
 //        this.add(UploadSuccessEvent(value));
 //      } else
 //        this.add(UploadErrorEvent());
 //    });
 //  }


  Future<void> upload(FilePickerResult res,ImageType imageType) async {
    this.add(UploadLoadingEvent());
    await _service.uploadImage(res,imageType).then((value) {
      if (value != null) {
        this.add(UploadSuccessEvent(value));
      } else
        this.add(UploadErrorEvent());
    });
  }

  initState(){
    add(UploadInitEvent());
  }


}



abstract class UploadEvent {}

class UploadInitEvent extends UploadEvent {}

class UploadSuccessEvent extends UploadEvent {
  String image;
  UploadSuccessEvent(this.image);
}

class UploadLoadingEvent extends UploadEvent {}

class UploadErrorEvent extends UploadEvent {}

abstract class UploadStates {}

class UploadInitState extends UploadStates {}

class UploadSuccessState extends UploadStates {
    String image;
  UploadSuccessState(this.image);
}

class UploadLoadingState extends UploadStates {}

class UploadErrorState extends UploadStates {}
