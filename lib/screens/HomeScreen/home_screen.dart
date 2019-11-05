import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:just_memes/BLoC/bloc.dart';
import 'package:just_memes/constants/admob_id.dart';
import 'package:just_memes/model/meme_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:just_memes/screens/AboutScreen/about_screen.dart';
import 'package:just_memes/screens/favourites/favourite_screen.dart';
import 'package:vibration/vibration.dart';

import 'admob_wrapper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MemesBloc memesBloc;
  MemeResponse memes;
  MaterialColor _color = Colors.grey;
  final FlareControls flareControls = FlareControls();
  bool isLiked = false;
  List<String> favList = [];
  int indx;

  @override
  void initState() {
    super.initState();
    memesBloc = MemesBloc();
    indx = 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'JustMemes',
          style:
              TextStyle(color: Colors.black, fontFamily: 'GothamRoundedMedium'),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AboutScreen()));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              addMemestoFavBeforeRefresh(memes).then(
                (_) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            FavouriteScreen(favList))),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: BlocListener(
          bloc: memesBloc,
          // Listener is the place for logging, showing Snackbars, navigating, etc.
          // It is guaranteed to run only once per state change.
          listener: (BuildContext context, MemesState state) {
            if (state is MemeLoaded) {
              print("Loaded: ${state.meme.toString()}");
            }
          },
          // BlocBuilder invokes the builder when new state is emitted.
          child: BlocBuilder(
            bloc: memesBloc,
            builder: (BuildContext context, MemesState state) {
              if (state is InitialMemesState) {
                return buildInitialMeme(context);
              } else if (state is MemeLoadingState) {
                return buildLoading();
              } else if (state is MemeLoaded) {
                return memeCards(state.meme);
              }
              return new Container();
            },
          ),
        ),
      ),
    );
  }

  Widget memeCards(MemeResponse meme) {
    memes = meme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onDoubleTap: () {
            Vibration.vibrate(pattern: [0, 10, 150, 15]);
            meme.memes[indx].isLiked = !meme.memes[indx].isLiked;
            print('favourite: $indx' + meme.memes[indx].isLiked.toString());
            flareControls.play("like");
            setState(() {
              _color = _color == Colors.grey ? Colors.red : Colors.grey;
            });
          },
          onLongPress: () {
            _menuModalBottomSheet(context, indx, meme);
          },
          child: Center(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: AdmobBannerWrapper(
                        adUnitId: HomescreenAdId,
                        adSize: AdmobBannerSize.BANNER,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      //height: MediaQuery.of(context).size.height * 0.69,
                      child: new Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            child: new ExtendedImage.network(
                              meme.memes[index].url,
                              enableLoadState: true,
                              //mode: ExtendedImageMode.gesture,
                              initGestureConfigHandler: (state) {
                                return GestureConfig(
                                    minScale: 0.9,
                                    animationMinScale: 0.7,
                                    maxScale: 3.0,
                                    animationMaxScale: 3.5,
                                    speed: 1.0,
                                    inertialSpeed: 100.0,
                                    initialScale: 1.0,
                                    inPageView: false);
                              },
                              fit: BoxFit.fill,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          );
                        },
                        itemCount: meme.memes.length,
                        itemWidth: MediaQuery.of(context).size.width * 0.9,
                        itemHeight: MediaQuery.of(context).size.width * 1.22,
                        layout: SwiperLayout.TINDER,
                        loop: true,
                        onIndexChanged: (int index) {
                          indx = index;
                          print(indx.toString());
                          if (meme.memes[index].isLiked) {
                            setState(() {
                              _color = Colors.red;
                            });
                          } else {
                            setState(() {
                              _color = Colors.grey;
                            });
                          }
                          if (index == 4) {
                            addMemestoFavBeforeRefresh(meme).then((_) => memesBloc.dispatch(GetMemes()));
                          }
                        },
                      )),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 250, 0, 0),
                  width: double.infinity,
                  //height: MediaQuery.of(context).size.height * 0.69,
                  child: Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: FlareActor(
                        'assets/like_animation.flr',
                        controller: flareControls,
                        color: Colors.red,
                        animation: 'idle',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(35.0, 0, 25.0, 20),
                  child: Container(
                    child: IconButton(
                      icon: new Icon(
                        Icons.list,
                      ),
                      iconSize: 45,
                      padding: EdgeInsets.all(8),
                      onPressed: () {
                        _menuModalBottomSheet(context, indx, meme);
                      },
                    ),
                  ),
                ),
                IconButton(
                    icon: new Icon(
                      Icons.favorite,
                      color: _color,
                    ),
                    //: new Icon(Icons.favorite_border),
                    iconSize: 90,
                    onPressed: () {
                      meme.memes[indx].isLiked = !meme.memes[indx].isLiked;
                      Vibration.vibrate(duration: 15);
                      print('favourite: $indx' +
                          meme.memes[indx].isLiked.toString());
                      flareControls.play("like");
                      setState(() {
                        _color =
                            _color == Colors.grey ? Colors.red : Colors.grey;
                      });
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 35.0, 20),
                  child: IconButton(
                    icon: new Icon(
                      Icons.share,
                    ),
                    iconSize: 45,
                    padding: EdgeInsets.all(8),
                    onPressed: () =>
                        memesBloc.dispatch(ShareMeme(meme.memes[indx].url)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
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

  buildInitialMeme(BuildContext context) {
    memesBloc.dispatch(GetMemes());
  }

  void _menuModalBottomSheet(context, int index, MemeResponse meme) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Container(
                  child: new ListTile(
                      leading: new Icon(Icons.subject),
                      title: new Text(
                        'Subreddit name: ' + meme.memes[index].subreddit,
                        style: TextStyle(
                          fontFamily: 'GothamRoundedMedium',
                        ),
                      )),
                  decoration: BoxDecoration(
                    color: Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                ),
                Container(
                  color: Color(0xFFEAEAEA),
                  child: new ListTile(
                      leading: new Icon(Icons.title),
                      title: new Text(
                        'Title: ' + meme.memes[index].title,
                        style: TextStyle(
                          fontFamily: 'GothamRoundedMedium',
                        ),
                      )),
                ),
                new ListTile(
                    leading: new Icon(Icons.open_in_browser),
                    title: new Text(
                      'Open post in browser',
                      style: TextStyle(
                        fontFamily: 'GothamRoundedLight',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      memesBloc
                          .dispatch(OpenInBrowser(meme.memes[index].postLink));
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.file_download),
                    title: new Text(
                      'Download this awesome meme',
                      style: TextStyle(
                        fontFamily: 'GothamRoundedLight',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      memesBloc.dispatch(
                          DownloadImage(meme.memes[index].url, context));
                      Navigator.pop(context);
                    }),
                new ListTile(
                    leading: new Icon(Icons.refresh),
                    title: new Text(
                      'Refresh memes',
                      style: TextStyle(
                        fontFamily: 'GothamRoundedLight',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      addMemestoFavBeforeRefresh(meme).then((_) => memesBloc.dispatch(GetMemes()));
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });
  }

  Future addMemestoFavBeforeRefresh(MemeResponse meme) async {
    if (meme != null) {
      if (meme.memes.length > 0) {
        for (int i = 0; i < meme.memes.length; i++) {
          if (meme.memes[i].isLiked) {
            favList.add(meme.memes[i].url);
          }
        }
      }
      print('added to favList:' + favList.toString());
    }
  }
}
