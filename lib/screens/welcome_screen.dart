import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:secureshare/screens/auth/login_screen.dart';

import '../constant.dart';
import '../wraper.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // controller
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant().kscaffoldbgcolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/lottie/splash_animation.json',
                controller: _controller, onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward().whenComplete(() => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      ),
                    });
            }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 50,
          ),
        ],
      ),
    );
  }
}

//