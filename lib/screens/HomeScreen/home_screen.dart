import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:just_memes/BLoC/memes_bloc.dart';
import 'package:just_memes/BLoC/memes_event.dart';
import 'package:just_memes/BLoC/memes_state.dart';
import 'package:just_memes/model/meme_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final memesBloc = MemesBloc();

  List<String> welcomeImages = [
    "assets/space.jpg",
    "assets/space.jpg",
    "assets/space.jpg",
    "assets/space.jpg",
    "assets/space.jpg",
    "assets/space.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    CardController controller; //Use this to trigger swap.

    return new Scaffold(
      body: Container(
        child: BlocListener(
        bloc: memesBloc,
        // Listener is the place for logging, showing Snackbars, navigating, etc.
        // It is guaranteed to run only once per state change.
        listener: (BuildContext context, MemesState state) {
      if (state is MemeLoaded) {
        print("Loaded: ${state.meme.url}");
      }
    },
    // BlocBuilder invokes the builder when new state is emitted.
        child: BlocBuilder(
          bloc: memesBloc,
          // ignore: missing_return
          builder: (BuildContext context, MemesState state) {
            if (state is InitialMemesState) {
              return buildInitialMeme(context);
            } else if (state is MemeLoadingState) {
              return buildLoading();
            } else if (state is MemeLoaded) {
              return memeCards(controller, state.meme);
            }
          },
        ),
        ),
      ),
    );
  }

  Widget memeCards(CardController controller, MemeResponse meme) {
    return new Center(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.73,
            child: new TinderSwapCard(
                orientation: AmassOrientation.BOTTOM,
                totalNum: 6,
                stackNum: 3,
                swipeEdge: 4.0,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.width * 1.3,
                minWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: MediaQuery.of(context).size.width * 0.9,
                cardBuilder: (context, index) => Card(
                      child: Image.network(meme.url),
                    ),
                cardController: controller = controller,
                swipeUpdateCallback:
                    (DragUpdateDetails details, Alignment align) {
                  if (align.x < 0) {
                    //Card is LEFT swiping
                  } else if (align.x > 0) {
                    //Card is RIGHT swiping
                  }
                },
                swipeCompleteCallback:
                    (CardSwipeOrientation orientation, int index) {
                  print(orientation.toString());
                  memesBloc.dispatch(GetMemes());
                })));
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Don't forget to call dispose on the Bloc to close the Streams!
    memesBloc.dispose();
  }

  Widget buildInitialMeme(BuildContext context) {
    memesBloc.dispatch(GetMemes());
  }

}
