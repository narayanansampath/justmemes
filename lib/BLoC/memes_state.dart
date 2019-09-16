import 'package:equatable/equatable.dart';
import 'package:just_memes/model/meme_response.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MemesState extends Equatable {
  MemesState([List props = const <dynamic>[]]) : super(props);
}

class InitialMemesState extends MemesState {}

class MemeLoadingState extends MemesState {}

class MemeLoaded extends MemesState {
  final MemeResponse meme;

  MemeLoaded(this.meme) : super([meme]);
}
