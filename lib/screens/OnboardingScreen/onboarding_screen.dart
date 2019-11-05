import 'package:flutter/material.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:just_memes/screens/HomeScreen/home_screen.dart';


class OnBoardingScreen extends StatelessWidget {

  final pageList = [
    PageModel(
        color: const Color(0xFF678FB4),
        heroAssetPath: 'assets/icon4x.png',
        title: Text('Welcome',
            style: TextStyle(
              fontFamily: 'GothamRoundedMedium',
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Hi there, thanks for installing this awesome app. Let's get started, swipe next for instructions.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'GothamRoundedLight',
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 18.0,
              )),
        ),
        iconAssetPath: 'assets/icons/welcome-emoji.png'),
    PageModel(
        color: const Color(0xFF7986CB),
        heroAssetPath: 'assets/swipe.png',
        title: Text('Swipe right for next meme',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'GothamRoundedMedium',
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Swipe the card to right for next meme and left for the previous meme.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
        ),
        iconAssetPath: 'assets/icons/swipe-icon.png'),
    PageModel(
        color: const Color(0xFF65B0B4),
        heroAssetPath: 'assets/doubletap.png',
        title: Text('Double tap to like',
            style: TextStyle(
              fontFamily: 'GothamRoundedMedium',
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'Double tap on a meme to like and add it to favourites, you can also tap the heart present below the card.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
        ),
        iconAssetPath: 'assets/icons/doubletap.png'),
    PageModel(
        color: const Color(0xFFFFAB91),
        heroAssetPath: 'assets/navigate.png',
        title: Text('Navigate to favourite screen',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'GothamRoundedMedium',
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'Click on the heart icon located in the top right of the app to see your liked and favourite memes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
        ),
        iconAssetPath: 'assets/icons/hearticon.png'),
    PageModel(
        color: const Color(0xFF9575CD),
        heroAssetPath: 'assets/removefav.png',
        title: Text('Swipe to remove from favourites',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'GothamRoundedMedium',
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'You can swipe left or right to remove the meme from favourites.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              )),
        ),
        iconAssetPath: 'assets/icons/removefav-icon.png'),
    PageModel(
      color: const Color(0xFF9B90BC),
      heroAssetPath: 'assets/icons/shareicon.png',
      title: Text('Share the meme',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'GothamRoundedMedium',
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Share your favourite meme with your friends through various social media options and spread the smile :) \n\n Now we are ready, you can come back to this screen by tapping on "How to use the app option" from about section of the app.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
      ),
      iconAssetPath: 'assets/icons/shareicon.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: () =>
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        HomeScreen())),
    onSkipButtonPressed: () =>
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                HomeScreen())),
    ),
    );
  }
}
