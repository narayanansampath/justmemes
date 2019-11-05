import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:just_memes/constants/admob_id.dart';
import 'package:just_memes/screens/OnboardingScreen/onboarding_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:vibration/vibration.dart';

class AboutScreen extends StatefulWidget {

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  BuildContext _ctx;

  String _appVersionNumber = '';

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'About',
          style:
              TextStyle(color: Colors.black, fontFamily: 'GothamRoundedMedium'),
        ),
        elevation: 0,
      ),
      body: _aboutBody(),
    );
  }

  Widget _aboutBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0,20,0,20),
            child: ListTile(
              leading: Icon(
                Icons.mail_outline,
                color: Colors.black,
                size: 45,
              ),
              title: Text(
                'Contact the developer',
                style: TextStyle(
                  fontFamily: 'GothamRoundedMedium',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                launchCaller('mailto:sampathnarayanan72@gmail.com');
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0,20,0,20),
            child: ListTile(
              leading: Icon(
                Icons.share,
                size: 45,
                color: Colors.black,
              ),
              title: Text(
                'Share this awesome app',
                style: TextStyle(
                  fontFamily: 'GothamRoundedMedium',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Share.text(
                    'Share Just Memes',
                    'Hey there, checkout this awesome app JustMemes and enjoy unlimited memes. To download click on: https://play.google.com/store/apps/details?id=com.ryan.just_memes',
                    'text/plain');
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0,20,0,20),
            child: ListTile(
              leading: Icon(
                Icons.star,
                size: 45,
                color: Colors.black,
              ),
              title: Text(
                'Rate the app',
                style: TextStyle(
                  fontFamily: 'GothamRoundedMedium',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                launchCaller("market://details?id=com.ryan.just_memes");
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0,20,0,20),
            child: ListTile(
              leading: Icon(
                Icons.slideshow,
                size: 45,
                color: Colors.black,
              ),
              title: Text(
                'How to use the app',
                style: TextStyle(
                  fontFamily: 'GothamRoundedMedium',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                    _ctx,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            OnBoardingScreen()));
              },
            ),
          ),
          ExpansionTile(
            title: Container(
              margin: EdgeInsets.fromLTRB(0, 20, 8, 0),
              child: Text(
                'Why Ads',
                style: TextStyle(
                  fontFamily: 'GothamRoundedMedium',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            leading: Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Icon(
                  Icons.attach_money,
                  color: Colors.black,
                  size: 45,
                )),
            trailing: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            children: <Widget>[
              Container(
                constraints: BoxConstraints(minHeight: 30),
                alignment: Alignment.topLeft,
                child: Text(
                  'Ads helps me to afford the support costs and bring more new features to the app faster. It does not cost the users anything but helps the developer to keep the project alive. Thanks for using the app 😊.',
                  style: TextStyle(
                    fontFamily: 'GothamRoundedLight',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                margin: EdgeInsets.fromLTRB(15, 15, 0, 8),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
              child: ClipRRect(
                // rounded corners ad.
                borderRadius: BorderRadius.circular(20.0),
                child: AdmobBanner(
                  adUnitId: AboutScreenAdId,
                  adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.all(10),
            child: Text('App version: '+_appVersionNumber,style: TextStyle(
                fontFamily: 'GothamRoundedLight',
                fontSize: 15,
                letterSpacing: 0.8
            ),textAlign: TextAlign.center,),
          ),
          InkWell(
            onTap: (){
              Vibration.vibrate(pattern: [0, 10, 150, 15]);
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(10),
              child: Text('Made with ❤️ and ☕ in INDIA',style: TextStyle(
                fontFamily: 'GothamRoundedLight',
                fontSize: 15,
                letterSpacing: 0.8
              ),textAlign: TextAlign.center,),
            ),
          )
        ],
      ),
    );
  }

  launchCaller(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getAppVersion() async {
    String version =  await getPackageVersion();
    setState(() {
      _appVersionNumber = version;
    });

  }

  getPackageVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }
}
