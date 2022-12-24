import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secureshare/helper/common.dart';
import 'package:path/path.dart' as path;
import 'package:secureshare/screens/all_file.dart';
import 'package:secureshare/screens/myupload.dart';
import 'package:secureshare/screens/received.dart';
import 'package:secureshare/services/database_service.dart';
import 'package:secureshare/widget/navbar.dart';

import '../constant.dart';
import '../services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'Home';
  final bool wantTouchId;
  final String email;
  final String password;

  HomeScreen(
      {required this.wantTouchId, required this.email, required this.password});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _icons = [
    'assets/all.png',
    'assets/myupload1.png',
    'assets/sharewithme.png',
  ];

  final List<String> _iconname = [
    'All',
    'Myupload',
    'Received',
  ];
  final List screen = [
    All(),
    const MyUpload(),
    const Recived(),
  ];

  AuthService authService = AuthService();
  final LocalAuthentication auth = LocalAuthentication();
  final storage = FlutterSecureStorage();
  bool _isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.wantTouchId) {
      authenticate();
    }
  }

  void authenticate() async {
    final canCheck = await auth.canCheckBiometrics;
    try {
      if (canCheck) {
        if (Platform.isAndroid) {
          //Finger print
          final authenticated = await auth.authenticate(
            localizedReason:
                'Enable Fingerprint to secure your file and login easily',
          );
          options:
          const AuthenticationOptions(biometricOnly: true);

          if (authenticated) {
            storage.write(key: 'email', value: widget.email);
            storage.write(key: 'password', value: widget.password);
            storage.write(key: 'usingbiometric', value: 'true');
          }
          //Face Id;
          auth.authenticate(
              localizedReason: 'Enable face Id to sign in more easily');
        }
      }
    } on PlatformException catch (e) {
      // ignore: use_build_context_synchronously
      showSnakBar(context, Colors.red, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.wantTouchId) {}
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Constant().kscaffoldbgcolor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'HOMEPAGE',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
        ),
        centerTitle: true,
      ),
      drawer: const Navbar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 12.0,
              ),
              shrinkWrap: true,
              itemCount: _icons.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screen[index]),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.12,
                          child: Image.asset(_icons[index]),
                        ),
                        Text(
                          _iconname[index],
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constant().kprimaryColor,
        onPressed: () {
          selectImage();
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }

  Future selectImage() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: _isloading
                ? Scaffold(
                    body: Center(
                      child: SpinKitCircle(
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      ),
                    ),
                  )
                : Container(
                    height: 220,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          Text(
                            'Select Image From!',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await pickGallery();
                                },
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Image.asset(
                                        'assets/gallery.png',
                                        height: 60,
                                        width: 60,
                                      ),
                                      Text(
                                        'Gallery',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await pickCamera();
                                },
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Image.asset(
                                        'assets/camera.png',
                                        height: 60,
                                        width: 60,
                                      ),
                                      Text(
                                        'Camera',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 18.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (pickedImage == null)
                                  showSnakBar(context, Colors.red,
                                      "please select Image");
                                addFile();
                              },
                              child: Text(
                                "Upload",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
      },
    );
  }

  final picker = ImagePicker();
  XFile? pickedImage;
  String? url;

  //picked image from camera
  Future<void> pickCamera() async {
    try {
      var image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
      setState(() {
        pickedImage = image;
      });
    } catch (e) {
      showSnakBar(
        context,
        Colors.red,
        e.toString(),
      );
    }
  }

  //picked image from gallery
  Future<void> pickGallery() async {
    try {
      var image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
      setState(() {
        pickedImage = image;
      });
    } catch (e) {
      showSnakBar(
        context,
        Colors.red,
        e.toString(),
      );
    }
  }

  FirebaseStorage fs = FirebaseStorage.instance;

  Future<void> addFile() async {
    setState(() {
      _isloading = true;
    });
    final String fileName = path.basename(pickedImage!.path);
    File imageFile = File(pickedImage!.path);
    final id = FirebaseAuth.instance.currentUser!.uid;

    try {
      await fs
          .ref()
          .child('file')
          .child(id)
          .child(fileName)
          .putFile(imageFile)
          .then(
            (_) => print("Image Added"),
          );

      final url = await fs
          .ref()
          .child('file')
          .child(id)
          .child(fileName)
          .getDownloadURL();

      await DatabaseService(uid: id)
          .savingFile(url, pickedImage!.name)
          .whenComplete(() {
        setState(() {
          _isloading = false;
        });
      });
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      showSnakBar(context, Colors.green, "File Added");
    } on FirebaseException catch (e) {
      showSnakBar(context, Colors.red, e.message);
    }
  }
}
