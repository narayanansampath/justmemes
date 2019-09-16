import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:just_memes/data/rest_ds.dart';
import 'package:just_memes/model/meme_response.dart';
import 'package:just_memes/BLoC/bloc.dart';

class MemesBloc extends Bloc<MemesEvent, MemesState> {
  RestDatasource api = new RestDatasource();
  @override
  MemesState get initialState => InitialMemesState();

  @override
  Stream<MemesState> mapEventToState(
    MemesEvent event,
  ) async* {
   if (event is SaveMemes) {

   }

   if(event is GetMemes){
     yield MemeLoadingState();
     MemeResponse response = await api.fetchMemeFromApi();
     yield MemeLoaded(response);
   }
  }
}
