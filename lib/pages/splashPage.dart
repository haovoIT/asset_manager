import 'package:assets_manager/classes/motion_widget.dart';
import 'package:assets_manager/component/app_images.dart';
import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/pages/initPage.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class IntroPageWithMotion extends StatefulWidget {
  @override
  _IntroPageWithMotionState createState() => _IntroPageWithMotionState();
}

class _IntroPageWithMotionState extends State<IntroPageWithMotion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Motion<Column>(
                durationMs: 4000,
                children: <Widget>[
                  _buildAvatarGlow(),
                  _getItem(
                    Interval(0.25, 1),
                    child: Text(
                      SplashString.ASSET_MANAGER_EN,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  _getItem(
                    Interval(0.7, 1),
                    child: Text(
                      SplashString.WELCOME,
                      style: TextStyle(fontSize: 22.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  _getItem(
                    Interval(0.8, 1),
                    child: Text(
                      SplashString.ASSET_MANAGER_VI,
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  _getItem(
                    Interval(0.9, 1),
                    child: GestureDetector(
                      child: Container(
                        height: 60,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Colors.green,
                        ),
                        child: Center(
                            child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InitPage(),
                              ),
                            );
                          },
                          child: Text(
                            SplashString.START,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  _getItem(
                    Interval(0.95, 1.0),
                    child: Text(
                      SplashString.HAPPY,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  AvatarGlow _buildAvatarGlow() {
    return AvatarGlow(
      endRadius: 180,
      duration: Duration(seconds: 1),
      glowColor: Colors.white24,
      repeat: true,
      //repeatPauseDuration: Duration(seconds: 1),
      //startDelay: Duration(seconds: 1),
      child: Material(
          elevation: 8.0,
          shape: CircleBorder(),
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: Image.asset(AppImages.icLauncherRound),
            radius: 90.0,
          )),
    );
  }

  MotionElement _getItem(Interval interval, {required Widget child}) {
    return MotionElement(
      interval: interval,
      child: child,
    );
  }
}
