import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hindustan_job/candidate/pages/landing_page/home_page.dart';
import 'package:hindustan_job/candidate/pages/login_page/login_page.dart';
import 'package:hindustan_job/candidate/sharedpref/mysharedpref.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      if(UserPreference.addStringToSF(UserPreference.EMAIL)!=null){
        Home();
      }else{
        Login();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Container(
      child: Image.asset(
        "assets/splash.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
