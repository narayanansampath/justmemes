import 'package:admob_flutter/admob_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:just_memes/BLoC/bloc.dart';
import 'package:just_memes/constants/admob_id.dart';
import 'package:just_memes/screens/AboutScreen/about_screen.dart';
import 'package:just_memes/screens/HomeScreen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

// ignore: must_be_immutable
class FavouriteScreen extends StatefulWidget {

  List<String> favList = [];

  FavouriteScreen(this.favList);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  MemesBloc memesBloc;
  bool isLiked = false;
  int indx;
  List<String> favItems = [];
  List<String> removedItems = [];
  //ExtendedImageMode _gestureController = ExtendedImageMode.none;

  @override
  void initState() {
    super.initState();
    indx = 0;
    initList();
    memesBloc = MemesBloc();
  }

  initList() async {
    favItems = await prepareFavouriteList(widget.favList);
    setState(() { });
    print('favITems:'+favItems.toString());
  }

  @override
  Widget build(BuildContext context) {
    //List<String> favList = (favItems.isEmpty) ? widget.favList.toSet().toList() : favItems.toSet().toList();
    print('favITemsinsideBuild:'+favItems.toString());
    _updateToSharedPreference(favItems);
    return new WillPopScope(
      // ignore: missing_return
      onWillPop:  () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    HomeScreen()));
      },
      child: new Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          //automaticallyImplyLeading: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        HomeScreen()));
          }),
          centerTitle: true,
          title: Text(
            'Favourites',
            style:
                TextStyle(color: Colors.black, fontFamily: 'GothamRoundedMedium'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.info_outline,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AboutScreen()));
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: favItems.length == 0 ? noMemesView() : _buildListView(favItems),
      ),
    );
  }

  Widget _buildListView(List<String> favList) {
    final int size = favList.length;

    List<Widget> _children = List<Widget>.generate(
      size,
          (int index) => _buildListItem(favList[index]),
    );

    _children.insert(
      1,
      Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
          child: ClipRRect(// rounded corners ad.
            borderRadius: BorderRadius.circular(20.0),
            child: AdmobBanner(
              adUnitId: 'ca-app-pub-9136064500060352/3882611943',
              adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
            ),
          ),
        ),
      ),
    );

    return ListView(
      children: _children,
    );
  }

  Widget _buildListItem(String meme) {
    return Dismissible(
        key: Key(meme),
    background: Container(
      padding: EdgeInsets.all(8.0),
          height: 345,
          child: Text(' Remove \n from \n favourites',style: TextStyle(
            fontSize: 18,
            fontFamily: 'GothamRoundedMedium',
          ),
          textAlign: TextAlign.start,),
          alignment: Alignment.centerLeft,
        ),
    secondaryBackground: Container(
      padding: EdgeInsets.all(8.0),
      height: 345,
      child: Text('Remove \n from \n favourites',style: TextStyle(
        fontSize: 18,
        fontFamily: 'GothamRoundedMedium',
      ),textAlign: TextAlign.end,),
      alignment: Alignment.centerRight,
    ),
    onDismissed: (direction) {
      Vibration.vibrate(duration: 15);
    setState(() {
    if(favItems.contains(meme)) {
    favItems.remove(meme);
    }
    });
    Scaffold
        .of(context)
        .showSnackBar(SnackBar(content: Text("Meme removed from favourites")));
    },
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Color(0xFFEAEAEA), borderRadius:  BorderRadius.all(Radius.circular(20.0)),),
      height: 350,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.white,
            child: Container(
              height: 291,
              width: MediaQuery.of(context).size.width,
              child: new ExtendedImage.network(
                meme,
                //mode: _gestureController,
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
                BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 0, 25.0, 0),
                child: Container(
                  child: IconButton(
                    icon: new Icon(
                      Icons.file_download,
                    ),
                    iconSize: 35,
                    padding: EdgeInsets.all(8),
                    onPressed: () {
                      memesBloc
                          .dispatch(DownloadImage(meme, context));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 0, 35.0, 0),
                child: IconButton(
                  icon: new Icon(
                    Icons.share,
                  ),
                  iconSize: 35,
                  padding: EdgeInsets.all(8),
                  onPressed: () =>
                      memesBloc.dispatch(ShareMeme(meme)),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  prepareFavouriteList(List<String> favList) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> finalList = [];
    List<String> favItems =  prefs.getStringList('favItems'); //json.decode( prefs.getString('favItems'));
      if(favItems!=null) {
        finalList = new List.from(favItems)
          ..addAll(favList);
        //favItems.addAll(favList);
        print('Fav List:' + favItems.toString());
        //var result = LinkedHashSet<String>.from(a).toList();
        print('Final List:' + finalList.toString());
        return finalList.toSet().toList();
      } else{
        finalList..addAll(favList);
        return finalList;
      }
  }

  void _updateToSharedPreference(List<String> favMemes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> finalList =
        (favItems.toSet().difference(removedItems.toSet())).toList();
    await prefs.setStringList('favItems', finalList);
  }

  @override
  void dispose() {
    super.dispose();
    // Don't forget to call dispose on the Bloc to close the Streams!
    memesBloc.dispose();
  }

  Widget noMemesView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            'No memes are added to favourites, add something from homepage.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'GothamRoundedMedium',
              fontSize: 22,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
            child: ClipRRect(// rounded corners ad.
              borderRadius: BorderRadius.circular(20.0),
              child: AdmobBanner(
                adUnitId: FavouriteScreenAdId,
                adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
