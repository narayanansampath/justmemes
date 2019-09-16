import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MemesEvent extends Equatable {
  MemesEvent([List props = const <dynamic>[]]) : super(props);
}

class SaveMemes extends MemesEvent {

  final String swipeOrientation;
  SaveMemes(this.swipeOrientation) : super([swipeOrientation]);
}

class GetMemes extends MemesEvent {

}