import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:secureshare/helper/common.dart';

import '../../constant.dart';
import '../../widget/custom_textfield.dart';
import '../../helper/extension.dart';
import '../../widget/custom_button.dart';
import 'login_screen.dart';
import '../../services/auth_services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = 'forgotpassword';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController email = TextEditingController();
  final _key = GlobalKey<FormState>();

  bool isloading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return isloading
        ? Scaffold(
            body: Center(
              child: SpinKitCircle(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Constant().kscaffoldbgcolor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              title: Text(
                "Forgot Password",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 25.0, left: 8.0, right: 8.0),
                  child: Form(
                    key: _key,
                    child: Column(children: [
                      Container(
                        height: height * 0.3,
                        width: width,
                        child: Image.asset('assets/signup.png'),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Text(
                        "Forgot password",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Forgot your password? don't worry please enter your email",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Custom_TextField(
                        hinttext: "name@gmail.com",
                        labeltext: "Email *",
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        validator: (val) {
                          if (!val!.isValidEmail) {
                            return 'Enter valid email';
                          }
                        },
                        keyboardtype: TextInputType.emailAddress,
                        controller: email,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Custom_button(
                        width: width,
                        height: height,
                        onpressed: () async {
                          await resetPassword();
                        },
                        title: "Send link",
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          );
  }

  Future resetPassword() async {
    if (_key.currentState!.validate()) {
      setState(() {
        isloading = true;
      });

      authService.resetPassword(email.text.trim(), context).whenComplete(() {
        Navigator.pushNamed(context, LoginScreen.routeName);
      });
      setState(() {
        isloading = false;
      });
    }
  }
}
