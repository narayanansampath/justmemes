import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:just_memes/data/rest_ds.dart';
import 'package:just_memes/model/meme_response.dart';
import 'package:just_memes/BLoC/bloc.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:flushbar/flushbar.dart';

class MemesBloc extends Bloc<MemesEvent, MemesState> {
  RestDatasource api = new RestDatasource();
  @override
  MemesState get initialState => InitialMemesState();

  @override
  Stream<MemesState> mapEventToState(
    MemesEvent event,
  ) async* {
   if (event is AddToFavourites){

   }

   if (event is OpenInBrowser) {
     launchCaller(event.postUrl);
   }

   if(event is GetMemes){
     yield MemeLoadingState();
     MemeResponse response = await api.fetchMemeFromApi();
     yield MemeLoaded(response);
   }

   if(event is ShareMeme){
     var request = await HttpClient().getUrl(Uri.parse(event.url));
     var response = await request.close();
     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
     await Share.file('awesomeMeme', 'awesomeMeme.jpg', bytes, 'image/jpg',text: 'Sent from JustMemes, download now for more awesome memes at: https://play.google.com/store/apps/details?id=com.ryan.just_memes');
   }

   if(event is DownloadImage) {
     if (await hasPermission()) {
       downloadImage(event);
     }
     else {
       bool requestStatus = await requestPermission(event);
       if(requestStatus){
         downloadImage(event);
       }
     }
   }
  }
  launchCaller(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<bool> saveNetworkImageToPhoto(String url, {bool useCache: true}) async {
    var data = await getNetworkImageData(url, useCache: useCache);
    var filePath = await ImagePickerSaver.saveFile(fileData: data);
    return filePath != null && filePath != "";
  }

  Future<bool> hasPermission() async {
    bool res = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    return res;
  }

  downloadImage(DownloadImage event) async {
    try {
      await saveNetworkImageToPhoto(event.url);
      Flushbar(
        message: "Image saved to gallery", duration: Duration(seconds: 3),)
        ..show(event.context);
    } catch (e) {
      Flushbar(
        message: "Failed to save image, please try again after some time",
        duration: Duration(seconds: 3),)
        ..show(event.context);
    }
  }

  Future<bool> requestPermission(DownloadImage event) async {
    PermissionStatus status = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    print(status.toString());
    if(status.toString().contains('denied')){
      Flushbar(
        message: "Storage permission is needed to save the image, please press allow",
        duration: Duration(seconds: 3),)
        ..show(event.context);
      return false;
    } else{
      return true;
    }
  }

}
