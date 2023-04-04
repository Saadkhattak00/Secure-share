import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_auth/local_auth.dart';

import '../../constant.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/custom_passwordTextField.dart';
import '../auth/register_screen.dart';
import '../../widget/custom_button.dart';
import '../../screens/home_screen.dart';
import '../../helper/extension.dart';
import '../../services/auth_services.dart';
import '../../helper/common.dart';
import 'forgot_password_screen.dart';
import '../../constant.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'Login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginformKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isloading = false;
  bool _useTouchId = false;
  bool userHasTouchId = false;

  AuthService authService = AuthService();

  final FlutterSecureStorage storage = FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSecureStoragevalue();
  }

  void getSecureStoragevalue() async {
    final isUsingBio = await storage.read(key: 'usingbiometric');
    setState(() {
      userHasTouchId = isUsingBio == 'true';
    });
  }

  void authenticate() async {
    final canCheck = await auth.canCheckBiometrics;

    if (canCheck) {
      print("aziz called0");
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (Platform.isAndroid) {
        //Finger print
        final authenticated = await auth.authenticate(
          localizedReason:
              'Enable Fingerprint to secure your file and login easily',
        );
        if (authenticated) {
          final userStoredEmail = await storage.read(key: 'email');
          final userStorePassword = await storage.read(key: 'password');

          login(userStoredEmail.toString(), userStorePassword.toString());
        }
        //Face Id;
        auth.authenticate(
            localizedReason: 'Enable face Id to sign in more easily');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: isloading
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
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 25.0, left: 8.0, right: 8.0),
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.3,
                          width: width,
                          child: Image.asset('assets/login.jpeg'),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Form(
                          key: _loginformKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Custom_TextField(
                                  hinttext: "name@gmail.com",
                                  labeltext: "Email *",
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  // validator: (val) {
                                  //   if (!val!.isValidEmail) {
                                  //     return 'Enter valid email';
                                  //   }
                                  // },
                                  keyboardtype: TextInputType.emailAddress,
                                  controller: email,
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
                                  // validator: (val) {
                                  //   if (!val!.isValidPassword) {
                                  //     return 'please enter your password';
                                  //   }
                                  // },
                                  controller: password,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context,
                                          ForgotPasswordScreen.routeName);
                                    },
                                    child: Text(
                                      "Forgot password?",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                userHasTouchId
                                    ? InkWell(
                                        onTap: authenticate,
                                        child: const Icon(
                                          Icons.fingerprint,
                                          size: 50,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Checkbox(
                                            activeColor: Color(0xff6C63FF),
                                            value: _useTouchId,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _useTouchId = newValue!;
                                              });
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          const Text(
                                            'Use Touch ID',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                            ),
                                          )
                                        ],
                                      ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                Custom_button(
                                  width: width,
                                  height: height,
                                  onpressed: () async {
                                    login(
                                      email.text.trim(),
                                      password.text.trim(),
                                    );
                                  },
                                  title: "Login",
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Center(
                                  child: Text.rich(
                                    TextSpan(
                                        text: "Don't have an account? ",
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: "Register here",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () =>
                                                  Navigator.pushNamed(context,
                                                      RegisterScreen.routeName),
                                          ),
                                        ]),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.05,
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
            ),
    );
  }

  Future login(String email, String password) async {
    if (_loginformKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });

      await authService
          .signInwithEmailandPassword(email, password)
          .then((value) {
        if (value == true) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  wantTouchId: _useTouchId,
                  email: email.trim(),
                  password: password.trim(),
                ),
              ),
              (route) => false);
        } else {
          showSnakBar(context, Colors.red, value);
          setState(() {
            isloading = false;
          });
        }
      });
    }
  }
}
