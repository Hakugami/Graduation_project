import 'package:flutter/material.dart';
import 'package:object_detection/layouts/home_screen/home_screen.dart';
import 'package:object_detection/shared/constants.dart';
import 'package:object_detection/shared/styles/colors.dart';
import 'package:object_detection/strings/strings.dart';

class SplachScreen extends StatefulWidget {
  @override
  _SplachScreenState createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  @override
  void initState() {
    // TODO: implement initState
    _speak();

    super.initState();
  }

  _speak() async {

    ttsOffline("Welcome in blind assistant app", "en-US"); //what is this function ?
    await Future.delayed(Duration(seconds: 1));
    ttsOffline("This app is voice controlled",  "en-US");
    await Future.delayed(Duration(seconds: 1));
    _takeFavLangFromUser();
  }

  _takeFavLangFromUser() async {
    ttsOffline(
        "Please choose app language, say one for english or two for arabic",
        "en-US");
    // await sttFlutter("en-US");
    // if (lastWords.toLowerCase() == "two") {
    //   appLang = AR;
    //   navigateAndFinish(context, HomeScreen());
    // } else if (lastWords.toLowerCase() == "one") {
    //   appLang = ENG;
    //   navigateAndFinish(context, HomeScreen());
    // }
   /* if (lastWords.isEmpty) {
      await Future.delayed(Duration(milliseconds: 1000));
      _takeFavLangFromUser();
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WHITE_COLOR,
      ),
      body: Center(
        child: Image.asset(GLASSES_IMG),
      ),
    );
  }
}
