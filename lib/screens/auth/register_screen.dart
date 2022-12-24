import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:secureshare/helper/common.dart';

import '../../constant.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/custom_passwordTextField.dart';
import '../../widget/custom_button.dart';
import '../../screens/auth/login_screen.dart';
import '../../helper/extension.dart';
import '../../services/auth_services.dart';
import '../home_screen.dart';
import '../../helper/userAuthstate.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'Register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _singupformKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();

  TextEditingController name = TextEditingController();

  TextEditingController phone = TextEditingController();

  TextEditingController password = TextEditingController();

  bool isloading = false;

  AuthService authService = AuthService();

  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    name.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Constant().kscaffoldbgcolor,
      body: isloading
          ? Scaffold(
              body: Center(
                child: SpinKitCircle(
                  color: Theme.of(context).primaryColor,
                  size: 50,
                ),
              ),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_sharp)),
                      Container(
                        height: height * 0.3,
                        width: width,
                        child: Image.asset('assets/signup.png'),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Center(
                        child: Text(
                          "Signup",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Form(
                        key: _singupformKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Custom_TextField(
                                hinttext: "Enter your name",
                                labeltext: "Username *",
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z]+|\s"),
                                  ),
                                ],
                                validator: (val) {
                                  if (!val!.isValidName)
                                    return 'Enter valid name';
                                },
                                keyboardtype: TextInputType.name,
                                controller: name,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Custom_TextField(
                                hinttext: "Enter your email",
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
                                height: height * 0.02,
                              ),
                              Custom_TextField(
                                hinttext: "please enter your phone number",
                                labeltext: "Phone Number *",
                                prefixIcon: const Icon(
                                  Icons.call,
                                  color: Colors.black,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r"[0-9]"),
                                  )
                                ],
                                validator: (val) {
                                  if (!val!.isValidPhone) {
                                    return 'Enter valid phone';
                                  }
                                },
                                keyboardtype: TextInputType.phone,
                                controller: phone,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Custom_passwordTextField(
                                hinttext: "please enter your password",
                                labeltext: "Password *",
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                validator: (val) {
                                  if (!val!.isValidPassword) {
                                    return 'Enter valid password';
                                  }
                                },
                                controller: password,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Custom_button(
                                width: width,
                                height: height,
                                onpressed: () async {
                                  await register();
                                },
                                title: "Singup",
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                      text: "Already have an account? ",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "Login here",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () => Navigator.pushNamed(
                                                context, LoginScreen.routeName),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future register() async {
    if (_singupformKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });

      await authService
          .registerUserWithEmailandPassword(name.text.trim(), email.text.trim(),
              password.text.trim(), phone.text.trim())
          .then(
        (value) async {
          if (value == true) {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.routeName, (route) => false);
            showSnakBar(context, Colors.green, "Account created");
          } else {
            showSnakBar(context, Colors.red, value);
            setState(() {
              isloading = false;
            });
          }
        },
      );
    }
  }
}
