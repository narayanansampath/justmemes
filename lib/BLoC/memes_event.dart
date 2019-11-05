import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MemesEvent extends Equatable {
  MemesEvent([List props = const <dynamic>[]]) : super(props);
}

class AddToFavourites extends MemesEvent {

  final String url;
  AddToFavourites(this.url) : super([url]);
}

class GetMemes extends MemesEvent {

}

class OpenInBrowser extends MemesEvent {
  final String postUrl;
  OpenInBrowser(this.postUrl) : super([postUrl]);
}

class DownloadImage extends MemesEvent {
  final String url;
  BuildContext context;
  DownloadImage(this.url,this.context) : super([url,context]);
}

class ShareMeme extends MemesEvent {

  final String url;
  ShareMeme(this.url) : super([url]);
}